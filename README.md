# Linked Eats: Senior Data Engineer Take-Home

## Overall Design & Access
- Data is exposed via Starburst Galaxy (managed Trino service)
- This platform integrates cleanly with your current infrastructure (connects trivially with Redshift and about 30 other sources https://trino.io/docs/current/connector/redshift.html)
- Metabase fully supports Trino
- You will receive an onboarding email with restricted permissions to my deployed cluster
- Access to the deployed cluster will be available until I hear back from you or 14 days
- Raw (provided) data has been transformed to .ndjson and loaded to an s3 location
- External tables query the json blobs
- Data is transformed into Iceberg format backed by ORC files (Parquet or Avro work fine too)

## Simplifying Assumptions
- 1: Data is delivered in `.ndjson` vs `csv` <- this greatly simplifies DDL, and CSV as a data interchange format isn't ideal; code is supplied in `convert_to_ndjson.R` to do so, and is commented.
- 2: `orders_ib` is fully specified as an Iceberg table which is created from the external table (see below); `order_items` is also an Iceberg table, and to satisfy incremental refresh it's trivial to schedule `refresh materialized view <whatever>` on a cron; as the default platform config is to use Iceberg, incremental refresh is supported; see `/sql/ddl/order_items.sql` for further details
- 3: DDL for all _external_ tables is provided (`/sql/ddl/`), but in order to keep the scope of this _very long_ take home within reason I've provided this as an example.
- 4: The provided code all works and has been run; you're free to use the environment with the free cluster (**this has a 1 hour timeout; warm-starting the cluster takes a minute or two**) 
- 5: There is no specific physical data model, as the data is small & it's not necessary. Typically this is an important step, but I've skipped that here as well to keep time and effort manageable.

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

### Run Instructions
Create a user (check your e-mail) and you're free to play with the exposed environment.

There is no code to run, though the DDL is documented (the CTAS statments expect `.ndjson` in S3 with a directory for each data set if you'd really like to run this). 

This is a simplified but fully scalable and usable data platform environment.

### Unified Datasets
- External tables (queries JSON as described above) are available in the `landing_zone` schema
- `xform_ib` houses Iceberg tables (`orders`, `order_items`, and a materialized view of `order_items` for incremental loads.

### Output
#### Task 4
```
-- Top 10 Restaurants by Revenue for a Specified Day
SELECT
    restaurant_id
    , SUM(restaurant_income) AS total_income
FROM linked_eats_demo.xform_ib.orders_ib
where date(order_date_utc) = date('2024-04-28') -- or whatever
GROUP BY restaurant_id, date(order_date_utc)
ORDER BY total_income DESC
LIMIT 10;
```
<img width="873" alt="image" src="https://github.com/user-attachments/assets/f2aa1ef1-fb32-486d-b5ea-c8706380bb3c">

```
-- Daily Revenue for a Specific Restaurant
SELECT
    restaurant_id
    , date(order_date_utc) as order_date
    , SUM(restaurant_income) AS total_income
FROM linked_eats_demo.xform_ib.orders_ib
where restaurant_id = '6477e6a03156e81fcac44392' -- or whatever
GROUP BY restaurant_id, date(order_date_utc)
ORDER BY date(order_date_utc) DESC;
```
<img width="862" alt="image" src="https://github.com/user-attachments/assets/439ef044-16cb-4f2f-85ca-f85621edba6d">


See `/data_profiles` for some high-level analysis of the data sets, including fields (distributions, NA values, that sort of thing), correlations, etc. Further analysis has been treated as out of scope, as this take home is very lengthy already; I'm happy to discuss whatever you'd like WRT data analysis on a call.

### Other Notes
#### Data Quality
- This is something best conducted with business context; I have not fully modeled the data (you are exposing PII in the form of phone numbers in the `orders` data under `customer_id`)

- Task 1, Section 2: Validate: I have not diagrammed or modeled this data; the system design assumes that data should be loaded as provided (with the exception of type conversion, see note about CSV above). I'm well versed in data modeling and data quality checks, and would be happy to discuss strategy with you on a call.

- Storage: Iceberg tables backed by ORC files

#### Scale
- Trino deployments processing petabyte-scale data are fairly common
- Starburst Galaxy supports streaming from a Kafka topic directly to an Iceberg table at ~100GB/s if streaming data is a requirement.

##### Pipeline Design Scale
- This specific data ingestion isn't, as such, the most efficient way to ingest data but is plenty fast.
- I'm happy to discuss on a call what would need to change both WRT physical data modeling, source system, and at the access layer & have professional references who will corroborate that I know what I'm doing.

##### "Bonus"
- I'm happy to discuss how I'd go about doing these things, but this feels a bit orthogonal to assessing data architecture and engineering skills.
