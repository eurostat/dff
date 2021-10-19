###
### SET-UP R
###

# Install packages and set options
install.packages('tidyverse')
library(tidyverse)
options(scipen = 999)
rm(list = ls())

# Set working directory
setwd('C:/Users/JMehrhoff/Desktop/DFF')

# Set Dominick's category
category <- 'bjc'

###
### LOAD DATA
###

# Read movement file
# zzfil <- tempfile()
# download.file(
#   paste0(
#     'https://www.chicagobooth.edu/-/media/enterprise/centers/kilts/datasets/dominicks-dataset/movement_csv-files/w',
#     category,
#     '.zip'
#   ),
#   zzfil
# )
# zz <- unz(
#   zzfil,
#   paste0(
#     'w',
#     category,
#     '.csv'
#   )
# )
# move <- read_csv(zz)
# unlink(zzfil)
move <- read_csv(
  paste0(
    'w',
    category,
    '.csv'
  )
) %>%
  filter(
    OK == 1 & PRICE > 0
  ) %>%
  mutate(
    SALES = PRICE * MOVE / QTY
  ) %>%
  select(
    WEEK,
    STORE,
    UPC,
    MOVE,
    SALES,
    SALE,
    # PROFIT
  )

# Read UPC file
# upc <- read_csv(
#   paste0(
#     'https://www.chicagobooth.edu/-/media/enterprise/centers/kilts/datasets/dominicks-dataset/upc_csv-files/upc',
#     category,
#     '.csv'
#   )
# )
upc <- read_csv(
  paste0(
    'upc',
    category,
    '.csv'
  )
) %>%
  select(
    COM_CODE,
    NITEM,
    UPC,
    # DESCRIP,
    # SIZE
  )

# Read weeks file
# weeks <- read_csv(
#   'https://raw.githubusercontent.com/eurostat/dff/master/CSV/weeks.csv',
#   col_names = c('WEEK', 'START', 'END', 'SPECIAL_EVENTS')
# )
weeks <- read_csv(
  'weeks.csv',
  col_names = c(
    'WEEK',
    'START',
    'END',
    'SPECIAL_EVENTS'
  )
) %>%
  mutate(
    START = as.Date(
      START,
      format = '%m/%d/%y'
    ),
    END = as.Date(
      END,
      format = '%m/%d/%y'
    ),
    MONTH = as.Date(
      paste(
        format(END, '%Y'),
        format(END, '%m'),
        '01',
        sep = '-'
      )
    ),
    MONTH1 = as.Date(
      ifelse(
        months(START) == months(END),
        MONTH,
        NA
      ),
      origin = '1970-01-01'
    ),
    WEEK1 = ifelse(
      !is.na(MONTH1),
      ave(
        rep(1, max(WEEK)),
        MONTH1,
        FUN = seq_along
      ),
      NA
    )
  ) %>%
  select(
    WEEK,
    MONTH,
    MONTH1,
    WEEK1,
    # START,
    # END,
    # SPECIAL_EVENTS
  )

# Read stores file
# stores <- read_csv(
#   'https://raw.githubusercontent.com/eurostat/dff/master/CSV/stores.csv',
#   col_names = c('STORE', 'CITY', 'PRICE_TIER', 'ZONE', 'ZIP_CODE', 'ADDRESS')
# )
stores <- read_csv(
  'stores.csv',
  col_names = c(
    'STORE',
    'CITY',
    'PRICE_TIER',
    'ZONE',
    'ZIP_CODE',
    'ADDRESS'
  )
) %>%
  select(
    STORE,
    PRICE_TIER,
    ZONE,
    # CITY,
    # ZIP_CODE,
    # ADDRESS
  )

###
### Merge all files
###

# Merge movement file with UPC, weeks, and stores files
move <- move %>%
  left_join(
    upc,
    by = 'UPC'
  ) %>%
  left_join(
    weeks,
    by = 'WEEK'
  ) %>%
  left_join(
    stores,
    by = 'STORE'
  )
rm(list = c('upc', 'weeks', 'stores'))

# Replace NA's with dummies
move <- move %>%
  mutate(
    SALE = if_else(
      !is.na(SALE),
      1,
      0
    ),
    COM_CODE = if_else(
      !is.na(COM_CODE),
      COM_CODE,
      999
    ),
    NITEM = if_else(
      !is.na(NITEM) & NITEM >= 0,
      NITEM,
      UPC
    ),
    PRICE_TIER = if_else(
      !is.na(PRICE_TIER),
      PRICE_TIER,
      'NA'
    ),
    ZONE = if_else(
      !is.na(ZONE),
      ZONE,
      0
    )
  )

###
### CALCULATE TPD INDEX
###

# Aggregate across UPCs, weeks, and stores
move_monthly <- move %>%
  filter(
    between(
      MONTH,
      as.Date('1989-10-01'),
      as.Date('1997-04-01')
    )
  ) %>%
  group_by(
    COM_CODE, NITEM,
    MONTH,
    # STORE
  ) %>%
  summarise(
    MOVE = sum(MOVE),
    SALES = sum(SALES)
  )

# Export analysis-ready data
write_csv(
  move_monthly,
  paste0(
    'ard',
    category,
    '.csv'
  ),
  na = ''
)

# Calculate unit values and expenditure shares
move_monthly <- move_monthly %>%
  group_by(
    MONTH
  ) %>%
  mutate(
    PRICE = SALES / MOVE,
    SHARE = SALES / sum(SALES)
  )

# Calculate (weighted) time-product dummy index
temp_model <- lm(
  log(PRICE) ~
    factor(MONTH) +
    interaction(COM_CODE, NITEM),
  move_monthly,
  weights = SHARE
)
index_monthly <- bind_cols(
  MONTH = as.Date(
    levels(
      factor(
        move_monthly$MONTH
      )
    )
  ),
  INDEX = 100 * exp(
    c(
      0,
      coef(temp_model)[2:91]
    )
  )
)
rm(temp_model)

# Plot time series
index_monthly %>%
  ggplot(
    aes(
      MONTH,
      INDEX
    )
  ) +
  geom_line() +
  scale_x_date(
    name = NULL,
    date_breaks = '1 year',
    date_labels = '%Y',
    minor_breaks = NULL
  ) +
  scale_y_log10(
    name = NULL,
    breaks = seq(95, 125, by = 5),
    minor_breaks = NULL
  ) +
  labs(
    title = 'Time-product dummy index for the bottled juice category',
    subtitle = 'Oct 1989 = 100, log scale',
    caption = 'Sources: Dominick\'s Finer Foods Data Set; and IMF staff calculations.'
  )
