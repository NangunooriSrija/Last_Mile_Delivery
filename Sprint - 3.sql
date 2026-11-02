-- Sprint - 3

use last_mile_delivery;

-- 1. total number of customers
select count(*) as total_customers from customers;

-- 2. total number of orders
select count(*) as total_orders from orders;

-- 3. total number of deliveries
select count(*) as total_deliveries from deliveries;

-- 4. different service types available
select distinct service_type from orders;

-- 5. number of currently active drivers
select count(*) as active_drivers from drivers where is_active = 'Yes';

-- 6. different vehicle types
select distinct vehicle_type from vehicles;

-- 7. total order value
select round(sum(total_value), 2) as total_order_value from orders;

-- 8. average package weight
select round(avg(package_weight_kg), 2) as avg_package_weight_kg from orders;