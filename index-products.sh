usage()
{
  echo "Usage: $0 [-y /path/to/python/indexing/code] [-d /path/to/kaggle/best/buy/datasets] [-p /path/to/bbuy/products/field/mappings] [ -g /path/to/write/logs/to ]"
  echo "Example: ./index-data.sh  -y /Users/grantingersoll/projects/corise/search_fundamentals_instructor/src/main/python/search_fundamentals/week1_finished   -d /Users/grantingersoll/projects/corise/datasets/bbuy -p /Users/grantingersoll/projects/corise/search_fundamentals_instructor/src/main/opensearch/bbuy_products.json -g /tmp"
  exit 2
}

PRODUCTS_JSON_FILE="/workspace/search_fundamentals_course/opensearch/bbuy_products.json"
DATASETS_DIR="/workspace/datasets"
PYTHON_LOC="/workspace/search_fundamentals_course/week1"

LOGS_DIR="/workspace/logs"

while getopts ':p:g:y:d:h' c
do
  case $c in
    p) PRODUCTS_JSON_FILE=$OPTARG ;;
    d) DATASETS_DIR=$OPTARG ;;
    g) LOGS_DIR=$OPTARG ;;
    y) PYTHON_LOC=$OPTARG ;;
    h) usage ;;
    [?]) usage ;;
  esac
done
shift $((OPTIND -1))

mkdir $LOGS_DIR

echo "Creating index settings and mappings"
echo " Product file: $PRODUCTS_JSON_FILE"
curl -k -X PUT -u admin  "https://localhost:9200/bbuy_products" -H 'Content-Type: application/json' -d "@$PRODUCTS_JSON_FILE"
if [ $? -ne 0 ] ; then
  echo "Failed to create index with settings of $PRODUCTS_JSON_FILE"
  exit 2
fi
echo ""

cd $PYTHON_LOC
echo ""
echo "Indexing product data in $DATASETS_DIR/product_data/products and writing logs to $LOGS_DIR/index_products.log"
  nohup python index_products.py -s "$DATASETS_DIR/product_data/products" > "$LOGS_DIR/index_products.log" &
  if [ $? -ne 0 ] ; then
    echo "Failed to index products"
    exit 2
  fi
