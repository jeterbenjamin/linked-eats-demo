# Linked Eats: Senior Data Engineer Take-Home

## Overall Design & Access
- Data is exposed via Starburst Galaxy (managed Trino service)
 - 
- Raw (provided) data has been transformed to .ndjson and loaded to an s3 location
- External tables query the json blobs
 - Data is transformed into Iceberg format backed by ORC files (Parquet or Avro work fine too)
 - 
