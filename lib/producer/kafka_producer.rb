Dir["vendor/java/avro-serializer/*.jar"].each { |jar| require jar }
Dir["vendor/java/confluent-common/*.jar"].each { |jar| require jar }
Dir["vendor/java/kafka/*.jar"].each { |jar| require jar }
Dir["vendor/java/rest-utils/*.jar"].each { |jar| require jar }
Dir["vendor/java/schema-registry/*.jar"].each { |jar| require jar }

class Producer::KafkaProducer
  java_import 'org.apache.avro.Schema'
  java_import 'org.apache.avro.generic.GenericData'
  java_import 'org.apache.avro.generic.GenericRecord'
  # java_import 'org.apache.kafka.clients.producer.KafkaProducer'
  # java_import 'org.apache.kafka.clients.producer.Producer'
  java_import 'org.apache.kafka.clients.producer.ProducerRecord'

  KAFKA_PRODUCER = Java::org.apache.kafka.clients.producer.KafkaProducer

  REQUIRED_OPTIONS = %w[
    bootstrap.servers
    key.serializer
  ]

  KNOWN_OPTIONS = %w[
    acks
    bootstrap.servers
    key.serializer
    retries
    schema.registry.url
    value.serializer
  ]

  attr_reader :options, :producer, :send_method

  def initialize(producer_options={})
    @options = producer_options.dup
    @options['acks'] = '1'
    # @options['retries'] = '0'
    @options['key.serializer'] = 'io.confluent.kafka.serializers.KafkaAvroSerializer'
    @options['value.serializer'] = 'io.confluent.kafka.serializers.KafkaAvroSerializer'
    @options['bootstrap.servers'] = $config['connection']['kafka']
    @options['schema.registry.url'] = $config['connection']['schema-registry']

    _validate_options
    @send_method = proc { throw StandardError.new 'Error: producer is not connected!' }
  end

  def connect
    @producer = KAFKA_PRODUCER.new(_create_config)
    @send_method = producer.java_method :send, [ProducerRecord]
  end

  def close
    producer.close
  end

  def send_message(topic, key, message, message_schema)
    data = _create_data(message, message_schema)
    r = ProducerRecord.new(topic, key, data)
    send_method.call(r)
    # producer.send(r)
  end

  def _create_data(message, message_schema)
    parser = Schema::Parser.new
    schema = parser.parse(message_schema.to_json)
    data = GenericData::Record.new(schema)
    message.each { |k, v| data.put(k.to_s, v) }
    data
  end

  def _validate_options
    err = []
    err << "Empty options" if options.empty?
    missing = REQUIRED_OPTIONS.reject { |o| options[o] }
    err << "Missing required: #{missing.join(', ')}" if missing.any?
    unknown = options.keys - KNOWN_OPTIONS
    err << "Unknown: #{unknown.join(', ')}" if unknown.any?
    fail StandardError.new "Errors: #{ err.join('; ') }" if err.any?
  end

  def _create_config
    properties = java.util.Properties.new
    options.each { |k, v| properties.put(k, v) }
    properties
  end
end
