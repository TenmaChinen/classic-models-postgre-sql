DROP DATABASE IF EXISTS classic_models;
CREATE DATABASE classic_models
WITH OWNER=DEFAULT;
\c classic_models

-- DROP TABLE IF EXISTS offices;

CREATE TABLE offices (
  office_code VARCHAR(10) NOT NULL PRIMARY KEY,
  city VARCHAR(50) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  address_line_1 VARCHAR(50) NOT NULL,
  address_line_2 VARCHAR(50) DEFAULT NULL,
  state VARCHAR(50) DEFAULT NULL,
  country VARCHAR(50) NOT NULL,
  postal_code VARCHAR(15) NOT NULL,
  territory VARCHAR(10) NOT NULL
);

-- DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
  employee_number SERIAL PRIMARY KEY,
  last_name VARCHAR(50) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  extension VARCHAR(10) NOT NULL,
  email VARCHAR(100) NOT NULL,
  job_title VARCHAR(50) NOT NULL,
  office_code VARCHAR(10) NOT NULL REFERENCES offices(office_code) ON DELETE CASCADE,
  reports_to INTEGER DEFAULT NULL REFERENCES employees(employee_number) ON DELETE CASCADE
);

-- DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  customer_number SERIAL PRIMARY KEY,
  customer_name VARCHAR(50) NOT NULL,
  contact_last_name VARCHAR(50) NOT NULL,
  contact_first_name VARCHAR(50) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  address_line_1 VARCHAR(50) NOT NULL,
  address_line_2 VARCHAR(50) DEFAULT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) DEFAULT NULL,
  postal_code VARCHAR(15) DEFAULT NULL,
  country VARCHAR(50) NOT NULL,
  credit_limit DOUBLE PRECISION DEFAULT NULL,
  sales_rep_employee_number INTEGER DEFAULT NULL REFERENCES employees(employee_number) ON DELETE CASCADE
);

-- DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  order_number SERIAL PRIMARY KEY,
  order_date DATE NOT NULL,
  required_date DATE NOT NULL,
  shipped_date DATE DEFAULT NULL,
  status VARCHAR(15) NOT NULL,
  comments TEXT,
  customer_number INTEGER NOT NULL REFERENCES customers(customer_number) ON DELETE CASCADE
);

-- DROP TABLE IF EXISTS payments;

CREATE TABLE payments (
  customer_number INTEGER NOT NULL REFERENCES customers(customer_number) ON DELETE CASCADE,
  check_number VARCHAR(50) NOT NULL,
  payment_date DATE NOT NULL,
  amount DOUBLE PRECISION NOT NULL,
  PRIMARY KEY  (customer_number,check_number)
);

-- DROP TABLE IF EXISTS product_lines;

CREATE TABLE product_lines (
  product_line VARCHAR(50) PRIMARY KEY,
  text_description VARCHAR(4000) DEFAULT NULL,
  html_description TEXT,
  image BYTEA
);

-- DROP TABLE IF EXISTS products;

CREATE TABLE products (
  product_code VARCHAR(15) PRIMARY KEY,
  product_name VARCHAR(70) NOT NULL,
  product_line VARCHAR(50) NOT NULL REFERENCES product_lines(product_line),
  product_scale VARCHAR(10) NOT NULL,
  product_vendor VARCHAR(50) NOT NULL,
  product_description TEXT NOT NULL,
  quantity_in_stock SMALLINT NOT NULL,
  buy_price DOUBLE PRECISION NOT NULL,
  msrp DOUBLE PRECISION NOT NULL
);

-- DROP TABLE IF EXISTS order_details;

CREATE TABLE order_details (
  order_number SERIAL NOT NULL REFERENCES orders(order_number) ON DELETE CASCADE,
  product_code VARCHAR(15) NOT NULL REFERENCES products(product_code) ON DELETE CASCADE,
  quantity_ordered INTEGER NOT NULL,
  price_each DOUBLE PRECISION NOT NULL,
  order_line_Number SMALLINT NOT NULL,
  PRIMARY KEY (order_number,product_code)
);

DELETE FROM offices;
DELETE FROM employees;
DELETE FROM customers;
DELETE FROM orders;
DELETE FROM products;
DELETE FROM order_details;
DELETE FROM product_lines;

\COPY offices(office_code,city,phone,address_line_1,address_line_2,state,country,postal_code,territory) FROM './csv/offices.csv' DELIMITER ',' NULL AS 'null' CSV HEADER;
\COPY employees(employee_number,last_name,first_name,extension,email,office_code,reports_to,job_title) FROM './csv/employees.csv' DELIMITER ',' NULL AS 'null' CSV HEADER;
\COPY customers(customer_number,customer_name,contact_last_name,contact_first_name,phone,address_line_1,address_line_2,city,state,postal_code,country,sales_rep_employee_number,credit_limit) FROM './csv/customers.csv' DELIMITER ',' NULL AS 'null' CSV HEADER;
\COPY orders(order_number,order_date,required_date,shipped_date,status,comments,customer_number) FROM './csv/orders.csv' DELIMITER ',' NULL AS 'null' CSV HEADER;
\COPY product_lines(product_line,text_description,html_description,image) FROM './csv/product_lines.csv' DELIMITER ',' NULL AS 'null' CSV HEADER;
\COPY products(product_code,product_name,product_line,product_scale,product_vendor,product_description,quantity_in_stock,buy_price,msrp) FROM './csv/products.csv' DELIMITER ',' NULL AS 'null' CSV HEADER;
\COPY order_details(order_number,product_code,quantity_ordered,price_each,order_line_Number) FROM './csv/order_details.csv' DELIMITER ',' NULL AS 'null' CSV HEADER;