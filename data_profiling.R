#### Using pointblank to generate an overall DQ profile

library(data.table)
library(stringr)
library(jsonlite)
library(pointblank)

## relative pathing due to project config, "/your/path/here"
in_dirs <-  list.files("data", full.names = T)
in_files <- lapply(in_dirs, list.files, full.names = T)


names(in_files) <- list.files("data")

in_dat <- lapply(in_files[["strategies"]], fread)

in_dat <- rbindlist(in_dat, fill = TRUE)

profile <- scan_data(in_dat)
