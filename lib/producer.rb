module Producer
  require_relative 'producer/kafka_producer'

  module_function

  def open
    producer = KafkaProducer.new
    producer.connect
    $log.info 'producer connect'
    producer
  end

  def produce_random(producer)
    _produce_one(producer, _generate_random_msg)
  end

  def _produce_one(producer, msg={})
    producer.send_message($config['kafka']['topic'], msg)
    $log.info 'producer sent'
  end

  def _generate_random_msg
    {
      source:  "192.168.254.#{rand 1..4}",
      time:    Time.now.to_i,
      barcode: "000#{(1..9).map {rand 9}.join}"
    }
  end
end
