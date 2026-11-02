-- Sprint 1 is business and data understanding
-- You read the company background and your role as a Data Analyst for the Operations team.
-- You studied the ER diagram: the 5 tables, their primary and foreign keys, and how they connect.
-- You planned in plain words how you would investigate each of the 10 business situations, 
-- covering the tables, columns, joins and flow.

-- Sprint - 2 
CREATE DATABASE  last_mile_delivery;
USE last_mile_delivery;


CREATE TABLE customers (
    customer_id         VARCHAR(20)  NOT NULL,
    customer_name       VARCHAR(100) NOT NULL,
    city                VARCHAR(50)  NOT NULL,
    delivery_zone_id    VARCHAR(10)  NOT NULL,
    preferred_time_slot VARCHAR(30)  NOT NULL DEFAULT 'Any',
    customer_type       VARCHAR(20)  NOT NULL,
    account_since       DATE         NOT NULL,
    PRIMARY KEY (customer_id),
    CONSTRAINT chk_customer_type CHECK (customer_type IN ('Business','Individual'))
);


CREATE TABLE drivers (
    driver_id       VARCHAR(10)  NOT NULL,
    driver_name     VARCHAR(100) NOT NULL,
    hire_date       DATE         NOT NULL,
    rating          DECIMAL(3,2) NOT NULL,
    employment_type VARCHAR(20)  NOT NULL,
    is_active       VARCHAR(3)   NOT NULL DEFAULT 'Yes',
    PRIMARY KEY (driver_id),
    CONSTRAINT chk_driver_active CHECK (is_active IN ('Yes','No'))
);



CREATE TABLE vehicles (
    vehicle_id        VARCHAR(10)  NOT NULL,
    vehicle_type      VARCHAR(30)  NOT NULL,
    fuel_type         VARCHAR(20)  NOT NULL,
    max_payload_kg    DECIMAL(8,2) NOT NULL,
    depot             VARCHAR(10)  NOT NULL,
    last_service_date DATE         NOT NULL,
    is_active         VARCHAR(3)   NOT NULL DEFAULT 'Yes',
    PRIMARY KEY (vehicle_id),
    CONSTRAINT chk_vehicle_active CHECK (is_active IN ('Yes','No'))
);


CREATE TABLE orders (
    order_id          VARCHAR(20)   NOT NULL,
    customer_id       VARCHAR(20)   NOT NULL,
    order_date        DATE          NOT NULL,
    delivery_zone_id  VARCHAR(10)   NOT NULL,
    package_weight_kg DECIMAL(8,2)  NOT NULL,
    service_type      VARCHAR(20)   NOT NULL,
    priority          VARCHAR(20)   NOT NULL DEFAULT 'Normal',
    total_value       DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


CREATE TABLE deliveries (
    delivery_id           VARCHAR(15)  NOT NULL,
    order_id              VARCHAR(20)  NOT NULL,
    driver_id             VARCHAR(10)  NOT NULL,
    vehicle_id            VARCHAR(10)  NOT NULL,
    assigned_date         DATE         NOT NULL,
    actual_delivery_date  DATE         NULL,
    status                VARCHAR(20)  NOT NULL,
    delivery_attempt      INT          NOT NULL DEFAULT 1,
    distance_km           DECIMAL(6,2) NOT NULL,
    delivery_duration_min INT          NOT NULL,
    PRIMARY KEY (delivery_id),
    CONSTRAINT fk_del_order   FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    CONSTRAINT fk_del_driver  FOREIGN KEY (driver_id)  REFERENCES drivers(driver_id),
    CONSTRAINT fk_del_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);










