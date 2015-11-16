# Commands

```
cd $KAFKA_HOME
```

```
./bin/kafka-topics.sh --zookeeper kafka.dev:2181 --list
```

```
./bin/kafka-topics.sh --zookeeper kafka.dev:2181 --create --replication-factor 1 --partitions 1 --topic dev-barcode-scanner
```

```
./bin/kafka-console-consumer.sh --zookeeper kafka.dev:2181 --topic dev-barcode-scanner --from-beginning
```

```
./bin/kafka-console-producer.sh --broker-list kafka.dev:9092 --topic dev-barcode-scanner
```

```
{"source":"192.168.254.4", "time":1447327450, "barcode":"000765685830"}
{"source":"192.168.254.2", "time":1447327451, "barcode":"000765685831"}
{"source":"192.168.254.3", "time":1447327453, "barcode":"000765685833"}
{"source":"192.168.254.4", "time":1447327454, "barcode":"000765685834"}
{"source":"192.168.254.2", "time":1447327455, "barcode":"000765685835"}
```
