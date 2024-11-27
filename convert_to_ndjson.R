#### Small Helper Script to Rewrite csv to JSON ####
## CSV is a typically poor data interchange format
## the simplifying assumption is that data will 
## land as .ndjson in an S3 location

#### Instructions:
## CSV data as provided lives wherever you like 
## running this code as-is will read from /data, convert to .ndjson
## and write to data_cleaned/data/<table>/file.ndjson
## from there, load it to your preferred s3 location

library(data.table)
library(stringr)
library(jsonlite)

## relative pathing due to project config, "/your/path/here"
in_dirs <-  list.files("data", full.names = T)
in_files <- lapply(in_dirs, list.files, full.names = T)


names(in_files) <- list.files("data")

## column orders have been shuffled around, let's clean all those
## and rewrite them
## ASSUMPTION
# data to ingest should be clean and consistent if CSV (columns not shuffled around, same columns..)
# or the whole thing as a JSON blob, as there's nested JSON anyway..
# let's read these in and persist JSON which will be easier to work with

to_ndjson <- function(in_dt) {
  
  # Convert each row to JSON and concatenate with newlines
  ndjson <- paste(
    apply(in_dt, 1, function(row) {
      jsonlite::toJSON(as.list(row), auto_unbox = TRUE)
    }),
    collapse = "\n"
  )
  
  return(ndjson)
}



rewrite_json <- function(in_name) {
  
  print(sprintf("Processing %s", in_name))
  
  in_path <- in_files
  in_dat <- lapply(in_files[[in_name]], fread) 
  
  out_dat <- lapply(in_dat, to_ndjson)
  
  ## relative pathing due to project config, "/your/path/here"
  out_dir <- sprintf("data_cleaned/data/%s", in_name)
  
  dir.create(out_dir)
  
  for(i in seq_along(out_dat)) {
    out_path <- gsub("csv", "ndjson", sprintf("data_cleaned/%s", in_files[[in_name]][i]))
    print(out_path)
    writeLines(out_dat[[i]], out_path)
  }
  
  
  
}

## call reorder_cols and write that out

sapply(names(in_files), function(x) rewrite_json(in_name = x))


           