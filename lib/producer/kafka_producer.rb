Dir["vendor/kafka/*.jar"].each { |jar| require jar }

class Producer::KafkaProducer
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
    value.serializer
    serializer.class
  ]

  attr_reader :options, :producer, :send_method

  def initialize(producer_options={})
    @options = producer_options.dup
    @options['acks'] = '1'
    @options['retries'] = '0'
    @options['key.serializer'] = 'org.apache.kafka.common.serialization.StringSerializer'
    @options['value.serializer'] = 'org.apache.kafka.common.serialization.StringSerializer'
    @options['bootstrap.servers'] = $config['connection']['kafka']

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

  def send_message(topic, message)
    # Pry.config.input = STDIN
    # Pry.config.output = STDOUT
    # binding.pry

    key = message[:source]
    data = _create_data(message)
    r = ProducerRecord.new(topic, key, data)
    send_method.call(r)
  end

  def _create_data(message)
    message.to_json
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
