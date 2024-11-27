CREATE TABLE "linked_eats_demo"."landing_zone"."concept_items" (
    "sauce_parent_item_id" varchar,
    "sauce_platform_item_id" varchar,
    "platform" varchar,
    "platform_type" varchar,
    "status" varchar,
    "platform_item_id" varchar,
    "platform_menu_id" varchar,
    "platform_category_id" varchar,
    "platform_category_name" varchar,
    "description" varchar,
    "base_price" varchar,
    "current_price" varchar,
    "effective_internal_prices" varchar,
    "effective_base_prices" varchar,
    "effective_current_prices" varchar,
    "sauce_internal_price" varchar,
    "sauce_event_tracking" varchar,
    "add_ons" varchar,
    "update_time" varchar,
    "_id" varchar,
    "last_change_time" varchar
)
WITH (
    type = 'hive',
    format = 'JSON',
    external_location = 's3://jeter-linked-eats-demo/landing-zone/data/concept_items/'
)