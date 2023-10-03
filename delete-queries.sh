# WARNING: this will silently delete both of your indexes
echo "Deleting queries"
curl -k -X DELETE -u admin  "https://localhost:9200/bbuy_queries"

