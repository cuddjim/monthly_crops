library(tidyverse)

# retrieve data on railway carloadings from Statistics Canada table 23100016
# filter for crop related components
rail_cls <- get_codr(23100216) %>%
    filter(railway_carloading_components %in% c('Wheat','Canola','Other cereal grains',
                                                'Other oil seeds and nuts, other agricultural product',
                                                'Milled grain production and preparations, bakery products'))

