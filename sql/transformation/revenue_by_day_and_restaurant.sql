   -- Top 10 Restaurants by Revenue for a Specified Day
SELECT
    restaurant_id
    , SUM(restaurant_income) AS total_income
FROM linked_eats_demo.xform_ib.orders_ib
where date(order_date_utc) = date('2024-04-28') -- or whatever
GROUP BY restaurant_id, date(order_date_utc)
ORDER BY total_income DESC
LIMIT 10;

-- Daily Revenue for a Specific Restaurant
SELECT
    restaurant_id
    , date(order_date_utc) as order_date
    , SUM(restaurant_income) AS total_income
FROM linked_eats_demo.xform_ib.orders_ib
where restaurant_id = '6477e6a03156e81fcac44392' -- or whatever
GROUP BY restaurant_id, date(order_date_utc)
ORDER BY date(order_date_utc) DESC;

-- check for any negative total income
SELECT
    restaurant_id
    , date(order_date_utc) as order_date
    , SUM(restaurant_income) AS total_income
FROM linked_eats_demo.xform_ib.orders_ib
-- where restaurant_id = '6477e6a03156e81fcac44392' -- or whatever
GROUP BY restaurant_id, date(order_date_utc)
having sum(restaurant_income) < 0
ORDER BY date(order_date_utc) DESC;
