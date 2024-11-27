CREATE TABLE "linked_eats_demo"."landing_zone"."orders" (
    "restaurant_id" varchar,
    "customer_id" varchar,
    "organization_id" varchar,
    "sauce_order_id" varchar,
    "platform_order_id" varchar,
    "sauce_item_order_ids" varchar,
    "order_date_utc" varchar,
    "timezone" varchar,
    "platform" varchar,
    "channel" varchar,
    "ticket_size" varchar,
    "basket_size" varchar,
    "sub_total" varchar,
    "average_item_value" varchar,
    "restaurant_income" varchar,
    "markup_discount" varchar,
    "markup" varchar,
    "discount" varchar,
    "strategies" varchar,
    "events" varchar,
    "raworderdetails" varchar
)
WITH (
    type = 'hive',
    format = 'JSON',
    external_location = 's3://jeter-linked-eats-demo/landing-zone/data/orders/'
);

-- create an iceberg table; query engine defaults to iceberg
-- this can of course be changed to whatever format (ORC, Parquet, Avro, ..)
-- moving to a different schema, `xform_ib`
CREATE TABLE "linked_eats_demo"."xform_ib"."orders_ib"
as
select
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
    , cast(replace(ticket_size, ' ', '') as DECIMAL) as ticket_size
    , cast(replace(basket_size, ' ', '') as DECIMAL) as basket_size
    , cast(replace(sub_total, ' ', '') as DECIMAL) as sub_total
    , cast(replace(average_item_value, ' ', '') as DECIMAL) as average_item_value
    , cast(replace(restaurant_income, ' ', '') as DECIMAL) as restaurant_income
    , cast(replace(markup_discount, ' ', '') as DECIMAL) as markup_discount
    , cast(replace(markup, ' ', '') as DECIMAL) as markup
    , cast(replace(discount, ' ', '') as DECIMAL) as discount
    , strategies
    , events
    , raworderdetails
from linked_eats_demo.landing_zone.orders;