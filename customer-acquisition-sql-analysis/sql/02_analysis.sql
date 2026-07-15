/*
Customer Acquisition & Revenue Analysis — SQL Portfolio Project
Database: SQLite
Tool: DBeaver

/* =================================================================
0. Перевірка якості даних
Мета: розуміння таблиць, діапазону дат та основного обсягу даних.
================================================================= */

-- Клієнти та обсяг замовлень
SELECT 
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(DISTINCT user_id) FROM orders) AS customers_with_orders;

-- Діапазон дат замовлень та загальний дохід
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    ROUND(SUM(purchase_amount), 2) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value
FROM orders;


/* ===================================================================
1. Огляд бізнесу
Мета: розрахувати загальні бізнес-метрики. ================================================================= */

SELECT
    COUNT(DISTINCT user_id) AS active_customers,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(purchase_amount), 2) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value,
    ROUND(COUNT(order_id) * 1.0 / COUNT(DISTINCT user_id), 2) AS avg_orders_per_customer
FROM orders;


/* ===================================================================
2. Аналіз замовлень чоловіків по каналам залучень
Мета: розрахувати через яки канал було залучено найбільше чоловіків. ================================================================= */

select c.acquisition_channel,
COUNT(distinct o.user_id) as male_users,
COUNT (*) as male_orders,
ROUND(SUM(purchase_amount), 0) as male_revenue
from orders o
join customers c  on o.user_id=c.user_id
where c.gender = 'Male'
GROUP by acquisition_channel
order by male_revenue DESC;


/* ===================================================================
3. Аналіз мін, макс. та середнього чека по каналам залучення
Мета: розрахувати мінімальний, максимальний та середній чек по каналам залучення ================================================================= */

select acquisition_channel,
COUNT(*) as order_cnt,
MIN(o.purchase_amount) as min_check,
MAX(o.purchase_amount) as max_check,
round(AVG(o.purchase_amount), 2) as avg_check
from orders o
join customers c on o.user_id=c.user_id
GROUP by acquisition_channel
order by max_check DESC;

/* ===================================================================
4. Аналіз замовлень в розрізі населених пунктів
Мета: зробити вибірку в яких населених пунктах було найбільше замовлень, отриманий дохід та середній чек=========*/

Select c.city,
COUNT(*) as order_cnt,
SUM(purchase_amount) as revenue,
round(AVG(purchase_amount), 2) as AVG_check
from orders o
join customers c on o.user_id=c.user_id
GROUP by c.city
having revenue > 4000
order by revenue desc;


/* ===================================================================
5. Аналіз користувачів на найбільшу кількість замовлень
Мета: зробити вибірку користувачів які зробили більше 10 покупок, та суму отриманого доходу =========*/

Select c.user_id, 
concat(c.first_name,' ', c.last_name) as full_name,
count (o.order_id) as order_cnt,
Sum(o.purchase_amount) as total_check
from orders o
join customers c on o.user_id=c.user_id
Group by full_name
having COUNT(o.order_id) > 10
order by order_cnt desc
limit 5;

/* ===================================================================
6. Аналіз доходу отриманого з різних методів оплати
Мета: зробити аналіз методів оплати, кількість замовлень та отриманий дохід=========*/

select payment_method,
COUNT(*) as order_cnt,
round(Sum(o.purchase_amount), 0) as total_check,
round(AVG(o.purchase_amount), 0) as avg_check
from orders o
join customers c on o.user_id=c.user_id
GROUP by payment_method
order by order_cnt DESC;
