setwd("C:/Data")

#UPC

upc <- read.csv("upcbjc.csv")
upc$DESCRIP <- upc$SIZE <- upc$CASE <- NULL

#MOVE

move <- read.csv("wbjc.csv")
move$SALES <- move$PRICE * move$MOVE / move$QTY
move0 <- subset(move, PRICE > 0 & OK == 1)
move0$PRICE <- move0$PRICE_HEX <- move0$QTY <- move0$PROFIT <- move0$PROFIT_HEX <- move0$OK <- NULL

#WEEKS & STORES

weeks <- read.csv("weeks.csv", header = FALSE, col.names = c("WEEK", "START", "END", "SPECIAL_EVENTS"))
weeks$START <- as.Date(weeks$START, format = "%m/%d/%y")
weeks$END <- as.Date(weeks$END, format = "%m/%d/%y")
weeks$MONTH <- as.Date(paste(format(weeks$END, "%Y"), format(weeks$END, "%m"), "01", sep = "-"))
weeks$MONTH1 <- ifelse(months(weeks$START) == months(weeks$END), weeks$MONTH, NA)
weeks$MONTH1 <- as.Date(weeks$MONTH1, origin = "1970-01-01")
weeks$WEEK1 <- ifelse(is.na(weeks$MONTH1), NA, with(weeks, ave(rep(1, nrow(weeks)), MONTH1, FUN = seq_along)))
stores <- read.csv("stores.csv", header = FALSE, col.names = c("STORE", "CITY", "PRICE_TIER", "ZONE", "ZIP_CODE", "ADDRESS"))

#MERGE W/ MOVE & UPC

move_weeks <- merge(move0, weeks, by = "WEEK", all.x = TRUE)
move_weeks$START <- move_weeks$END <- move_weeks$SPECIAL_EVENTS <- NULL
move_weeks_stores <- merge(move_weeks, stores, by = "STORE", all.x = TRUE)
move_weeks_stores$CITY <- move_weeks_stores$ZIP_CODE <- move_weeks_stores$ADDRESS <- NULL
move_weeks_stores_upc <- merge(move_weeks_stores, upc, by = "UPC", all.x = TRUE)

#REPLACE W/ DUMMIES

move_weeks_stores_upc$NITEM <- ifelse(is.na(move_weeks_stores_upc$NITEM) | move_weeks_stores_upc$NITEM < 0, move_weeks_stores_upc$UPC, move_weeks_stores_upc$NITEM)
move_weeks_stores_upc$COM_CODE <- ifelse(is.na(move_weeks_stores_upc$COM_CODE), 999, move_weeks_stores_upc$COM_CODE)
move_weeks_stores_upc$PRICE_TIER <- ifelse(move_weeks_stores_upc$PRICE_TIER == "", NA, move_weeks_stores_upc$PRICE_TIER)
move_weeks_stores_upc$ZONE <- ifelse(is.na(move_weeks_stores_upc$ZONE), 0, move_weeks_stores_upc$ZONE)
move_weeks_stores_upc$SALE <- ifelse(move_weeks_stores_upc$SALE == "", 0, 1)

#AGGREGATION

move_weeks_stores_upc$MONTH1 <- move_weeks_stores_upc$WEEK <- move_weeks_stores_upc$WEEK1 <- move_weeks_stores_upc$PRICE_TIER <- move_weeks_stores_upc$ZONE <- move_weeks_stores_upc$STORE <- move_weeks_stores_upc$UPC <- move_weeks_stores_upc$SALE <- NULL
move_monthly0 <- aggregate(. ~ COM_CODE + MONTH + NITEM, move_weeks_stores_upc, sum)
move_monthly <- subset(move_monthly0, MONTH >= as.Date("1989-10-01") & MONTH <= as.Date("1997-04-01"))

#EXPORT

write.csv(move_monthly, file = "move_monthly.csv", quote = FALSE, row.names = FALSE)

#UNIT VALUES

move_monthly$PRICE <- move_monthly$SALES / move_monthly$MOVE
move_monthly$LOGPRICE <- log(move_monthly$PRICE)

#EXPENDITURE SHARES

move_monthly1 <- aggregate(SALES ~ MONTH, move_monthly, sum)
names(move_monthly1)[names(move_monthly1) == "SALES"] <- "TOTAL"
move_monthly <- merge(move_monthly, move_monthly1, by = "MONTH")
move_monthly$SHARE <- move_monthly$SALES / move_monthly$TOTAL

#REGRESSION

wtpd <- lm(LOGPRICE ~ factor(MONTH) + interaction(COM_CODE, NITEM), data = move_monthly, weights = SHARE)
wtpd1 <- as.data.frame(coef(wtpd))