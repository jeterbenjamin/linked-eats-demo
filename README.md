# Linked Eats: Senior Data Engineer Take-Home

## Overall Design & Access
- Data is exposed via Starburst Galaxy (managed Trino service)
- You will receive an onboarding email with restricted permissions to my deployed cluster 
- Raw (provided) data has been transformed to .ndjson and loaded to an s3 location
- External tables query the json blobs
- Data is transformed into Iceberg format backed by ORC files (Parquet or Avro work fine too)

## Simplifying Assumptions
1: Data is delivered in `.ndjson` vs `csv` <- this greatly simplifies DDL, and CSV as a data interchange format isn't ideal; code is supplied in `convert_to_ndjson.R` to do so, and is commented.
2: `orders_ib` is fully specified as an Iceberg table which is created from the external table (see below); `order_items` is also an Iceberg table, and to satisfy incremental refresh it's trivial to schedule `refresh materialized view <whatever>` on a cron; as the default platform config is to use Iceberg, incremental refresh is supported; see `/sql/ddl/order_items.sql` for further details
3: DDL for all _external_ tables is provided (`/sql/ddl/`), but in order to keep the scope of this _very long_ take home within reason I've provided this as an example.

```
-- create an iceberg table; query engine defaults to iceberg
-- this can of course be changed to whatever format (ORC, Parquet, Avro, ..)
-- moving to a different schema, `xform_ib`
CREATE TABLE "linked_eats_demo"."xform_ib"."orders_ib"
as
select distinct
    "restaurant_id"
    , customer_id
    , organization_id
    , sauce_order_id
    , platform_order_id
    , sauce_item_order_ids
    , PARSE_DATETIME(order_date_utc, 'M/d/yyyy, hh:mm:ss a') as order_date_utc
    , timezone
    , platform
    , channel
    , cast(replace(ticket_size, ' ', '') as DECIMAL(38, 2)) as ticket_size
    , cast(replace(basket_size, ' ', '') as DECIMAL(38, 2)) as basket_size
    , cast(replace(sub_total, ' ', '') as DECIMAL(38, 2)) as sub_total
    , cast(replace(average_item_value, ' ', '') as DECIMAL(38, 2)) as average_item_value
    , cast(replace(restaurant_income, ' ', '') as DECIMAL(38, 2)) as restaurant_income
    , cast(replace(markup_discount, ' ', '') as DECIMAL(38, 2)) as markup_discount
    , cast(replace(markup, ' ', '') as DECIMAL(38, 2)) as markup
    , cast(replace(discount, ' ', '') as DECIMAL(38, 2)) as discount
    , strategies
    , events
    , raworderdetails
from linked_eats_demo.landing_zone.orders;
```


### Pipeline Code & Documentation
I have configured a basic free cluster using Starurst Galaxy with a minimal permission set for you to access.

There are queries in /sql/ddl/ to create these external tables

#### What's an external table?
These are defined with appropriate DDL to allow quering the raw files directly from the object store (s3)

Trino has scan-on-query semantics, so new data will show up in `landing_zone` queries as soon as it's loaded to S3
