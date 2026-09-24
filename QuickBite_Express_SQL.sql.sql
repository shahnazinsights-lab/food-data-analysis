-- ============================================================
-- QUICKBITE EXPRESS — SQL DATA ANALYSIS
-- ============================================================
-- Project: QuickBite Express — SQL Data Analysis
-- Database: quickbite_express
-- Source: Python-cleaned datasets imported into MySQL
-- ============================================================

-- ============================================================
-- STEP 1 — DATABASE CREATION & DATASET VERIFICATION
-- ============================================================

CREATE DATABASE IF NOT EXISTS quickbite_express;
USE quickbite_express;

/*
Observation:
The quickbite_express database is used for SQL-based data
verification, relational analysis, business analysis, KPI
development, data validation, and strategic decision-making.
The eight datasets were cleaned during the Python stage and
then imported into MySQL for structured SQL analysis.
*/

SHOW TABLES;

/*
Observation:
The SHOW TABLES command verifies that the eight cleaned
QuickBite Express datasets are available in the database.
*/

DESCRIBE customers_clean;
DESCRIBE restaurants_clean;
DESCRIBE menu_items_clean;
DESCRIBE delivery_partners_clean;
DESCRIBE orders_clean;
DESCRIBE order_items_clean;
DESCRIBE delivery_clean;
DESCRIBE reviews_clean;

/*
Observation:
The DESCRIBE commands verify the structure, column names,
and data types of all eight imported cleaned datasets.
The SQL analysis uses the exact cleaned-table columns produced
by the Python workflow.
*/

-- ============================================================
-- STEP 2 — CUSTOMER / RESTAURANT / ORDER ANALYSIS
-- ============================================================

-- 2.1 Customer Analysis: Customers by City

SELECT
    city,
    COUNT(*) AS total_customers
FROM customers_clean
GROUP BY city
ORDER BY total_customers DESC;

/*
Observation:
The query identifies the number of customers in each city.
This helps determine locations with larger customer bases and
supports geographic customer analysis.
*/

-- 2.2 Customer Analysis: Customer Acquisition Channel

SELECT
    acquisition_channel,
    COUNT(*) AS total_customers
FROM customers_clean
GROUP BY acquisition_channel
ORDER BY total_customers DESC;

/*
Observation:
The query compares customers across acquisition channels.
This helps identify which channels contribute relatively more
customers and can support acquisition planning.
*/

-- 2.3 Customer Analysis: Customer Sign-up by Month

SELECT
    DATE_FORMAT(signup_date, '%Y-%m') AS signup_month,
    COUNT(*) AS new_customers
FROM customers_clean
GROUP BY DATE_FORMAT(signup_date, '%Y-%m')
ORDER BY signup_month;

/*
Observation:
The query summarizes customer sign-ups by month. This helps
identify periods of stronger or weaker customer acquisition.
*/

-- 2.4 Restaurant Analysis: Restaurants by City

SELECT
    city,
    COUNT(*) AS total_restaurants
FROM restaurants_clean
GROUP BY city
ORDER BY total_restaurants DESC;

/*
Observation:
The query identifies the number of restaurants operating in
each city. This helps understand restaurant availability and
platform coverage across locations.
*/

-- 2.5 Menu Analysis: Menu Items by Category

SELECT
    category,
    COUNT(*) AS total_menu_items
FROM menu_items_clean
GROUP BY category
ORDER BY total_menu_items DESC;

/*
Observation:
The query identifies the number of menu items in each category.
This helps understand the distribution of menu offerings.
*/

-- 2.6 Order Analysis: Cancelled vs Non-Cancelled Orders

SELECT
    is_cancelled,
    COUNT(*) AS total_orders
FROM orders_clean
GROUP BY is_cancelled
ORDER BY total_orders DESC;

/*
Observation:
The query compares cancelled and non-cancelled orders. This
helps evaluate the overall order completion pattern and the
extent of order cancellations.
*/

-- 2.7 Restaurant Analysis: Restaurants by Cuisine Type

SELECT
    cuisine_type,
    COUNT(*) AS total_restaurants
FROM restaurants_clean
GROUP BY cuisine_type
ORDER BY total_restaurants DESC;

/*
Observation:
The query identifies restaurant availability by cuisine type.
This helps understand cuisine coverage across the platform.
*/

-- 2.8 Restaurant Analysis: Average Preparation Time by City

SELECT
    city,
    ROUND(AVG(avg_prep_time_min), 2) AS average_prep_time_min,
    COUNT(*) AS total_restaurants
FROM restaurants_clean
GROUP BY city
ORDER BY average_prep_time_min ASC;

/*
Observation:
The query compares average restaurant preparation time across
cities. This helps identify locations with relatively faster or
slower preparation patterns.
*/

-- 2.9 Order Analysis: Orders by Cancellation Status

SELECT
    CASE
        WHEN is_cancelled = 1 THEN 'Cancelled'
        ELSE 'Not Cancelled'
    END AS order_status,
    COUNT(*) AS total_orders
FROM orders_clean
GROUP BY
    CASE
        WHEN is_cancelled = 1 THEN 'Cancelled'
        ELSE 'Not Cancelled'
    END
ORDER BY total_orders DESC;

/*
Observation:
The query converts the cancellation flag into business-friendly
order-status categories and compares their volumes.
*/

-- 2.10 Order Analysis: Orders by City

SELECT
    c.city,
    COUNT(o.order_id) AS total_orders
FROM orders_clean o
JOIN customers_clean c
    ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_orders DESC;

/*
Observation:
The query identifies order activity by customer city. This
helps determine locations generating higher order volumes.
*/

-- 2.11 Order Analysis: Average Order Value

SELECT
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM orders_clean
WHERE is_cancelled = 0;

/*
Observation:
The query calculates the average value of non-cancelled orders.
This provides a baseline measure of typical customer spending.
*/

-- 2.12 Order Analysis: Total Order Revenue

SELECT
    ROUND(SUM(total_amount), 2) AS total_order_revenue
FROM orders_clean
WHERE is_cancelled = 0;

/*
Observation:
The query calculates revenue from non-cancelled orders and
provides an overall measure of completed-order revenue.
*/

-- 2.13 Order Analysis: Revenue by City

SELECT
    c.city,
    ROUND(SUM(o.total_amount), 2) AS total_revenue,
    COUNT(o.order_id) AS total_orders
FROM orders_clean o
JOIN customers_clean c
    ON o.customer_id = c.customer_id
WHERE o.is_cancelled = 0
GROUP BY c.city
ORDER BY total_revenue DESC;

/*
Observation:
The query calculates revenue and order volume by city. This
helps identify strong revenue-generating markets.
*/

-- ============================================================
-- STEP 3 — RESTAURANT & MENU PERFORMANCE ANALYSIS
-- ============================================================

-- 3.1 Restaurant Performance: Restaurants by Partner Type

SELECT
    partner_type,
    COUNT(*) AS total_restaurants
FROM restaurants_clean
GROUP BY partner_type
ORDER BY total_restaurants DESC;

/*
Observation:
The query compares restaurants by partner type. This helps
understand the composition of the restaurant partner network.
*/

-- 3.2 Restaurant Performance: Restaurants by Cuisine Type

SELECT
    cuisine_type,
    COUNT(*) AS total_restaurants
FROM restaurants_clean
GROUP BY cuisine_type
ORDER BY total_restaurants DESC;

/*
Observation:
The query identifies the most represented cuisine types on
the platform and supports cuisine-market analysis.
*/

-- 3.3 Menu Analysis: Average Price by Category

SELECT
    category,
    ROUND(AVG(price), 2) AS average_price,
    COUNT(*) AS total_items
FROM menu_items_clean
GROUP BY category
ORDER BY average_price DESC;

/*
Observation:
The query calculates average menu-item prices by category.
This helps compare pricing patterns across food categories.
*/

-- 3.4 Menu Analysis: Most Expensive Menu Items

SELECT
    menu_item_id,
    restaurant_id,
    item_name,
    category,
    price
FROM menu_items_clean
ORDER BY price DESC
LIMIT 10;

/*
Observation:
The query identifies the highest-priced menu items. This helps
understand premium offerings and the upper range of menu pricing.
*/

-- 3.5 Menu Analysis: Lowest-Priced Menu Items

SELECT
    menu_item_id,
    restaurant_id,
    item_name,
    category,
    price
FROM menu_items_clean
ORDER BY price ASC
LIMIT 10;

/*
Observation:
The query identifies the lowest-priced menu items and helps
understand affordable food options on the platform.
*/

-- 3.6 Menu Analysis: Menu Items by Restaurant

SELECT
    restaurant_id,
    COUNT(*) AS total_menu_items
FROM menu_items_clean
GROUP BY restaurant_id
ORDER BY total_menu_items DESC;

/*
Observation:
The query identifies restaurants with larger menu ranges.
This helps compare the breadth of restaurant offerings.
*/

-- 3.7 Restaurant Performance: Orders by Restaurant

SELECT
    r.restaurant_id,
    r.restaurant_name,
    COUNT(o.order_id) AS total_orders
FROM orders_clean o
JOIN restaurants_clean r
    ON o.restaurant_id = r.restaurant_id
WHERE o.is_cancelled = 0
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_orders DESC;

/*
Observation:
The query compares completed-order activity across restaurants
and identifies restaurants handling higher order volumes.
*/

-- 3.8 Restaurant Performance: Revenue by Restaurant

SELECT
    r.restaurant_id,
    r.restaurant_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM orders_clean o
JOIN restaurants_clean r
    ON o.restaurant_id = r.restaurant_id
WHERE o.is_cancelled = 0
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_revenue DESC;

/*
Observation:
The query calculates completed-order volume and revenue for
each restaurant. This identifies restaurants contributing
more strongly to platform revenue.
*/

-- 3.9 Restaurant Performance: Average Order Value by Restaurant

SELECT
    r.restaurant_id,
    r.restaurant_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM orders_clean o
JOIN restaurants_clean r
    ON o.restaurant_id = r.restaurant_id
WHERE o.is_cancelled = 0
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY average_order_value DESC;

/*
Observation:
The query calculates average completed-order value by restaurant.
This helps identify restaurants associated with higher customer
spending per transaction.
*/

-- 3.10 Restaurant Performance: Top Restaurants by City

WITH restaurant_sales AS
(
    SELECT
        r.city,
        r.restaurant_id,
        r.restaurant_name,
        SUM(o.total_amount) AS total_revenue,
        ROW_NUMBER() OVER
        (
            PARTITION BY r.city
            ORDER BY SUM(o.total_amount) DESC
        ) AS rank_no
    FROM restaurants_clean r
    JOIN orders_clean o
        ON r.restaurant_id = o.restaurant_id
    WHERE o.is_cancelled = 0
    GROUP BY r.city, r.restaurant_id, r.restaurant_name
)
SELECT
    city,
    restaurant_id,
    restaurant_name,
    ROUND(total_revenue, 2) AS total_revenue
FROM restaurant_sales
WHERE rank_no = 1
ORDER BY city;

/*
Observation:
The query identifies the highest-revenue restaurant in each
city and supports city-level restaurant comparison.
*/

-- ============================================================
-- STEP 4 — ORDER ITEMS & FOOD POPULARITY ANALYSIS
-- ============================================================

-- 4.1 Food Analysis: Most Ordered Menu Items

SELECT
    m.menu_item_id,
    m.item_name,
    m.category,
    SUM(oi.quantity) AS total_quantity_ordered
FROM order_items_clean oi
JOIN menu_items_clean m
    ON oi.menu_item_id = m.menu_item_id
GROUP BY m.menu_item_id, m.item_name, m.category
ORDER BY total_quantity_ordered DESC
LIMIT 10;

/*
Observation:
The query identifies the most frequently ordered menu items
based on total quantity. This supports food-demand analysis.
*/

-- 4.2 Food Analysis: Most Popular Food Categories

SELECT
    m.category,
    SUM(oi.quantity) AS total_quantity_ordered
FROM order_items_clean oi
JOIN menu_items_clean m
    ON oi.menu_item_id = m.menu_item_id
GROUP BY m.category
ORDER BY total_quantity_ordered DESC;

/*
Observation:
The query identifies food categories with higher ordered
quantities and helps understand customer preferences.
*/

-- 4.3 Food Analysis: Number of Orders by Food Item

SELECT
    oi.menu_item_id,
    m.item_name,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items_clean oi
JOIN menu_items_clean m
    ON oi.menu_item_id = m.menu_item_id
GROUP BY oi.menu_item_id, m.item_name
ORDER BY total_orders DESC
LIMIT 10;

/*
Observation:
The query identifies menu items appearing in the highest
number of distinct orders and highlights consistently popular
food choices.
*/

-- 4.4 Food Analysis: Revenue by Food Item

SELECT
    oi.menu_item_id,
    m.item_name,
    m.category,
    ROUND(SUM(oi.line_total), 2) AS item_revenue
FROM order_items_clean oi
JOIN menu_items_clean m
    ON oi.menu_item_id = m.menu_item_id
GROUP BY oi.menu_item_id, m.item_name, m.category
ORDER BY item_revenue DESC
LIMIT 10;

/*
Observation:
The query calculates item-level revenue using the cleaned
line_total field. This identifies food items contributing more
strongly to order-item revenue.
*/

-- 4.5 Food Analysis: Revenue by Food Category

SELECT
    m.category,
    SUM(oi.quantity) AS total_quantity_ordered,
    ROUND(SUM(oi.line_total), 2) AS category_revenue
FROM order_items_clean oi
JOIN menu_items_clean m
    ON oi.menu_item_id = m.menu_item_id
GROUP BY m.category
ORDER BY category_revenue DESC;

/*
Observation:
The query compares food categories by quantity ordered and
cleaned line-item revenue, supporting category-level decisions.
*/

-- 4.6 Food Analysis: Average Price of Ordered Items by Category

SELECT
    m.category,
    ROUND(AVG(oi.unit_price), 2) AS average_unit_price,
    SUM(oi.quantity) AS total_quantity_ordered
FROM order_items_clean oi
JOIN menu_items_clean m
    ON oi.menu_item_id = m.menu_item_id
GROUP BY m.category
ORDER BY average_unit_price DESC;

/*
Observation:
The query compares average unit price with quantity ordered
for each category and helps understand price-demand patterns.
*/

-- 4.7 Food Analysis: Most Popular Item Within Each Category

WITH item_sales AS
(
    SELECT
        m.category,
        m.menu_item_id,
        m.item_name,
        SUM(oi.quantity) AS total_quantity_ordered,
        ROW_NUMBER() OVER
        (
            PARTITION BY m.category
            ORDER BY SUM(oi.quantity) DESC
        ) AS rank_no
    FROM order_items_clean oi
    JOIN menu_items_clean m
        ON oi.menu_item_id = m.menu_item_id
    GROUP BY m.category, m.menu_item_id, m.item_name
)
SELECT
    category,
    menu_item_id,
    item_name,
    total_quantity_ordered
FROM item_sales
WHERE rank_no = 1
ORDER BY category;

/*
Observation:
The query identifies the most ordered menu item within each
category and supports category-level menu optimization.
*/

-- 4.8 Food Analysis: Restaurant-wise Food Sales

SELECT
    r.restaurant_id,
    r.restaurant_name,
    SUM(oi.quantity) AS total_items_sold,
    ROUND(SUM(oi.line_total), 2) AS food_revenue
FROM order_items_clean oi
JOIN orders_clean o
    ON oi.order_id = o.order_id
JOIN restaurants_clean r
    ON o.restaurant_id = r.restaurant_id
WHERE o.is_cancelled = 0
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY food_revenue DESC;

/*
Observation:
The query calculates food quantity sold and line-item revenue
for each restaurant, helping identify restaurants with strong
food-item sales performance.
*/

-- 4.9 Food Analysis: Average Items per Order

SELECT
    ROUND(
        SUM(quantity) / COUNT(DISTINCT order_id),
        2
    ) AS average_items_per_order
FROM order_items_clean;

/*
Observation:
The query calculates the average number of food items per order.
This helps understand customer basket size.
*/

-- ============================================================
-- STEP 5 — DELIVERY PERFORMANCE ANALYSIS
-- ============================================================

-- 5.1 Delivery Analysis: Delivery Status Distribution

SELECT
    CASE
        WHEN sla_met = 1 THEN 'Within SLA'
        ELSE 'Outside SLA'
    END AS delivery_status,
    COUNT(*) AS total_deliveries
FROM delivery_clean
group by
    CASE
        WHEN sla_met = 1 THEN 'Within SLA'
        ELSE 'Outside SLA'
    END
ORDER BY total_deliveries DESC;

/*
Observation:
The query classifies deliveries according to the cleaned SLA
indicator and compares deliveries completed within and outside
SLA.
*/

-- 5.2 Delivery Analysis: Average Delivery Time

SELECT
    ROUND(AVG(actual_delivery_time_mins), 2) AS average_delivery_time
FROM delivery_clean;

/*
Observation:
The query calculates the average actual delivery time across
all delivery records. This provides a baseline measure of overall
delivery efficiency.
*/

-- 5.3 Delivery Analysis: Fastest Deliveries

SELECT
    order_id,
    actual_delivery_time_mins,
    expected_delivery_time_mins,
    distance_km,
    delivery_delay_mins,
    sla_met
FROM delivery_clean
ORDER BY actual_delivery_time_mins ASC
LIMIT 10;

/*
Observation:
The query identifies the fastest deliveries based on actual
delivery time and also shows expected time, distance, delay,
and SLA status.
*/

-- 5.4 Delivery Analysis: Longest Deliveries

SELECT
    order_id,
    actual_delivery_time_mins,
    expected_delivery_time_mins,
    distance_km,
    delivery_delay_mins,
    sla_met
FROM delivery_clean
ORDER BY actual_delivery_time_mins DESC
LIMIT 10;

/*
Observation:
The query identifies deliveries with the longest actual
delivery times and provides operational context through
distance, delay, and SLA status.
*/

-- 5.5 Delivery Analysis: Delivery Time by City

SELECT
    c.city,
    COUNT(d.order_id) AS total_deliveries,
    ROUND(AVG(d.actual_delivery_time_mins), 2) AS average_delivery_time,
    ROUND(AVG(d.delivery_delay_mins), 2) AS average_delivery_delay
FROM delivery_clean d
JOIN orders_clean o
    ON d.order_id = o.order_id
JOIN customers_clean c
    ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY average_delivery_time ASC;

/*
Observation:
The query compares actual delivery time and delivery delay
across customer cities. This helps identify locations with
faster or slower delivery performance.
*/

-- 5.6 Delivery Analysis: Delivery Partner Performance

SELECT
    dp.delivery_partner_id,
    dp.partner_name,
    dp.city,
    dp.vehicle_type,
    dp.employment_type,
    ROUND(dp.avg_rating, 2) AS partner_rating,
    COUNT(d.order_id) AS total_deliveries,
    ROUND(AVG(d.actual_delivery_time_mins), 2) AS average_delivery_time,
    ROUND(AVG(d.delivery_delay_mins), 2) AS average_delivery_delay
FROM delivery_partners_clean dp
JOIN orders_clean o
    ON dp.delivery_partner_id = o.delivery_partner_id
JOIN delivery_clean d
    ON o.order_id = d.order_id
GROUP BY
    dp.delivery_partner_id,
    dp.partner_name,
    dp.city,
    dp.vehicle_type,
    dp.employment_type,
    dp.avg_rating
ORDER BY total_deliveries DESC
LIMIT 20;

/*
Observation:
The query evaluates delivery partners using workload, actual
delivery time, delivery delay, rating, city, vehicle type, and
employment type.
*/

-- 5.7 Delivery Analysis: Top Delivery Partners

SELECT
    dp.delivery_partner_id,
    dp.partner_name,
    dp.city,
    ROUND(dp.avg_rating, 2) AS partner_rating,
    COUNT(d.order_id) AS total_deliveries,
    ROUND(AVG(d.actual_delivery_time_mins), 2) AS average_delivery_time
FROM delivery_partners_clean dp
JOIN orders_clean o
    ON dp.delivery_partner_id = o.delivery_partner_id
JOIN delivery_clean d
    ON o.order_id = d.order_id
GROUP BY
    dp.delivery_partner_id,
    dp.partner_name,
    dp.city,
    dp.avg_rating
ORDER BY total_deliveries DESC
LIMIT 20;

/*
Observation:
The query identifies delivery partners handling the largest
number of delivery records and compares their ratings and
average delivery times.
*/

-- 5.8 Delivery Analysis: Delivery Partner Rating

SELECT
    ROUND(avg_rating, 1) AS partner_rating,
    COUNT(*) AS total_delivery_partners
FROM delivery_partners_clean
GROUP BY ROUND(avg_rating, 1)
ORDER BY partner_rating DESC;

/*
Observation:
The query shows the distribution of delivery partners across
rating levels and supports delivery-partner quality analysis.
*/

-- 5.9 Delivery Analysis: Average Delivery Time by Partner Rating

SELECT
    ROUND(dp.avg_rating, 1) AS partner_rating,
    COUNT(d.order_id) AS total_deliveries,
    ROUND(AVG(d.actual_delivery_time_mins), 2) AS average_delivery_time,
    ROUND(AVG(d.delivery_delay_mins), 2) AS average_delivery_delay
FROM delivery_partners_clean dp
JOIN orders_clean o
    ON dp.delivery_partner_id = o.delivery_partner_id
JOIN delivery_clean d
    ON o.order_id = d.order_id
GROUP BY ROUND(dp.avg_rating, 1)
ORDER BY partner_rating DESC;

/*
Observation:
The query compares delivery-time performance across partner
rating levels and helps examine whether rating groups show
operational differences.
*/

-- 5.10 Delivery Analysis: Delivery Time Distribution

SELECT
    CASE
        WHEN actual_delivery_time_mins <= 30 THEN '0-30 Minutes'
        WHEN actual_delivery_time_mins <= 45 THEN '31-45 Minutes'
        WHEN actual_delivery_time_mins <= 60 THEN '46-60 Minutes'
        ELSE '60+ Minutes'
    END AS delivery_time_group,
    COUNT(*) AS total_deliveries
FROM delivery_clean
GROUP BY
    CASE
        WHEN actual_delivery_time_mins <= 30 THEN '0-30 Minutes'
        WHEN actual_delivery_time_mins <= 45 THEN '31-45 Minutes'
        WHEN actual_delivery_time_mins <= 60 THEN '46-60 Minutes'
        ELSE '60+ Minutes'
    END
ORDER BY total_deliveries DESC;

/*
Observation:
The query groups deliveries into actual delivery-time ranges.
This helps understand the overall distribution of delivery times.
*/

-- 5.11 Delivery Analysis: Cancellation and Delivery Performance

SELECT
    o.is_cancelled,
    COUNT(d.order_id) AS total_deliveries,
    ROUND(AVG(d.actual_delivery_time_mins), 2) AS average_delivery_time,
    ROUND(AVG(d.delivery_delay_mins), 2) AS average_delivery_delay
FROM orders_clean o
JOIN delivery_clean d
    ON o.order_id = d.order_id
GROUP BY o.is_cancelled
ORDER BY o.is_cancelled;

/*
Observation:
The query compares delivery-time and delay measures across
cancelled and non-cancelled orders. It is descriptive and does
not imply that delivery performance caused cancellation.
*/

-- ============================================================
-- STEP 6 — CUSTOMER REVIEW & RATING ANALYSIS
-- ============================================================

-- 6.1 Review Analysis: Overall Rating Distribution

SELECT
    rating,
    COUNT(*) AS total_reviews
FROM reviews_clean
GROUP BY rating
ORDER BY rating DESC;

/*
Observation:
The query identifies the distribution of customer ratings and
helps understand the overall customer-feedback pattern.
*/

-- 6.2 Review Analysis: Average Customer Rating

SELECT
    ROUND(AVG(rating), 2) AS average_customer_rating
FROM reviews_clean;

/*
Observation:
The query calculates the overall average customer rating and
provides a high-level measure of customer satisfaction.
*/

-- 6.3 Review Analysis: Positive, Neutral and Negative Reviews

SELECT
    CASE
        WHEN rating >= 4 THEN 'Positive'
        WHEN rating = 3 THEN 'Neutral'
        ELSE 'Negative'
    END AS review_category,
    COUNT(*) AS total_reviews
FROM reviews_clean
GROUP BY
    CASE
        WHEN rating >= 4 THEN 'Positive'
        WHEN rating = 3 THEN 'Neutral'
        ELSE 'Negative'
    END
ORDER BY total_reviews DESC;

/*
Observation:
The query groups customer reviews into positive, neutral, and
negative categories using the available rating field.
*/

-- 6.4 Review Analysis: Reviews by Restaurant

SELECT
    r.restaurant_id,
    r.restaurant_name,
    COUNT(rv.order_id) AS total_reviews,
    ROUND(AVG(rv.rating), 2) AS average_review_rating
FROM reviews_clean rv
JOIN restaurants_clean r
    ON rv.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY average_review_rating DESC;

/*
Observation:
The query calculates review volume and average customer rating
for each restaurant and supports restaurant-level satisfaction
comparison.
*/

-- 6.5 Review Analysis: Top-Rated Restaurants

SELECT
    r.restaurant_id,
    r.restaurant_name,
    ROUND(AVG(rv.rating), 2) AS average_review_rating,
    COUNT(rv.order_id) AS total_reviews
FROM reviews_clean rv
JOIN restaurants_clean r
    ON rv.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
HAVING COUNT(rv.order_id) >= 5
ORDER BY average_review_rating DESC
LIMIT 10;

/*
Observation:
The query identifies highly reviewed restaurants with at least
five reviews, reducing the influence of very small review counts.
*/

-- 6.6 Review Analysis: Lowest-Rated Restaurants

SELECT
    r.restaurant_id,
    r.restaurant_name,
    ROUND(AVG(rv.rating), 2) AS average_review_rating,
    COUNT(rv.order_id) AS total_reviews
FROM reviews_clean rv
JOIN restaurants_clean r
    ON rv.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
HAVING COUNT(rv.order_id) >= 5
ORDER BY average_review_rating ASC
LIMIT 10;

/*
Observation:
The query identifies restaurants with relatively lower average
customer ratings while requiring at least five reviews.
*/

-- 6.7 Review Analysis: Customer Review Activity by City

SELECT
    r.city,
    COUNT(rv.order_id) AS total_reviews,
    ROUND(AVG(rv.rating), 2) AS average_rating
FROM reviews_clean rv
JOIN restaurants_clean r
    ON rv.restaurant_id = r.restaurant_id
GROUP BY r.city
ORDER BY total_reviews DESC;

/*
Observation:
The query compares customer review activity and average rating
across cities.
*/

-- 6.8 Review Analysis: Rating Distribution by Restaurant

SELECT
    r.restaurant_name,
    rv.rating,
    COUNT(*) AS total_reviews
FROM reviews_clean rv
JOIN restaurants_clean r
    ON rv.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name, rv.rating
ORDER BY r.restaurant_name, rv.rating DESC;

/*
Observation:
The query shows the distribution of customer ratings for each
restaurant and helps identify consistency in customer feedback.
*/

-- 6.9 Review Analysis: Customers Giving Multiple Reviews

SELECT
    customer_id,
    COUNT(*) AS total_reviews
FROM reviews_clean
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY total_reviews DESC;

/*
Observation:
The query identifies customers who submitted multiple reviews
and helps understand repeat engagement with the review system.
*/

-- 6.10 Review Analysis: Most Frequently Reviewed Restaurants

SELECT
    r.restaurant_id,
    r.restaurant_name,
    COUNT(*) AS total_reviews
FROM reviews_clean rv
JOIN restaurants_clean r
    ON rv.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_reviews DESC
LIMIT 10;

/*
Observation:
The query identifies restaurants receiving the highest number
of customer reviews and highlights strong feedback activity.
*/

-- 6.11 Review Analysis: Review Rating vs Restaurant Performance

SELECT
    r.restaurant_id,
    r.restaurant_name,
    ROUND(AVG(rv.rating), 2) AS average_review_rating,
    COUNT(DISTINCT rv.order_id) AS reviewed_orders,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM restaurants_clean r
JOIN reviews_clean rv
    ON r.restaurant_id = rv.restaurant_id
JOIN orders_clean o
    ON r.restaurant_id = o.restaurant_id
   AND o.is_cancelled = 0
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_revenue DESC
LIMIT 20;

/*
Observation:
The query brings together customer review ratings with restaurant
order and revenue activity. It supports descriptive comparison of
customer feedback and business performance.
*/

-- ============================================================
-- STEP 7 — INTEGRATED BUSINESS ANALYSIS
-- ============================================================

-- 7.1 Business Analysis: Customer Order Performance

SELECT
    c.customer_id,
    c.city,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent,
    ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM customers_clean c
JOIN orders_clean o
    ON c.customer_id = o.customer_id
WHERE o.is_cancelled = 0
GROUP BY c.customer_id, c.city
ORDER BY total_spent DESC
LIMIT 10;

/*
Observation:
The query identifies customers with high completed-order
activity and spending, supporting customer-value analysis.
*/

-- 7.2 Business Analysis: Top Customers by Order Frequency

SELECT
    c.customer_id,
    c.city,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers_clean c
JOIN orders_clean o
    ON c.customer_id = o.customer_id
WHERE o.is_cancelled = 0
GROUP BY c.customer_id, c.city
ORDER BY total_orders DESC
LIMIT 10;

/*
Observation:
The query identifies customers placing the highest number of
completed orders and supports repeat-usage analysis.
*/

-- 7.3 Business Analysis: City-wise Customers, Orders and Revenue

SELECT
    c.city,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM customers_clean c
LEFT JOIN orders_clean o
    ON c.customer_id = o.customer_id
   AND o.is_cancelled = 0
GROUP BY c.city
ORDER BY total_revenue DESC;

/*
Observation:
The query compares cities by customer count, completed-order
volume, and revenue, supporting geographic market analysis.
*/

-- 7.4 Business Analysis: Restaurant Orders, Revenue and Preparation Time

SELECT
    r.restaurant_id,
    r.restaurant_name,
    r.city,
    ROUND(r.avg_prep_time_min, 2) AS average_prep_time_min,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM restaurants_clean r
JOIN orders_clean o
    ON r.restaurant_id = o.restaurant_id
WHERE o.is_cancelled = 0
GROUP BY
    r.restaurant_id,
    r.restaurant_name,
    r.city,
    r.avg_prep_time_min
ORDER BY total_revenue DESC
LIMIT 10;

/*
Observation:
The query combines restaurant preparation time with completed
order activity and revenue, supporting operational comparison.
*/

-- 7.5 Business Analysis: Restaurant Revenue and Customer Reviews

WITH restaurant_revenue AS
(
    SELECT
        restaurant_id,
        ROUND(SUM(total_amount), 2) AS total_revenue
    FROM orders_clean
    WHERE is_cancelled = 0
    GROUP BY restaurant_id
),
restaurant_reviews AS
(
    SELECT
        restaurant_id,
        ROUND(AVG(rating), 2) AS average_review_rating,
        COUNT(*) AS total_reviews
    FROM reviews_clean
    GROUP BY restaurant_id
)
SELECT
    r.restaurant_id,
    r.restaurant_name,
    COALESCE(rr.total_revenue, 0) AS total_revenue,
    rv.average_review_rating,
    COALESCE(rv.total_reviews, 0) AS total_reviews
FROM restaurants_clean r
LEFT JOIN restaurant_revenue rr
    ON r.restaurant_id = rr.restaurant_id
LEFT JOIN restaurant_reviews rv
    ON r.restaurant_id = rv.restaurant_id
ORDER BY total_revenue DESC
LIMIT 10;

/*
Observation:
The query compares restaurant revenue with customer review
ratings and review volume. Separate aggregations prevent revenue
duplication when restaurants have multiple orders and reviews.
*/

-- 7.6 Business Analysis: City-wise Delivery and Revenue

SELECT
    c.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue,
    ROUND(AVG(d.actual_delivery_time_mins), 2) AS average_delivery_time,
    ROUND(AVG(d.delivery_delay_mins), 2) AS average_delivery_delay
FROM orders_clean o
JOIN customers_clean c
    ON o.customer_id = c.customer_id
JOIN delivery_clean d
    ON o.order_id = d.order_id
WHERE o.is_cancelled = 0
GROUP BY c.city
ORDER BY total_revenue DESC;

/*
Observation:
The query compares city-wise revenue and order volume with
actual delivery time and delivery delay, providing an integrated
view of market and operational performance.
*/

-- 7.7 Business Analysis: Customer Lifetime Spending

WITH customer_spending AS
(
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_spent
    FROM orders_clean
    WHERE is_cancelled = 0
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_orders,
    ROUND(total_spent, 2) AS total_spent,
    CASE
        WHEN total_spent >= 50000 THEN 'High Value'
        WHEN total_spent >= 25000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_value_segment
FROM customer_spending
ORDER BY total_spent DESC;

/*
Observation:
The CTE calculates customer-level spending and assigns value
segments. The thresholds are analytical segmentation rules and
can be adjusted if the project defines different thresholds.
*/

-- 7.8 Business Analysis: Top Restaurant in Each City by Revenue

WITH restaurant_revenue AS
(
    SELECT
        r.city,
        r.restaurant_id,
        r.restaurant_name,
        SUM(o.total_amount) AS total_revenue
    FROM restaurants_clean r
    JOIN orders_clean o
        ON r.restaurant_id = o.restaurant_id
    WHERE o.is_cancelled = 0
    GROUP BY r.city, r.restaurant_id, r.restaurant_name
),
ranked_restaurants AS
(
    SELECT
        city,
        restaurant_id,
        restaurant_name,
        total_revenue,
        ROW_NUMBER() OVER
        (
            PARTITION BY city
            ORDER BY total_revenue DESC
        ) AS rank_no
    FROM restaurant_revenue
)
SELECT
    city,
    restaurant_id,
    restaurant_name,
    ROUND(total_revenue, 2) AS total_revenue
FROM ranked_restaurants
WHERE rank_no = 1
ORDER BY city;

/*
Observation:
The query identifies the highest-revenue restaurant in each
city and supports geographic restaurant benchmarking.
*/

-- 7.9 Business Analysis: Top Food Item in Each Category

WITH category_items AS
(
    SELECT
        m.category,
        m.menu_item_id,
        m.item_name,
        SUM(oi.quantity) AS total_quantity
    FROM menu_items_clean m
    JOIN order_items_clean oi
        ON m.menu_item_id = oi.menu_item_id
    GROUP BY m.category, m.menu_item_id, m.item_name
),
ranked_items AS
(
    SELECT
        category,
        menu_item_id,
        item_name,
        total_quantity,
        ROW_NUMBER() OVER
        (
            PARTITION BY category
            ORDER BY total_quantity DESC
        ) AS rank_no
    FROM category_items
)
SELECT
    category,
    menu_item_id,
    item_name,
    total_quantity
FROM ranked_items
WHERE rank_no = 1
ORDER BY category;

/*
Observation:
The query identifies the most ordered menu item within each
category and supports category-level menu planning.
*/

-- 7.10 Business Analysis: Delivery Partner Workload and Performance

SELECT
    dp.delivery_partner_id,
    dp.partner_name,
    dp.city,
    dp.vehicle_type,
    dp.employment_type,
    ROUND(dp.avg_rating, 2) AS partner_rating,
    dp.is_active,
    COUNT(d.order_id) AS total_deliveries,
    ROUND(AVG(d.actual_delivery_time_mins), 2) AS average_delivery_time,
    ROUND(AVG(d.delivery_delay_mins), 2) AS average_delivery_delay
FROM delivery_partners_clean dp
JOIN orders_clean o
    ON dp.delivery_partner_id = o.delivery_partner_id
JOIN delivery_clean d
    ON o.order_id = d.order_id
GROUP BY
    dp.delivery_partner_id,
    dp.partner_name,
    dp.city,
    dp.vehicle_type,
    dp.employment_type,
    dp.avg_rating,
    dp.is_active
ORDER BY total_deliveries DESC;

/*
Observation:
The query combines delivery-partner workload, rating, activity
status, vehicle type, employment type, delivery time, and delay.
This supports operational partner-performance analysis.
*/

-- ============================================================
-- STEP 8 — ADVANCED SQL BUSINESS ANALYSIS
-- ============================================================

-- 8.1 Advanced Analysis: Rank Restaurants by Revenue

SELECT
    r.restaurant_id,
    r.restaurant_name,
    ROUND(SUM(o.total_amount), 2) AS total_revenue,
    RANK() OVER
    (
        ORDER BY SUM(o.total_amount) DESC
    ) AS revenue_rank
FROM restaurants_clean r
JOIN orders_clean o
    ON r.restaurant_id = o.restaurant_id
WHERE o.is_cancelled = 0
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY revenue_rank;

/*
Observation:
The query ranks restaurants according to completed-order revenue
and supports relative restaurant-performance comparison.
*/

-- 8.2 Advanced Analysis: Rank Food Items by Quantity Sold

SELECT
    m.menu_item_id,
    m.item_name,
    m.category,
    SUM(oi.quantity) AS total_quantity_sold,
    RANK() OVER
    (
        ORDER BY SUM(oi.quantity) DESC
    ) AS popularity_rank
FROM menu_items_clean m
JOIN order_items_clean oi
    ON m.menu_item_id = oi.menu_item_id
GROUP BY m.menu_item_id, m.item_name, m.category
ORDER BY popularity_rank;

/*
Observation:
The query ranks menu items according to quantity sold and helps
identify the most popular food products.
*/

-- 8.3 Advanced Analysis: Rank Customers by Total Spending

SELECT
    c.customer_id,
    c.city,
    ROUND(SUM(o.total_amount), 2) AS total_spent,
    RANK() OVER
    (
        ORDER BY SUM(o.total_amount) DESC
    ) AS customer_rank
FROM customers_clean c
JOIN orders_clean o
    ON c.customer_id = o.customer_id
WHERE o.is_cancelled = 0
GROUP BY c.customer_id, c.city
ORDER BY customer_rank
LIMIT 20;

/*
Observation:
The query ranks customers by completed-order spending and helps
identify high-value customer segments.
*/

-- 8.4 Advanced Analysis: City Revenue Contribution

WITH city_revenue AS
(
    SELECT
        c.city,
        SUM(o.total_amount) AS total_revenue
    FROM customers_clean c
    JOIN orders_clean o
        ON c.customer_id = o.customer_id
    WHERE o.is_cancelled = 0
    GROUP BY c.city
)
SELECT
    city,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        total_revenue * 100 /
        SUM(total_revenue) OVER (),
        2
    ) AS revenue_percentage
FROM city_revenue
ORDER BY total_revenue DESC;

/*
Observation:
The query calculates each city's contribution to total platform
revenue and helps identify markets with greater financial impact.
*/

-- 8.5 Advanced Analysis: Restaurant Revenue Contribution

WITH restaurant_revenue AS
(
    SELECT
        r.restaurant_id,
        r.restaurant_name,
        SUM(o.total_amount) AS total_revenue
    FROM restaurants_clean r
    JOIN orders_clean o
        ON r.restaurant_id = o.restaurant_id
    WHERE o.is_cancelled = 0
    GROUP BY r.restaurant_id, r.restaurant_name
)
SELECT
    restaurant_id,
    restaurant_name,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        total_revenue * 100 /
        SUM(total_revenue) OVER (),
        2
    ) AS revenue_percentage
FROM restaurant_revenue
ORDER BY total_revenue DESC
LIMIT 20;

/*
Observation:
The query calculates each restaurant's contribution to total
platform revenue and highlights restaurants with greater business
impact.
*/

-- 8.6 Advanced Analysis: Repeat Customers

SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders_clean
WHERE is_cancelled = 0
GROUP BY customer_id
HAVING COUNT(order_id) > 1
ORDER BY total_orders DESC;

/*
Observation:
The query identifies customers placing more than one completed
order and supports repeat-customer analysis.
*/

-- 8.7 Advanced Analysis: Repeat Customer Percentage

WITH customer_orders AS
(
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders_clean
    WHERE is_cancelled = 0
    GROUP BY customer_id
)
SELECT
    ROUND(
        SUM(
            CASE
                WHEN total_orders > 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM customer_orders;

/*
Observation:
The query calculates the percentage of active customers who
placed more than one completed order and provides a retention KPI.
*/

-- 8.8 Advanced Analysis: Cancellation Rate

SELECT
    ROUND(
        SUM(
            CASE
                WHEN is_cancelled = 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM orders_clean;

/*
Observation:
The query calculates the percentage of all orders marked as
cancelled and provides an important operational KPI.
*/

-- 8.9 Advanced Analysis: Cancellation Rate by City

SELECT
    c.city,
    COUNT(o.order_id) AS total_orders,
    SUM(
        CASE
            WHEN o.is_cancelled = 1 THEN 1
            ELSE 0
        END
    ) AS cancelled_orders,
    ROUND(
        SUM(
            CASE
                WHEN o.is_cancelled = 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(o.order_id),
        2
    ) AS cancellation_rate
FROM orders_clean o
JOIN customers_clean c
    ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY cancellation_rate DESC;

/*
Observation:
The query compares cancellation rates across cities and helps
identify locations with relatively higher cancellation levels.
*/

-- 8.10 Advanced Analysis: Customer Order Ranking Within Each City

SELECT
    c.customer_id,
    c.city,
    COUNT(o.order_id) AS total_orders,
    RANK() OVER
    (
        PARTITION BY c.city
        ORDER BY COUNT(o.order_id) DESC
    ) AS city_customer_rank
FROM customers_clean c
JOIN orders_clean o
    ON c.customer_id = o.customer_id
WHERE o.is_cancelled = 0
GROUP BY c.customer_id, c.city
ORDER BY c.city, city_customer_rank;

/*
Observation:
The query ranks customers within each city according to
completed-order frequency and identifies the most active customers
in individual markets.
*/

-- 8.11 Advanced Analysis: Top 3 Restaurants in Each City

WITH restaurant_sales AS
(
    SELECT
        r.city,
        r.restaurant_id,
        r.restaurant_name,
        SUM(o.total_amount) AS total_revenue
    FROM restaurants_clean r
    JOIN orders_clean o
        ON r.restaurant_id = o.restaurant_id
    WHERE o.is_cancelled = 0
    GROUP BY r.city, r.restaurant_id, r.restaurant_name
),
ranked_restaurants AS
(
    SELECT
        city,
        restaurant_id,
        restaurant_name,
        total_revenue,
        ROW_NUMBER() OVER
        (
            PARTITION BY city
            ORDER BY total_revenue DESC
        ) AS rank_no
    FROM restaurant_sales
)
SELECT
    city,
    restaurant_id,
    restaurant_name,
    ROUND(total_revenue, 2) AS total_revenue,
    rank_no
FROM ranked_restaurants
WHERE rank_no <= 3
ORDER BY city, rank_no;

/*
Observation:
The query identifies the top three revenue-generating restaurants
within each city and supports city-level competitive analysis.
*/

-- 8.12 Advanced Analysis: Delivery Time Ranking

SELECT
    order_id,
    actual_delivery_time_mins,
    expected_delivery_time_mins,
    distance_km,
    delivery_delay_mins,
    sla_met,
    RANK() OVER
    (
        ORDER BY actual_delivery_time_mins ASC
    ) AS delivery_speed_rank
FROM delivery_clean
ORDER BY delivery_speed_rank
LIMIT 20;

/*
Observation:
The query ranks deliveries from fastest to slowest based on
actual delivery time and retains the expected time, distance,
delay, and SLA context.
*/

-- ============================================================
-- STEP 9 — FINAL BUSINESS KPIs & EXECUTIVE SUMMARY
-- ============================================================

-- KPI 1: Total Customers

SELECT COUNT(*) AS total_customers
FROM customers_clean;

/* Observation:
The query calculates the total number of customers in the
cleaned customer dataset.
*/

-- KPI 2: Total Restaurants

SELECT COUNT(*) AS total_restaurants
FROM restaurants_clean;

/* Observation:
The query calculates the total number of restaurants in the
cleaned restaurant dataset.
*/

-- KPI 3: Total Menu Items

SELECT COUNT(*) AS total_menu_items
FROM menu_items_clean;

/* Observation:
The query calculates the total number of menu items available.
*/

-- KPI 4: Total Orders

SELECT COUNT(*) AS total_orders
FROM orders_clean;

/* Observation:
The query calculates the total number of orders recorded.
*/

-- KPI 5: Completed Orders

SELECT COUNT(*) AS completed_orders
FROM orders_clean
WHERE is_cancelled = 0;

/* Observation:
The query calculates the number of non-cancelled orders.
*/

-- KPI 6: Cancelled Orders

SELECT COUNT(*) AS cancelled_orders
FROM orders_clean
WHERE is_cancelled = 1;

/* Observation:
The query calculates the total number of cancelled orders.
*/

-- KPI 7: Cancellation Rate

SELECT
    ROUND(
        SUM(CASE WHEN is_cancelled = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM orders_clean;

/* Observation:
The query calculates the percentage of all orders marked as
cancelled.
*/

-- KPI 8: Total Revenue

SELECT
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders_clean
WHERE is_cancelled = 0;

/* Observation:
The query calculates revenue generated from non-cancelled orders.
*/

-- KPI 9: Average Order Value

SELECT
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM orders_clean
WHERE is_cancelled = 0;

/* Observation:
The query calculates the average value of completed orders.
*/

-- KPI 10: Average Delivery Time

SELECT
    ROUND(AVG(actual_delivery_time_mins), 2) AS average_delivery_time
FROM delivery_clean;

/* Observation:
The query calculates the average actual delivery time.
*/

-- KPI 11: Average Customer Rating

SELECT
    ROUND(AVG(rating), 2) AS average_customer_rating
FROM reviews_clean;

/* Observation:
The query calculates the average customer review rating.
*/

-- KPI 12: Total Reviews

SELECT COUNT(*) AS total_reviews
FROM reviews_clean;

/* Observation:
The query calculates the total number of customer reviews.
*/

-- KPI 13: Repeat Customer Percentage

WITH customer_orders AS
(
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders_clean
    WHERE is_cancelled = 0
    GROUP BY customer_id
)
SELECT
    ROUND(
        SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM customer_orders;

/* Observation:
The query calculates the percentage of active customers who
placed more than one completed order.
*/

-- KPI 14: Average Items per Order

SELECT
    ROUND(
        SUM(quantity) / COUNT(DISTINCT order_id),
        2
    ) AS average_items_per_order
FROM order_items_clean;

/* Observation:
The query calculates the average number of food items included
in each order.
*/

-- KPI 15: Completed Delivery Rate / SLA Rate

SELECT
    ROUND(
        SUM(CASE WHEN sla_met = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS completed_delivery_rate
FROM delivery_clean;

/*
Observation:
The query calculates the percentage of delivery records marked
as meeting the cleaned SLA indicator. This KPI uses the actual
sla_met field present in delivery_clean.
*/

-- Final Executive KPI Summary

SELECT
    (SELECT COUNT(*) FROM customers_clean) AS total_customers,
    (SELECT COUNT(*) FROM restaurants_clean) AS total_restaurants,
    (SELECT COUNT(*) FROM menu_items_clean) AS total_menu_items,
    (SELECT COUNT(*) FROM orders_clean) AS total_orders,
    (SELECT COUNT(*) FROM orders_clean WHERE is_cancelled = 0) AS completed_orders,
    (SELECT COUNT(*) FROM orders_clean WHERE is_cancelled = 1) AS cancelled_orders,
    (SELECT ROUND(SUM(total_amount), 2)
     FROM orders_clean WHERE is_cancelled = 0) AS total_revenue,
    (SELECT ROUND(AVG(total_amount), 2)
     FROM orders_clean WHERE is_cancelled = 0) AS average_order_value,
    (SELECT ROUND(AVG(actual_delivery_time_mins), 2)
     FROM delivery_clean) AS average_delivery_time,
    (SELECT ROUND(AVG(rating), 2)
     FROM reviews_clean) AS average_customer_rating,
    (SELECT COUNT(*) FROM reviews_clean) AS total_reviews,
    (SELECT ROUND(
        SUM(CASE WHEN sla_met = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2)
     FROM delivery_clean) AS completed_delivery_rate;

/*
Observation:
The final executive KPI query consolidates customer, restaurant,
menu, order, revenue, delivery, and review indicators into a
single management-level result.
*/

-- ============================================================
-- STEP 10 — FINAL DATA VALIDATION & SQL QUALITY CHECKS
-- ============================================================

-- Validation 1: Check Duplicate Customer IDs

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers_clean
GROUP BY customer_id
HAVING COUNT(*) > 1;

/* Observation:
The query checks whether customer IDs are duplicated in the
cleaned customer table.
*/

-- Validation 2: Check Duplicate Restaurant IDs

SELECT
    restaurant_id,
    COUNT(*) AS duplicate_count
FROM restaurants_clean
GROUP BY restaurant_id
HAVING COUNT(*) > 1;

/* Observation:
The query checks whether restaurant IDs are duplicated.
*/

-- Validation 3: Check Duplicate Menu Item IDs

SELECT
    menu_item_id,
    COUNT(*) AS duplicate_count
FROM menu_items_clean
GROUP BY menu_item_id
HAVING COUNT(*) > 1;

/* Observation:
The query checks whether menu-item IDs are duplicated.
*/

-- Validation 4: Check Duplicate Order IDs

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders_clean
GROUP BY order_id
HAVING COUNT(*) > 1;

/* Observation:
The query checks whether order IDs are duplicated.
*/

-- Validation 5: Check Duplicate Order Item Keys

SELECT
    order_item_key,
    COUNT(*) AS duplicate_count
FROM order_items_clean
GROUP BY order_item_key
HAVING COUNT(*) > 1;

/* Observation:
The query checks whether the cleaned order-item key is duplicated.
*/

-- Validation 6: Check NULL Customer IDs

SELECT COUNT(*) AS null_customer_ids
FROM customers_clean
WHERE customer_id IS NULL;

/* Observation:
The query checks whether required customer identifiers are NULL.
*/

-- Validation 7: Check NULL Order IDs

SELECT COUNT(*) AS null_order_ids
FROM orders_clean
WHERE order_id IS NULL;

/* Observation:
The query checks whether required order identifiers are NULL.
*/

-- Validation 8: Check NULL Restaurant IDs

SELECT COUNT(*) AS null_restaurant_ids
FROM restaurants_clean
WHERE restaurant_id IS NULL;

/* Observation:
The query checks whether required restaurant identifiers are NULL.
*/

-- Validation 9: Check Invalid Menu Prices

SELECT COUNT(*) AS invalid_menu_prices
FROM menu_items_clean
WHERE price < 0;

/* Observation:
The query checks for negative menu prices.
*/

-- Validation 10: Check Invalid Order Amounts

SELECT COUNT(*) AS invalid_order_amounts
FROM orders_clean
WHERE subtotal_amount < 0
   OR discount_amount < 0
   OR delivery_fee < 0
   OR total_amount < 0;

/* Observation:
The query checks important order financial fields for negative
values that would violate basic business logic.
*/

-- Validation 11: Check Invalid Calculated Order Totals

SELECT
    COUNT(*) AS inconsistent_order_totals
FROM orders_clean
WHERE ABS(total_difference) > 0.01;

/*
Observation:
The query identifies orders where the recorded total differs
from the calculated total by more than one cent. Any differences
should be reviewed against the Python financial-validation result.
*/

-- Validation 12: Check Invalid Restaurant Preparation Times

SELECT COUNT(*) AS invalid_prep_times
FROM restaurants_clean
WHERE avg_prep_time_min < 0;

/* Observation:
The query checks for negative restaurant preparation times.
*/

-- Validation 13: Check Invalid Review Ratings

SELECT COUNT(*) AS invalid_review_ratings
FROM reviews_clean
WHERE rating < 1 OR rating > 5;

/* Observation:
The query checks whether customer review ratings fall outside
the expected 1-to-5 range.
*/

-- Validation 14: Check Invalid Delivery Times

SELECT COUNT(*) AS invalid_delivery_times
FROM delivery_clean
WHERE actual_delivery_time_mins < 0
   OR expected_delivery_time_mins < 0;

/* Observation:
The query checks for negative actual or expected delivery times.
*/

-- Validation 15: Check Order Cancellation Values

SELECT DISTINCT
    is_cancelled
FROM orders_clean
ORDER BY is_cancelled;

/*
Observation:
The query verifies the distinct values stored in the cleaned
order cancellation field.
*/

-- Validation 16: Check Delivery SLA Values

SELECT DISTINCT
    sla_met
FROM delivery_clean
ORDER BY sla_met;

/*
Observation:
The query verifies the distinct values stored in the cleaned
SLA indicator.
*/

-- Validation 17: Check Financial Reconciliation Fields

SELECT
    COUNT(*) AS records_with_total_difference
FROM orders_clean
WHERE total_difference IS NOT NULL;

/*
Observation:
The query verifies that the financial reconciliation field is
available for the cleaned order records. It does not overwrite
original financial values.
*/

-- Validation 18: Check Order-to-Customer Relationship

SELECT
    COUNT(*) AS unmatched_orders
FROM orders_clean o
LEFT JOIN customers_clean c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

/*
Observation:
The query checks whether every order references a valid customer.
A zero result indicates complete order-to-customer linkage.
*/

-- Validation 19: Check Order-to-Restaurant Relationship

SELECT
    COUNT(*) AS unmatched_orders
FROM orders_clean o
LEFT JOIN restaurants_clean r
    ON o.restaurant_id = r.restaurant_id
WHERE r.restaurant_id IS NULL;

/*
Observation:
The query checks whether every order references a valid restaurant.
*/

-- Validation 20: Check Order-to-Delivery Relationship

SELECT
    COUNT(*) AS unmatched_deliveries
FROM delivery_clean d
LEFT JOIN orders_clean o
    ON d.order_id = o.order_id
WHERE o.order_id IS NULL;

/*
Observation:
The query checks whether every delivery record references a valid
order.
*/

-- Validation 21: Check Order Item Relationships

SELECT
    COUNT(*) AS unmatched_order_items
FROM order_items_clean oi
LEFT JOIN orders_clean o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

/*
Observation:
The query checks whether every order-item record references a
valid order.
*/

-- Validation 22: Check Menu Item Relationships

SELECT
    COUNT(*) AS unmatched_menu_items
FROM order_items_clean oi
LEFT JOIN menu_items_clean m
    ON oi.menu_item_id = m.menu_item_id
WHERE m.menu_item_id IS NULL;

/*
Observation:
The query checks whether every order-item menu reference points
to a valid menu item.
*/

-- Validation 23: Check Delivery Partner Relationships

SELECT
    COUNT(*) AS unmatched_delivery_partners
FROM orders_clean o
LEFT JOIN delivery_partners_clean dp
    ON o.delivery_partner_id = dp.delivery_partner_id
WHERE o.delivery_partner_id IS NOT NULL
  AND dp.delivery_partner_id IS NULL;

/*
Observation:
The query checks whether delivery-partner references stored in
orders match valid delivery-partner records.
*/

-- Validation 24: Check Review-to-Restaurant Relationship

SELECT
    COUNT(*) AS unmatched_reviews
FROM reviews_clean rv
LEFT JOIN restaurants_clean r
    ON rv.restaurant_id = r.restaurant_id
WHERE r.restaurant_id IS NULL;

/*
Observation:
The query checks whether every review references a valid restaurant.
*/

-- Validation 25: Final Row Count Verification

SELECT 'customers_clean' AS table_name, COUNT(*) AS total_rows
FROM customers_clean
UNION ALL
SELECT 'restaurants_clean', COUNT(*)
FROM restaurants_clean
UNION ALL
SELECT 'menu_items_clean', COUNT(*)
FROM menu_items_clean
UNION ALL
SELECT 'delivery_partners_clean', COUNT(*)
FROM delivery_partners_clean
UNION ALL
SELECT 'orders_clean', COUNT(*)
FROM orders_clean
UNION ALL
SELECT 'order_items_clean', COUNT(*)
FROM order_items_clean
UNION ALL
SELECT 'delivery_clean', COUNT(*)
FROM delivery_clean
UNION ALL
SELECT 'reviews_clean', COUNT(*)
FROM reviews_clean;

/*
Observation:
The final row-count query verifies the number of records in all
eight cleaned SQL tables. These counts should be compared with
the final Python-cleaned dataset counts before submission.
*/

-- ============================================================
-- STEP 11 — FINAL BUSINESS INSIGHTS & STRATEGIC ANALYSIS
-- ============================================================

-- Insight 1: Top Revenue-Generating Cities

SELECT
    c.city,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM orders_clean o
JOIN customers_clean c
    ON o.customer_id = c.customer_id
WHERE o.is_cancelled = 0
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 10;

/*
Business Insight:
The query identifies cities generating higher completed-order
revenue.

Business Recommendation:
High-revenue cities can be prioritized for marketing, restaurant
partnerships, delivery capacity, and market-development efforts.
*/

-- Insight 2: Highest-Value Customers

SELECT
    c.customer_id,
    c.city,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers_clean c
JOIN orders_clean o
    ON c.customer_id = o.customer_id
WHERE o.is_cancelled = 0
GROUP BY c.customer_id, c.city
ORDER BY total_spent DESC
LIMIT 20;

/*
Business Insight:
The query identifies customers with higher completed-order
spending.

Business Recommendation:
High-value customers can be targeted with loyalty programs,
personalized offers, and retention campaigns.
*/

-- Insight 3: Most Popular Food Categories

SELECT
    m.category,
    SUM(oi.quantity) AS total_quantity_sold,
    ROUND(SUM(oi.line_total), 2) AS category_revenue
FROM order_items_clean oi
JOIN menu_items_clean m
    ON oi.menu_item_id = m.menu_item_id
GROUP BY m.category
ORDER BY total_quantity_sold DESC;

/*
Business Insight:
The query identifies food categories with stronger demand.

Business Recommendation:
High-demand categories can receive stronger inventory attention,
promotions, featured placement, and combo strategies.
*/

-- Insight 4: Highest-Revenue Restaurants

SELECT
    r.restaurant_id,
    r.restaurant_name,
    r.city,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM restaurants_clean r
JOIN orders_clean o
    ON r.restaurant_id = o.restaurant_id
WHERE o.is_cancelled = 0
GROUP BY r.restaurant_id, r.restaurant_name, r.city
ORDER BY total_revenue DESC
LIMIT 20;

/*
Business Insight:
The query identifies restaurants contributing higher revenue.

Business Recommendation:
High-performing restaurants can be considered for stronger
partnerships, featured placement, and joint promotional activity.
*/

-- Insight 5: Restaurants Requiring Attention

SELECT
    r.restaurant_id,
    r.restaurant_name,
    r.city,
    ROUND(AVG(rv.rating), 2) AS average_review_rating,
    COUNT(rv.order_id) AS total_reviews
FROM restaurants_clean r
JOIN reviews_clean rv
    ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name, r.city
HAVING COUNT(rv.order_id) >= 5
ORDER BY average_review_rating ASC
LIMIT 20;

/*
Business Insight:
The query identifies restaurants with relatively lower customer
review ratings among restaurants with sufficient review volume.

Business Recommendation:
Restaurants with weaker customer feedback can be reviewed for
food quality, service quality, preparation time, and customer
experience improvements.
*/

-- Insight 6: Cities with High Cancellation Rates

SELECT
    c.city,
    COUNT(o.order_id) AS total_orders,
    SUM(CASE WHEN o.is_cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(
        SUM(CASE WHEN o.is_cancelled = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(o.order_id),
        2
    ) AS cancellation_rate
FROM orders_clean o
JOIN customers_clean c
    ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY cancellation_rate DESC
LIMIT 10;

/*
Business Insight:
The query identifies cities with relatively higher cancellation
rates.

Business Recommendation:
High-cancellation cities should be investigated for operational
issues such as delivery delays, restaurant availability, payment
issues, or customer-experience problems.
*/

-- Insight 7: Delivery Performance by City

SELECT
    c.city,
    COUNT(d.order_id) AS total_deliveries,
    ROUND(AVG(d.actual_delivery_time_mins), 2) AS average_delivery_time,
    ROUND(AVG(d.delivery_delay_mins), 2) AS average_delivery_delay,
    ROUND(AVG(d.sla_met) * 100, 2) AS sla_rate
FROM delivery_clean d
JOIN orders_clean o
    ON d.order_id = o.order_id
JOIN customers_clean c
    ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY average_delivery_time DESC;

/*
Business Insight:
The query identifies cities with slower or faster delivery
performance and compares delivery delay and SLA achievement.

Business Recommendation:
Cities with longer delivery times or lower SLA performance can be
reviewed for delivery capacity, restaurant preparation, traffic,
and delivery-zone planning.
*/

-- Insight 8: Top Delivery Partners

SELECT
    dp.delivery_partner_id,
    dp.partner_name,
    dp.city,
    ROUND(dp.avg_rating, 2) AS partner_rating,
    COUNT(d.order_id) AS total_deliveries,
    ROUND(AVG(d.actual_delivery_time_mins), 2) AS average_delivery_time,
    ROUND(AVG(d.delivery_delay_mins), 2) AS average_delivery_delay
FROM delivery_partners_clean dp
JOIN orders_clean o
    ON dp.delivery_partner_id = o.delivery_partner_id
JOIN delivery_clean d
    ON o.order_id = d.order_id
GROUP BY
    dp.delivery_partner_id,
    dp.partner_name,
    dp.city,
    dp.avg_rating
ORDER BY total_deliveries DESC
LIMIT 20;

/*
Business Insight:
The query identifies delivery partners handling higher workloads
and compares their rating and delivery performance.

Business Recommendation:
Consistently strong delivery partners can be considered for higher
capacity allocation and performance recognition.
*/

-- Insight 9: Repeat Customer Analysis

WITH customer_orders AS
(
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders_clean
    WHERE is_cancelled = 0
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS total_active_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM customer_orders;

/*
Business Insight:
The query measures repeat-order behavior among active customers.

Business Recommendation:
Repeat-customer percentage should be monitored as a retention KPI.
Loyalty rewards, personalized recommendations, discounts, and
campaigns can be used to encourage repeat purchases.
*/

-- Insight 10: Top Food Items

SELECT
    m.menu_item_id,
    m.item_name,
    m.category,
    SUM(oi.quantity) AS total_quantity_sold,
    ROUND(SUM(oi.line_total), 2) AS estimated_revenue
FROM order_items_clean oi
JOIN menu_items_clean m
    ON oi.menu_item_id = m.menu_item_id
GROUP BY m.menu_item_id, m.item_name, m.category
ORDER BY total_quantity_sold DESC
LIMIT 20;

/*
Business Insight:
The query identifies the most frequently purchased food items.

Business Recommendation:
Popular items can be promoted through recommendations, combo
offers, featured listings, and category-level campaigns.
*/

-- Insight 11: Restaurant Review Rating vs Revenue

WITH restaurant_revenue AS
(
    SELECT
        restaurant_id,
        COUNT(order_id) AS total_orders,
        ROUND(SUM(total_amount), 2) AS total_revenue
    FROM orders_clean
    WHERE is_cancelled = 0
    GROUP BY restaurant_id
),
restaurant_reviews AS
(
    SELECT
        restaurant_id,
        ROUND(AVG(rating), 2) AS average_review_rating,
        COUNT(*) AS total_reviews
    FROM reviews_clean
    GROUP BY restaurant_id
)
SELECT
    r.restaurant_id,
    r.restaurant_name,
    rr.average_review_rating,
    rr.total_reviews,
    COALESCE(rv.total_orders, 0) AS total_orders,
    COALESCE(rv.total_revenue, 0) AS total_revenue
FROM restaurants_clean r
LEFT JOIN restaurant_reviews rr
    ON r.restaurant_id = rr.restaurant_id
LEFT JOIN restaurant_revenue rv
    ON r.restaurant_id = rv.restaurant_id
ORDER BY total_revenue DESC
LIMIT 20;

/*
Business Insight:
The query compares restaurant customer-review ratings with order
volume and revenue without duplicating revenue through a many-to-many
join.

Business Recommendation:
Restaurants combining strong customer feedback with strong revenue
can be considered strategic partners, while high-revenue restaurants
with weaker ratings may require service-quality improvement.
*/

-- Insight 12: Overall Platform Performance

SELECT
    COUNT(DISTINCT o.customer_id) AS active_customers,
    COUNT(DISTINCT o.restaurant_id) AS active_restaurants,
    COUNT(o.order_id) AS total_orders,
    ROUND(
        SUM(CASE WHEN o.is_cancelled = 0 THEN o.total_amount ELSE 0 END),
        2
    ) AS total_revenue,
    ROUND(
        AVG(CASE WHEN o.is_cancelled = 0 THEN o.total_amount END),
        2
    ) AS average_order_value
FROM orders_clean o;

/*
Business Insight:
The query provides a consolidated view of customer, restaurant,
order, revenue, and average-order performance.

Business Recommendation:
These measures can be used as core executive KPIs for QuickBite
Express management reporting and dashboard development.
*/

-- ============================================================
-- STEP 12 — FINAL PROJECT CONCLUSION
-- ============================================================

/*
FINAL PROJECT CONCLUSION

Project:
QuickBite Express — SQL Data Analysis

PROJECT SUMMARY:

The QuickBite Express SQL project was developed to analyze
food-delivery business data using SQL.

The analysis was performed on eight Python-cleaned datasets:

1. customers_clean
2. restaurants_clean
3. menu_items_clean
4. delivery_partners_clean
5. orders_clean
6. order_items_clean
7. delivery_clean
8. reviews_clean

DATA PREPARATION:

The datasets were first cleaned and validated using Python.
The cleaned datasets were then used as the controlled input
for MySQL-based SQL analysis.

SQL TECHNIQUES USED:

SELECT, WHERE, GROUP BY, HAVING, ORDER BY, DISTINCT, CASE,
aggregate functions, INNER JOIN, LEFT JOIN, CTEs, subqueries,
ROW_NUMBER(), RANK(), PARTITION BY, window functions, and
conditional aggregation.

KEY BUSINESS AREAS ANALYZED:

1. Customer Analysis
   - Customer distribution by city
   - Acquisition-channel activity
   - Customer sign-up activity
   - Customer spending
   - Repeat customers

2. Restaurant Analysis
   - Restaurants by city
   - Cuisine-type distribution
   - Partner-type distribution
   - Restaurant order performance
   - Restaurant revenue
   - Preparation-time performance

3. Menu Analysis
   - Menu items by category
   - Average menu prices
   - Popular menu items
   - Food-category demand
   - Food-item revenue

4. Order Analysis
   - Cancelled and non-cancelled orders
   - Completed-order revenue
   - Average order value
   - City-wise order performance
   - Cancellation rate

5. Delivery Analysis
   - SLA performance
   - Average delivery time
   - Delivery delay
   - City-wise delivery performance
   - Delivery partner workload and performance

6. Review Analysis
   - Rating distribution
   - Average customer rating
   - Positive, neutral, and negative review groups
   - Restaurant-level customer feedback
   - Review activity

7. Integrated Business Analysis
   - Customer and order performance
   - Restaurant revenue and reviews
   - City-wise revenue and delivery performance
   - Food-category performance
   - Delivery-partner performance
   - Customer-value segmentation

KEY BUSINESS INSIGHTS:

The analysis provides a structured view of QuickBite Express
customer behavior, restaurant performance, food demand, order
activity, delivery operations, and customer satisfaction.

High-revenue cities can be prioritized for marketing, restaurant
partnerships, and delivery capacity.

High-value and repeat customers can be targeted through loyalty
programs, personalized recommendations, and retention campaigns.

Popular food categories and menu items can support inventory,
promotion, featured placement, and menu optimization decisions.

High-performing restaurants can be prioritized for strategic
partnerships and promotional opportunities.

Restaurants with relatively lower customer ratings can be reviewed
for food quality, service quality, preparation time, and customer
experience improvements.

Cities with higher cancellation rates can be investigated for
operational issues and customer-experience problems.

Delivery analysis can identify locations and delivery partners
requiring operational improvement.

Customer ratings and reviews provide additional evidence for
monitoring customer satisfaction.

DATA QUALITY CONCLUSION:

The SQL validation stage checks duplicate identifiers, NULL key
values, invalid numerical values, financial reconciliation fields,
SLA values, and relationships between the major tables.

The final row-count verification provides a final check that the
SQL tables contain the expected cleaned records.

FINAL CONCLUSION:

The QuickBite Express SQL project demonstrates how cleaned business
data can be transformed into actionable business intelligence using
SQL.

The project combines data verification, relational database analysis,
advanced SQL techniques, KPI development, data-quality validation,
business interpretation, and strategic recommendations.

The resulting analysis supports decision-making related to customer
retention, restaurant partnerships, food demand, delivery operations,
market performance, and overall platform performance.

The SQL analysis therefore provides a strong foundation for executive
reporting and the final business dashboard.
*/

-- ============================================================
-- END OF QUICKBITE EXPRESS SQL ANALYSIS
-- ============================================================
