url_data = readLines("data/house_price.url")

# To initialise, change download flag in "conf/conf.yml" to TRUE
flag_download = config$download
years = config$years
colnames = config$data_specification$dt_house_prices$colnames
filepath = config$data_specification$dt_house_prices$save_as
# Build all s3 links
urls = lapply(years, function(year) url_data %format% list(year = year))

if (flag_download) {
  # Read all s3 files and bind into one dataset
  dt = lapply(urls, fread, header = FALSE) %>% rbindlist()
  # Rename columns
  data.table::setnames(dt, names(colnames), unlist(colnames, use.names = FALSE))
  # Write to cache for easy loading next time
  fst::write.fst(dt, filepath)
  message("Data written to 'cache/'")
} else if (file.exists(filepath)) {
  dt = fst::read.fst(filepath, as.data.table = TRUE)
  message("Data read from 'cache/'")
} else {
  message("Initialise data in 'cache/' by changing download flag in 'conf/conf.yml' to TRUE")
}

# Clean the workspace
rm(colnames)
rm(years)
rm(flag_download)
rm(url_data)
rm(urls)