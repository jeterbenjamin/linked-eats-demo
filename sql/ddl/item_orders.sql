CREATE TABLE "linked_eats_demo"."landing_zone"."item_orders" (
    "restaurant_id" varchar,
    "platform_order_id" varchar,
    "sauce_item_order_id" varchar,
    "sauce_parent_item_id" varchar,
    "sauce_platform_item_id" varchar,
    "numberitems" varchar,
    "purchase_date_time" varchar,
    "calculated_total_sale_price" varchar,
    "estimated_base_price" varchar,
    "addons" varchar,
    "itemdetailsatordertime" varchar
)
WITH (
    type = 'hive',
    format = 'JSON',
    external_location = 's3://jeter-linked-eats-demo/landing-zone/data/item_orders/'
);


-- create an iceberg 
CREATE TABLE "linked_eats_demo"."xform_ib"."item_orders_ib"
as
select distinct
	*
from "linked_eats_demo"."landing_zone"."item_orders";


/* Option 1:


-- use a merge statement
-- can also be done with an insert and the appropriate predicate logic
-- batch the job every 15 minutes

*/

-- MERGE INTO linked_eats_demo.xform_ib.item_orders_ib AS b
-- USING (select * from "linked_eats_demo"."landing_zone"."item_orders") AS l
-- ON (b.platform_order_id = l.platform_order_id)
-- WHEN NOT MATCHED
--       THEN INSERT 
--       (
--              restaurant_id
--             , platform_order_id
--             , sauce_item_order_id
--             , sauce_parent_item_id
--             , sauce_platform_item_id
--             , numberitems
--             , purchase_date_time
--             , calculated_total_sale_price
--             , estimated_base_price
--             , addons
--             , itemdetailsatordertime
--       )
--       VALUES
--       (
--              l.restaurant_id
--             , l.platform_order_id
--             , l.sauce_item_order_id
--             , l.sauce_parent_item_id
--             , l.sauce_platform_item_id
--             , l.numberitems
--             , l.purchase_date_time
--             , l.calculated_total_sale_price
--             , l.estimated_base_price
--             , l.addons
--             , l.itemdetailsatordertime
--       );    


/* Option 2:

Create a materialized view; due to the default configuration
of the platform this will be an Iceberg table, which supports
incremental refresh.

Docs: https://trino.io/docs/current/connector/iceberg.html#materialized-views

*/

create materialized view linked_eats_demo.xform_ib.iterm_orders_mv
as
select distinct
	*
from "linked_eats_demo"."landing_zone"."item_orders";

refresh materialized view linked_eats_demo.xform_ib.iterm_orders_mv;

/* Option 3:

Deploy the orchestrator of your choice, set up a sensor on the 
s3 landing zone and define the pipeline logic as appropriate

Note -> This is getting pretty far beyond the scope of reasonable for a
	takehome assessment, and as such is not done here. 


*/