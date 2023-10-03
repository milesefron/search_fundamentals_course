QUERIES_JSON_FILE="/workspace/search_fundamentals_course/week2/conf/bbuy_queries.json"
DATASETS_DIR="/workspace/datasets"
PYTHON_LOC="/workspace/search_fundamentals_course/week2"

LOGS_DIR="/workspace/logs"

mkdir $LOGS_DIR

echo " Query file: $QUERIES_JSON_FILE"
curl -k -X PUT -u admin  "https://localhost:9200/bbuy_queries" -H 'Content-Type: application/json' -d "@$QUERIES_JSON_FILE"
if [ $? -ne 0 ] ; then
  echo "Failed to create index with settings of $QUERIES_JSON_FILE"
  exit 2
fi

cd $PYTHON_LOC
  echo "Indexing queries data and writing logs to $LOGS_DIR/index_queries.log"
  nohup python index_queries.py -s "$DATASETS_DIR/train.csv" > "$LOGS_DIR/index_queries.log" &
  if [ $? -ne 0 ] ; then
    exit 2
  fi
