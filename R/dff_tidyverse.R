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
### CALCULATE MULTILATERAL INDEXES
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

# Create matrices from completed data (GEKS/CCDI, GK)
temp_data <- move_monthly %>%
  ungroup() %>%
  complete(
    nesting(COM_CODE, NITEM),
    MONTH
  )
temp_price <- temp_data %>%
  select(
    COM_CODE, NITEM,
    MONTH,
    PRICE
  ) %>%
  pivot_wider(
    names_from = c(COM_CODE, NITEM),
    values_from = PRICE
  ) %>%
  select(
    -MONTH
  ) %>%
  as.matrix()
temp_move <- temp_data %>%
  select(
    COM_CODE, NITEM,
    MONTH,
    MOVE
  ) %>%
  pivot_wider(
    names_from = c(COM_CODE, NITEM),
    values_from = MOVE
  ) %>%
  select(
    -MONTH
  ) %>%
  as.matrix()
temp_share <- temp_data %>%
  select(
    COM_CODE, NITEM,
    MONTH,
    SHARE
  ) %>%
  pivot_wider(
    names_from = c(COM_CODE, NITEM),
    values_from = SHARE
  ) %>%
  select(
    -MONTH
  ) %>%
  as.matrix()
temp_sales <- !is.na(temp_share) # Record indicator (0/1)
temp_month <- nrow(temp_share) # Number of months
temp_nitem <- ncol(temp_share) # Number of products
temp_indexes <- matrix(NA, temp_month, 4) # GEKS, CCDI, GK, and TPD

# Calculate GEKS (Fisher) and CCDI (Tornqvist) indexes
temp_matrix <- array(0, dim = c(temp_month, temp_month, 6))
for (r in 1:(temp_month - 1)) {
  for (c in (r + 1):temp_month) {
    temp_matrix[r, c, 3:6] = c(
      log(sum(replace_na(temp_share[r, ], 0) / sum(replace_na(temp_share[r, ], 0) * temp_sales[c, ]) * replace_na(temp_price[c, ] / temp_price[r, ], 0))), # log(Laspeyres index)
      log(sum(replace_na(temp_share[c, ], 0) / sum(replace_na(temp_share[c, ], 0) * temp_sales[r, ]) * replace_na((temp_price[c, ] / temp_price[r, ])^(-1), 0))^(-1)), # log(Paasche index)
      sum(replace_na(temp_share[r, ], 0) / sum(replace_na(temp_share[r, ], 0) * temp_sales[c, ]) * replace_na(log(temp_price[c, ] / temp_price[r, ]), 0)), # log(Geometric Laspeyres index)
      sum(replace_na(temp_share[c, ], 0) / sum(replace_na(temp_share[c, ], 0) * temp_sales[r, ]) * replace_na(log(temp_price[c, ] / temp_price[r, ]), 0)) # log(Geometric Paasche index)
    )
    temp_matrix[r, c, 1:2] = c(
      1 / 2 * (temp_matrix[r, c, 3] + temp_matrix[r, c, 4]), # log(Fisher index)
      1 / 2 * (temp_matrix[r, c, 5] + temp_matrix[r, c, 6]) # log(Tornqvist index)
    )
    temp_matrix[c, r, 1:2] = -temp_matrix[r, c, 1:2] # Time reversibility
  }
}
temp_index <- apply(temp_matrix[, , 1:2], c(2, 3), mean)
temp_indexes[, 1:2] <- 100 * exp(temp_index - matrix(temp_index[1, ], temp_month, 2, byrow = TRUE))

# Calculate Geary-Khamis index
temp_matrix <- array(0, dim = c(temp_nitem, temp_nitem, 2))
for (r in 1:temp_month) {
  temp_matrix[, , 1] = temp_matrix[, , 1] + diag(replace_na(temp_move[r, ], 0))
  temp_matrix[, , 2] = temp_matrix[, , 2] + replace_na(temp_share[r, ], 0) %*% t(replace_na(temp_move[r, ], 0))
}
temp_eigen <- c( # Solution to homogeneous linear equation system -- Normalization of last 'reference price' to 1
  solve(
    (solve(temp_matrix[, , 1]) %*% temp_matrix[, , 2] - diag(temp_nitem))[1:(temp_nitem - 1), 1:(temp_nitem - 1)],
    -(solve(temp_matrix[, , 1]) %*% temp_matrix[, , 2] - diag(temp_nitem))[1:(temp_nitem - 1), temp_nitem]
  ),
  1
)
temp_index <- rowSums(replace_na(temp_share * (temp_price / matrix(temp_eigen, temp_month, temp_nitem, byrow = TRUE))^(-1), 0))^(-1)
temp_indexes[, 3] <- 100 * (temp_index / temp_index[1])

# Calculate time-product dummy index
temp_model <- lm(
  log(PRICE) ~
    factor(MONTH) +
    interaction(COM_CODE, NITEM),
  move_monthly,
  weights = SHARE
)
temp_index <- c(
  0,
  coef(temp_model)[2:temp_month]
)
temp_indexes[, 4] <- 100 * exp(temp_index)

# Plot time series
index_monthly <- bind_cols(
  MONTH = as.Date(
    levels(
      factor(
        move_monthly$MONTH
      )
    )
  ),
  INDEX_GEKS = temp_indexes[, 1],
  INDEX_CCDI = temp_indexes[, 2],
  INDEX_GK = temp_indexes[, 3],
  INDEX_TPD = temp_indexes[, 4]
)
rm(list = c(ls(pattern = '^temp'), 'r', 'c'))
index_monthly %>%
  pivot_longer(
    cols = starts_with('INDEX_'),
    names_to = 'METHOD',
    names_prefix = 'INDEX_',
    values_to = 'INDEX'
  ) %>%
  ggplot(
    aes(
      MONTH,
      INDEX,
      color = METHOD
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
    minor_breaks = NULL
  ) +
  labs(
    title = 'Multilateral indexes for the bottled juice category',
    subtitle = 'Oct 1989 = 100, log scale',
    caption = 'Sources: Dominick\'s Finer Foods Data Set; and IMF staff calculations.'
  )
