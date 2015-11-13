# Commands

./bin/kafka-topics --zookeeper localhost:2181 --create --replication-factor 1 --partitions 1 --topic _schemas

./bin/kafka-topics --zookeeper localhost:2181 --create --replication-factor 1 --partitions 1 --topic dev-barcode-scanner


./bin/kafka-avro-console-consumer --zookeeper localhost:2181 \
  --from-beginning \
  --topic dev-barcode-scanner

./bin/kafka-avro-console-producer \
  --broker-list localhost:9092 \
  --topic dev-barcode-scanner \
  --property value.schema='{"namespace": "barcode.pik-industry.ru", "name": "BarcodeScannerEvent", "type": "record", "doc": "This event from barcode scanner", "fields":  [{"name": "source", "type": "string", "doc": "Scanner ip address"}, {"name": "time", "type": "int", "doc": "Unixtime in seconds"}, {"name": "barcode", "type": "string", "doc": "Barcode from scanner"}]}'




{"source":"192.168.254.4", "time":1447327450, "barcode":"000765685830"}
{"source":"192.168.254.2", "time":1447327451, "barcode":"000765685831"}
{"source":"192.168.254.3", "time":1447327453, "barcode":"000765685833"}
{"source":"192.168.254.4", "time":1447327454, "barcode":"000765685834"}
{"source":"192.168.254.2", "time":1447327455, "barcode":"000765685835"}

