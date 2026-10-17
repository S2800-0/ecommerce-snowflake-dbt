#!/usr/bin/env bash
# Loads a CSV file into a RAW table. COPY INTO appends, so loading a new orders file adds its rows.
#   scripts/load_raw.sh                       # the three starting files
#   scripts/load_raw.sh orders data/new_orders.csv   # one more file into RAW.ORDERS
# Needs the Snowflake CLI with a connection named by CONN (default: ecommerce).
set -euo pipefail
cd "$(dirname "$0")/.."
SNOW="${SNOW:-snow}"; CONN="${CONN:-ecommerce}"
run() { "$SNOW" sql -c "$CONN" -q "$1" >/dev/null; }

load() {  # table file
  local table="$1" file="$2" base upper; base="$(basename "$file")"; upper="$(echo "$table" | tr a-z A-Z)"
  run "PUT 'file://$PWD/$file' @ECOMMERCE_DB.RAW.RAW_STAGE AUTO_COMPRESS=TRUE OVERWRITE=TRUE"
  case "$table" in
    customers) cols="customer_id, customer_name, email, city, signup_date"; sel='$1,$2,$3,$4,$5';;
    products)  cols="product_id, product_name, category, price";            sel='$1,$2,$3,$4';;
    orders)    cols="order_id, customer_id, product_id, quantity, order_date, status"; sel='$1,$2,$3,$4,$5,$6';;
  esac
  run "COPY INTO ECOMMERCE_DB.RAW.${upper} ($cols, _source_file) FROM (SELECT $sel, METADATA\$FILENAME FROM @ECOMMERCE_DB.RAW.RAW_STAGE/${base}.gz) FILE_FORMAT = (FORMAT_NAME = ECOMMERCE_DB.RAW.RAW_CSV) FORCE = TRUE"
  echo "loaded $file into RAW.${upper}"
}

if [ "$#" -eq 2 ]; then
  load "$1" "$2"
else
  "$SNOW" sql -c "$CONN" -f sql/02_create_raw.sql >/dev/null
  # Start from empty tables, so running this again never loads the starting files twice
  for t in CUSTOMERS PRODUCTS ORDERS; do run "TRUNCATE TABLE ECOMMERCE_DB.RAW.$t"; done
  load customers data/customers.csv
  load products  data/products.csv
  load orders    data/orders.csv
fi
