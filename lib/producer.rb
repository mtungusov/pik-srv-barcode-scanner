module Producer
  require_relative 'producer/java_producer'

  include Producer::JavaProducer

  module_function

  def produce_random
    # Generate msg
    msg = _generate_msg
    _produce_one(msg)
  end


  def _produce_one(msg={})
    JavaProducer::create
    puts "Produce message: #{msg}"
  end

  def _generate_msg
    {
      "source": "192.168.254.#{rand 1..4}",
      "time": Time.now.to_i,
      "barcode": "000#{(1..9).map {rand 9}.join}"
    }
  end
end
