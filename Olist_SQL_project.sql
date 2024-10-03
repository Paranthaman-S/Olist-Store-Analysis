create database olist_project;
use olist_project;

select * from olist_customers_dataset;
select * from olist_order_items_dataset;
select * from olist_order_payments_dataset;
select * from olist_order_reviews_dataset;
select * from olist_orders_dataset;
select * from olist_products_dataset;

#1. WEEKDAY VS WEEKEND PAYMENT STATISTICS:

USE olist_project;

SELECT 
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) IN (1, 7) 
        THEN 'weekend' 
        ELSE 'weekday' 
    END AS DayType,
    COUNT(DISTINCT o.order_id) AS totalorders,
    ROUND(SUM(p.payment_value)) AS totalpayments,
    ROUND(AVG(p.payment_value)) AS averagepayment
FROM
    olist_orders_dataset o
JOIN 
    olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY 
    DayType;

#2nd KPI

SELECT 
    COUNT(DISTINCT p.order_id) AS numberoforders
FROM
    olist_order_payments_dataset p
JOIN
    olist_order_reviews_dataset r ON p.order_id = r.order_id
WHERE 
    r.review_score = 5
    AND p.payment_type = 'credit_card';
    
#3rd KPI

SELECT
    p.product_category_name,
    ROUND(AVG(DATEDIFF(
        STR_TO_DATE(o.order_delivered_customer_date, '%d-%m-%Y %H:%i:%s'), 
        STR_TO_DATE(o.order_purchase_timestamp, '%d-%m-%Y %H:%i:%s')
    ))) AS avg_delivery_time
FROM 
    olist_orders_dataset o
JOIN
    olist_order_items_dataset i ON i.order_id = o.order_id
JOIN
    olist_products_dataset p ON p.product_id = i.product_id
WHERE
    p.product_category_name = 'pet_shop'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY
    p.product_category_name;
    
#4th KPI
USE olist_project;

SELECT
    ROUND(AVG(i.price)) AS average_price,
    ROUND(AVG(p.payment_value)) AS average_payment
FROM 
    olist_customers_dataset c
JOIN
    olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN
    olist_order_items_dataset i ON o.order_id = i.order_id
JOIN
    olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE
    c.customer_city = 'Sao Paulo';
    
#5th KPI
SELECT
    ROUND(AVG(DATEDIFF(
        STR_TO_DATE(o.order_delivered_customer_date, '%d-%m-%Y %H:%i:%s'),
        STR_TO_DATE(o.order_purchase_timestamp, '%d-%m-%Y %H:%i:%s')
    )), 0) AS avgshippingdays,
    r.review_score
FROM
    olist_orders_dataset o
JOIN
    olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE
    o.order_delivered_customer_date IS NOT NULL
    AND o.order_purchase_timestamp IS NOT NULL
GROUP BY
    r.review_score;

