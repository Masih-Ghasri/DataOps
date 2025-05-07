# Data Pipeline with Kafka, Logstash, Elasticsearch, and Kibana

This project implements a data pipeline that processes raw JSON data through Kafka and Logstash, storing it in Elasticsearch for visualization in Kibana.

## Project Structure

```
.
├── config
│   └── logstash.conf
├── docker-compose.yml
├── setup_kibana.sh
├── scripts
│   ├── data
│   │   └── data.json
│   └── producer.py
└── README.md
```

## Prerequisites

* Docker and Docker Compose installed on your system
* Python 3.x (for running the producer script)

## How to Run the Project

1. **Start the services**:
```bash
docker compose up -d
```

2. **Wait for all services to start up** (this may take a few minutes). You can check the status with:
```bash
docker compose logs -f
```

3. **Run the Python producer script** to send data to Kafka:
```bash
python scripts/producer.py
```

4. **Access Kibana** to view the processed data:
    * Open your browser and go to: `http://localhost:5601`
    * Navigate to "Discover" in the left menu
    * Select the "test_pipeline" index pattern

## Data Processing Details

The pipeline performs the following transformations:

1. **Data Type Conversions**:
    * Convert `id` from string to integer
    * Convert `active` from string to boolean
    * Empty `full_name` values are set to `null`

2. **Field Renaming and Removal**:
    * `full_name` is renamed to `name`
    * `extra_field` is completely removed

3. **Timestamp Standardization**:
    * Convert various time formats to ISO8601 format
    * Store in Elasticsearch as `@timestamp` field

## Expected Output

The processed data in Elasticsearch will look like this:

```json
[
  {"id": 123, "name": "Ali", "@timestamp": "2025-01-31T12:34:56Z", "active": true},
  {"id": 124, "name": null, "@timestamp": "2025-01-31T14:20:00Z", "active": false},
  {"id": 125, "name": "Sara", "@timestamp": "2025-02-01T09:15:30Z", "active": true}
]
```

## Verification Steps

1. Check that all 3 records appear in Kibana
2. Verify that:
    * All IDs are numbers (not strings)
    * Empty names are displayed as null
    * All timestamps are in ISO format
    * "extra_field" is not present
    * Active status is displayed as true/false (not string)

## Troubleshooting

If you encounter issues:

1. Check container logs: `docker-compose logs -f [service_name]`
2. Verify all containers are running: `docker-compose ps`
3. Make sure the producer script can connect to Kafka (check port 29092)
4. Check Elasticsearch indices: `curl http://localhost:9200/_cat/indices?v`

## Cleanup

To stop and remove all containers:

```bash
docker-compose down
```

## Implementation Notes

* The pipeline handles various date formats and converts them to standard ISO format
* Empty strings are properly converted to null values
* Setup includes automatic creation of Kibana index pattern
* Health checks ensure services start in the correct order
