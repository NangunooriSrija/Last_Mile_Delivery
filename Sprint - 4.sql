-- Sprint - 4 
use last_mile_delivery;

-- 4.1 understand delivery demand
-- orders per zone
select delivery_zone_id, count(*) as total_orders
from orders
group by delivery_zone_id
order by total_orders desc;

-- top 5 zones by orders
select delivery_zone_id, count(*) as total_orders
from orders
group by delivery_zone_id
order by total_orders desc
limit 5;

-- orders per service type
select service_type, count(*) as total_orders
from orders
group by service_type
order by total_orders desc;

-- orders per priority
select priority, count(*) as total_orders
from orders
group by priority
order by total_orders desc;

-- orders per year
select year(order_date) as order_year, count(*) as total_orders
from orders
group by year(order_date)
order by order_year;

-- orders per month
select year(order_date) as order_year, month(order_date) as order_month, count(*) as total_orders
from orders
group by year(order_date), month(order_date)
order by order_year, order_month;

-- total and average value per service type
select service_type,
       round(sum(total_value), 2) as total_value,
       round(avg(total_value), 2) as avg_value
from orders
group by service_type
order by total_value desc;

-- total and average value per zone
select delivery_zone_id,
       round(sum(total_value), 2) as total_value,
       round(avg(total_value), 2) as avg_value
from orders
group by delivery_zone_id
order by total_value desc;

-- total and average value per priority
select priority,
       round(sum(total_value), 2) as total_value,
       round(avg(total_value), 2) as avg_value
from orders
group by priority
order by total_value desc;

-- 4.2 understand customer order behaviour
-- orders per customer (top 10)
select customer_id, count(*) as total_orders
from orders
group by customer_id
order by total_orders desc
limit 10;

-- top 10 customers by total order value
select customer_id, round(sum(total_value), 2) as total_value
from orders
group by customer_id
order by total_value desc
limit 10;

-- customers with more than 8 orders
select customer_id, count(*) as total_orders
from orders
group by customer_id
having count(*) > 8
order by total_orders desc;

-- business vs individual
select c.customer_type,
       count(distinct c.customer_id) as customers,
       count(o.order_id) as total_orders,
       round(sum(o.total_value), 2) as total_value,
       round(avg(o.total_value), 2) as avg_order_value
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_type;

-- customers per zone
select delivery_zone_id, count(*) as total_customers
from customers
group by delivery_zone_id
order by total_customers desc;

-- orders per customer type per year
select year(o.order_date) as order_year, c.customer_type, count(*) as total_orders
from customers c
join orders o on c.customer_id = o.customer_id
group by year(o.order_date), c.customer_type
order by order_year, c.customer_type;



-- 4.3 evaluate delivery performance
-- deliveries by status
select status, count(*) as total_deliveries
from deliveries
group by status
order by total_deliveries desc;

-- average, shortest and longest duration
select round(avg(delivery_duration_min), 2) as avg_min,
       min(delivery_duration_min) as min_min,
       max(delivery_duration_min) as max_min
from deliveries;

-- deliveries and average duration per zone
select o.delivery_zone_id,
       count(*) as total_deliveries,
       round(avg(d.delivery_duration_min), 2) as avg_duration_min
from deliveries d
join orders o on d.order_id = o.order_id
group by o.delivery_zone_id
order by total_deliveries desc;

-- status by zone
select o.delivery_zone_id, d.status, count(*) as total_deliveries
from deliveries d
join orders o on d.order_id = o.order_id
group by o.delivery_zone_id, d.status
order by o.delivery_zone_id, total_deliveries desc;

-- zones with the most failed deliveries
select o.delivery_zone_id, count(*) as failed_deliveries
from deliveries d
join orders o on d.order_id = o.order_id
where d.status = 'Failed'
group by o.delivery_zone_id
order by failed_deliveries desc
limit 5;

-- deliveries per year and status
select year(assigned_date) as yr, status, count(*) as total_deliveries
from deliveries
group by year(assigned_date), status
order by yr, total_deliveries desc;


-- 4.4 understand driver and vehicle performance
-- deliveries per driver (top 10)
select d.driver_id, dr.driver_name, count(*) as total_deliveries
from deliveries d
join drivers dr on d.driver_id = dr.driver_id
group by d.driver_id, dr.driver_name
order by total_deliveries desc
limit 10;

-- delivered vs failed per driver
select driver_id,
       sum(status = 'Delivered') as delivered,
       sum(status = 'Failed') as failed,
       count(*) as total
from deliveries
group by driver_id
order by failed desc
limit 10;

-- average duration per driver (slowest 10)
select driver_id, round(avg(delivery_duration_min), 2) as avg_duration_min
from deliveries
group by driver_id
order by avg_duration_min desc
limit 10;

-- deliveries and duration by employment type
select dr.employment_type,
       count(*) as total_deliveries,
       round(avg(d.delivery_duration_min), 2) as avg_duration_min
from deliveries d
join drivers dr on d.driver_id = dr.driver_id
group by dr.employment_type;

-- deliveries per vehicle type
select v.vehicle_type,
       count(*) as total_deliveries,
       round(avg(d.distance_km), 2) as avg_distance_km,
       round(avg(d.delivery_duration_min), 2) as avg_duration_min
from deliveries d
join vehicles v on d.vehicle_id = v.vehicle_id
group by v.vehicle_type
order by total_deliveries desc;

-- status by vehicle type
select v.vehicle_type, d.status, count(*) as total_deliveries
from deliveries d
join vehicles v on d.vehicle_id = v.vehicle_id
group by v.vehicle_type, d.status
order by v.vehicle_type, total_deliveries desc;


-- 4.5 identify delivery problems
-- deliveries by attempt number
select delivery_attempt, count(*) as total_deliveries
from deliveries
group by delivery_attempt
order by delivery_attempt;

-- status of deliveries with more than one attempt
select status, count(*) as total_deliveries
from deliveries
where delivery_attempt > 1
group by status
order by total_deliveries desc;

-- duration and distance by attempt number
select delivery_attempt,
       round(avg(delivery_duration_min), 2) as avg_duration_min,
       round(avg(distance_km), 2) as avg_distance_km
from deliveries
group by delivery_attempt;

-- orders with more than one delivery record
select order_id, count(*) as delivery_records
from deliveries
group by order_id
having count(*) > 1
order by delivery_records desc
limit 10;

-- problem deliveries (failed, pending, rescheduled) per zone
select o.delivery_zone_id, count(*) as problem_deliveries
from deliveries d
join orders o on d.order_id = o.order_id
where d.status <> 'Delivered'
group by o.delivery_zone_id
order by problem_deliveries desc
limit 5;


