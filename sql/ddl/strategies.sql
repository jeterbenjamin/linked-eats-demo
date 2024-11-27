CREATE TABLE "linked_eats_demo"."landing_zone"."strategies" (
	"strategy_config_name" varchar
	,"strategy_id" varchar
	,"organization_id" varchar
	,"currently_active" varchar
	,"current_restaurants" varchar
	,"sauce_generated" varchar
	,"strategy_type" varchar
	,"strategy_description" varchar
	,"strategy_created_date" varchar
	,"strategy_last_updated_date" varchar
	,"_id" varchar
	,"config_name" varchar
	,"config_type" varchar
	,"config_goal" varchar
	,"description" varchar
	,"recommended_duration" varchar
	,"recommended_location_string" varchar
	,"recommended_num_locations_string" varchar
	,"desired_outcomes" varchar
	,"default_settings" varchar
	,"__v" varchar
	,"period" varchar
	,"hour_bounds" varchar
	,"use_single_price_percent" varchar
	,"pct_change" varchar
	,"max_pct" varchar
	,"min_pct" varchar
	,"aggression" varchar
	,"round_option" varchar
	,"basis" varchar
	,"recommendedDuration" varchar
	,"recommendedLocationString" varchar
	,"recommendedNumLocationsString" varchar
	,"error" varchar
	,"meal_periods" varchar
	,"frequency_enabled" varchar
	,"frequency_error" varchar
	,"min_events" varchar
	,"max_events" varchar
)	
WITH (
    type = 'hive',
    format = 'JSON',
    external_location = 's3://jeter-linked-eats-demo/landing-zone/data/strategies/'
)
