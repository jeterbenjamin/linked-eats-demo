CREATE TABLE "linked_eats_demo"."landing_zone"."event_status" (
    "_id" varchar,
    "organization" varchar,
    "status" varchar,
    "__v" varchar,
    "set_up_context" varchar,
    "set_up_time" varchar,
    "tear_down_time" varchar,
    "strategy" varchar,
    "set_up_transactions" varchar,
    "tear_down_transactions" varchar,
    "restaurant" varchar,
    "change" varchar,
    "live_end_time" varchar,
    "live_start_time" varchar,
    "fail_time" varchar
)
WITH (
    type = 'hive',
    format = 'JSON',
    external_location = 's3://jeter-linked-eats-demo/landing-zone/data/event_status/'
)