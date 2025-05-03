from kafka import KafkaProducer
import json
import os
from time import sleep

# تنظیمات Producer برای اجرای دستی
producer = KafkaProducer(
    bootstrap_servers=['localhost:29092'],
    value_serializer=lambda x: json.dumps(x).encode('utf-8'),
    api_version=(2, 8, 1)
)

# مسیر فایل داده
data_file = os.path.join('scripts', 'data', 'data.json')

# خواندن و ارسال داده‌ها
try:
    with open(data_file, 'r') as f:
        data = json.load(f)

    for record in data:
        producer.send('test_pipeline', value=record)
        print(f"Sent: {record}")
        sleep(1)

    producer.flush()
    print("All messages sent successfully!")
except Exception as e:
    print(f"Error: {e}")
finally:
    producer.close()