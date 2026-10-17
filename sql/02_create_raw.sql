-- Task 1: the RAW tables. Every column is text, exactly as it appears in the file.
-- Types are converted later, in the dbt staging models. Blank values load as NULL.
USE ROLE DBT_ROLE;
USE WAREHOUSE ECOMMERCE_WH;
USE SCHEMA ECOMMERCE_DB.RAW;

CREATE FILE FORMAT IF NOT EXISTS RAW_CSV
  TYPE = CSV
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('')
  EMPTY_FIELD_AS_NULL = TRUE;

CREATE STAGE IF NOT EXISTS RAW_STAGE FILE_FORMAT = RAW_CSV;

CREATE TABLE IF NOT EXISTS CUSTOMERS (
  customer_id VARCHAR, customer_name VARCHAR, email VARCHAR, city VARCHAR, signup_date VARCHAR,
  _source_file VARCHAR, _loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP());

CREATE TABLE IF NOT EXISTS PRODUCTS (
  product_id VARCHAR, product_name VARCHAR, category VARCHAR, price VARCHAR,
  _source_file VARCHAR, _loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP());

CREATE TABLE IF NOT EXISTS ORDERS (
  order_id VARCHAR, customer_id VARCHAR, product_id VARCHAR, quantity VARCHAR, order_date VARCHAR, status VARCHAR,
  _source_file VARCHAR, _loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP());
