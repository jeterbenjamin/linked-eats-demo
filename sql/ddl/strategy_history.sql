CREATE TABLE "linked_eats_demo"."landing_zone"."strategy_history" (
    "historyid" varchar,
    "strategy" varchar,
    "advanced_strategy_options" varchar,
    "strategy_generation_status" varchar,
    "organization" varchar,
    "active" varchar,
    "archived" varchar,
    "generated_strategy" boolean,
    "affected_concepts" varchar,
    "all_org_locations" boolean,
    "affected_concept_tags" varchar,
    "metric_preferences" varchar,
    "strategy_config" varchar,
    "scheduledactivations" varchar,
    "warnings" varchar,
    "lastupdated" varchar,
    "color" varchar,
    "__v" varchar,
    "recurrence" boolean,
    "test_strategy" boolean,
    "update_time" varchar,
    "update_types" varchar,
    "duration" varchar,
    "strategy_start_date" varchar,
    "automated" varchar
)
WITH (
    type = 'hive',
    format = 'JSON',
    external_location = 's3://jeter-linked-eats-demo/landing-zone/data/strategy_history/'
)