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
)