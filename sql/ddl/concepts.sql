CREATE TABLE "linked_eats_demo"."landing_zone"."concepts" (
    "restaurant_id" varchar,
    "organization_id" varchar,
    "parent_organization_ids" varchar,
    "restaurant_added_date" varchar,
    "organization_added_date" varchar,
    "restaurant_still_activated" varchar,
    "organization_still_activated" varchar,
    "location" varchar,
    "price_change_pipeline" varchar
)
WITH (
    type = 'hive',
    format = 'JSON',
    external_location = 's3://jeter-linked-eats-demo/landing-zone/data/concepts/'
)