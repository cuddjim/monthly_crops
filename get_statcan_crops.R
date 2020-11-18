library(tidyverse)

# National S&D (32100013)
# farm S&D (32100015)
# Crop area, yield, and production (32100359)
# Crop - small area data (32100002)
# Crop - stocks (32100007)

table_list <- c(32100013,32100015,32100359,32100002,32100007)
table_names <- c('natl_snd','farm_snd','crop_ayp','sad_crop','stocks')

# use get_codr function to retrieve raw Statistics Canada CODR tables from table_list
dat <- lapply(table_list, get_codr) %>% 
    setNames(table_names)

