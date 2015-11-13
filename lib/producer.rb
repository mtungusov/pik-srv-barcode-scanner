module Producer
  # require_relative 'producer/java_producer'
  require_relative 'producer/kafka_producer'

  # include Producer::JavaProducer

  module_function

  def produce_random
    # Generate msg
    msg = _generate_msg
    _produce_one(msg)
  end


  def _produce_one(msg={})
    scheme = _message_schema
    m = _generate_msg
    k = m[:barcode]

    producer = KafkaProducer.new
    producer.connect
    puts 'producer connect'
    producer.send_message($config['kafka']['topic'], k, m, scheme)
    # Pry.config.input = STDIN
    # Pry.config.output = STDOUT
    # binding.pry

    puts 'producer sent'
    # producer.close
    puts 'producer close'
  end

  def _generate_msg
    {
      source:  "192.168.254.#{rand 1..4}",
      time:    Time.now.to_i,
      barcode: "000#{(1..9).map {rand 9}.join}"
    }
  end

  def _message_schema
    {
      "namespace":"barcode.pik-industry.ru",
      "name":"BarcodeScannerEvent",
      "type":"record",
      "doc":"This event from barcode scanner",
      "fields": [
        {"name":"source",  "type":"string", "doc":"Scanner ip address"},
        {"name":"time",    "type":"int",    "doc":"Unixtime in seconds"},
        {"name":"barcode", "type":"string", "doc":"Barcode from scanner"}
      ]
    }
  end
end
