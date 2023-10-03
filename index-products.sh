

PRODUCTS_JSON_FILE="/workspace/search_fundamentals_course/week2/conf/bbuy_products.json"
DATASETS_DIR="/workspace/datasets"
PYTHON_LOC="/workspace/search_fundamentals_course/week2"

LOGS_DIR="/workspace/logs"


echo "Creating index settings and mappings"
echo " Product file: $PRODUCTS_JSON_FILE"
curl -k -X PUT -u admin  "https://localhost:9200/bbuy_products" -H 'Content-Type: application/json' -d "@$PRODUCTS_JSON_FILE"
if [ $? -ne 0 ] ; then
  echo "Failed to create index with settings of $PRODUCTS_JSON_FILE"
  exit 2
fi


cd $PYTHON_LOC
echo ""
  echo "Indexing product data in $DATASETS_DIR/product_data/products and writing logs to $LOGS_DIR/index_products.log"
  nohup python index_products.py -s "$DATASETS_DIR/product_data/products" > "$LOGS_DIR/index_products.log" &
  if [ $? -ne 0 ] ; then
    echo "Failed to index products"
    exit 2
  fi
