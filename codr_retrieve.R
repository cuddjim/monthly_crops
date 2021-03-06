library(tidyverse);library(httr)

## create function to retrieve specific NDM zip folder

get_product_download_url <- function(pid) {
    
    url <- paste0('https://www150.statcan.gc.ca/t1/wds/rest/getFullTableDownloadCSV/', pid, '/en')
    
    request <- GET(url)
    
    response <- content(request)
    
    if (response$status == "SUCCESS") {
        
        result <- response$object
        
    } else {
        
        print("ERROR")
        
    }
    
    return(result)
    
}

#create temp file name, download the zip file(s);
# read in the csv(s) (zip file(s) also contains  metadata file(s)), unlink the temp file

get_codr <- function(pid) {

temp <- tempfile()

download.file(get_product_download_url(pid),temp)

dat <- read.csv(unz(temp,paste0(pid,".csv")),encoding='UTF-8') %>% 
    mutate(GEO = stringi::stri_trans_general(GEO, "Latin-ASCII")) %>% 
    janitor::clean_names() %>% dplyr::rename_at(1,~'ref_date')

unlink(temp)

dat

}



