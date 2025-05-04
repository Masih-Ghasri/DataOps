#!/bin/bash

KIBANA_URL="http://kibana:5601"
INDEX_PATTERN_NAME="test_pipeline"
TIME_FIELD="@timestamp"

echo "Waiting for Kibana to be ready..."
until curl -s -f "$KIBANA_URL/api/status" > /dev/null; do
    echo "Kibana is not ready yet, retrying in 5 seconds..."
    sleep 5
done
echo "Kibana is ready!"

echo "Creating Index Pattern: $INDEX_PATTERN_NAME"
curl -X POST "$KIBANA_URL/api/saved_objects/index-pattern/$INDEX_PATTERN_NAME" \
     -H "Content-Type: application/json" \
     -H "kbn-xsrf: true" \
     -d '{
           "attributes": {
             "title": "'"$INDEX_PATTERN_NAME"'",
             "timeFieldName": "'"$TIME_FIELD"'"
           }
         }'

echo "Index Pattern created successfully!"