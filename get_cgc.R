##### Extract Canadian Grain Commission data from https://www.grainscanada.gc.ca/en/grain-research/statistics/
##### Create merged sets for all available years per report type

library(tidyverse);library(lubridate)

# get current month and year
month <- month(Sys.Date())
year <- year(Sys.Date())

base_path ='https://www.grainscanada.gc.ca/en/grain-research/statistics/'

# based on current month and year, find current crop year
crop_year <- case_when(month %in% 8:12~paste0(year,'-',as.numeric(str_sub(year,3,4))+1),
          TRUE~paste0(as.numeric(year)-1,'-',as.numeric(str_sub(year,3,4))))

# vector with beginning years of crop years from 2013 to present
y1=2013:as.numeric(str_sub(crop_year,1,4))

# list (as a data frame) with all crop years from 2013-14 to present
# and modifications to file paths that began in 2018
crop_years_list <- data.frame(y1,y2=str_sub(y1+1,3,4)) %>% unite(list_of_crop_years,c(y1,y2),sep = '-', remove = F) %>% 
    mutate(list_of_crop_years = 
               case_when(y1<2018~paste0(list_of_crop_years,'/csv/gsw-shg-en.csv'),
                         TRUE~paste0(list_of_crop_years,'/gsw-shg-en.csv')))

# list of csv urls from 2013-14 to present for GSW report
url_list_gsw <- lapply(crop_years_list$list_of_crop_years, function(x) paste0(base_path,'grain-statistics-weekly/',x))


# bind all csvs from 2013-14 crop year to present to obtain merged GSW data
gsw_dat <- purrr::map_df(url_list_gsw, function(x) read_csv(x) %>% 
                             janitor::clean_names() %>% 
                             mutate(ktonnes = as.numeric(ktonnes),
                                    week_ending_date = as.Date(week_ending_date, format = '%d/%m/%Y')))

# list of csv urls from 2018-19 to present for Weekly Producer Car Allocation
url_list_cgc_prd_cars <- lapply((crop_years_list %>% filter(y1 > 2017))$list_of_crop_years %>% 
                                    sub('-','-20',.) %>% gsub('/gsw-shg-en.csv','/csv/pca-hwp-en.csv',.),
                                function(x) paste0(base_path,'producer-car/',x))

# bind all csvs from 2018-19 crop year to present to obtain merged producer car data
prd_car_dat <- purrr::map_df(url_list_cgc_prd_cars, function(x) read_csv(x) %>% 
                                 janitor::clean_names() %>% 
                                 mutate(week_ending_date = as.Date(week_ending_date, format = '%d/%m/%Y')) %>% 
                                 dplyr::rename('crop_year' = crop_yr,'worksheet' = 'work_sheet'))
