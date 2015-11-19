require 'producer'
require 'producer/kafka_producer'

module Workers; end

class Workers::Producer
  include Celluloid
  include Celluloid::Internals::Logger

  attr_reader :producer

  # finalizer :close_all

  def initialize
    info "Starting up..."
    @producer = Producer::KafkaProducer.new
    producer.connect
    $log.info "producer connect"
  end

  def process_random
    msg = Producer::generate_random_msg
    send_message(msg)
  end

  def send_message(message)
    r, e = producer.send_message($config['kafka']['topic'], message)
    if e
      error e[:error]
      return 1
    end
    info "producer sent: #{message}, offset: #{r.offset}"
    return 0
  end

  def shutdown
    info "Shuting down begin..."
    # producer.close
    sleep 2.0
    info "Shuting complete!"
  end

  # def close_all
  #   producer.close
  #   info "Finalize"
  # end

end

# class Workers::BarcodeGroup < Celluloid::Supervision::Container
#   pool Producer, as: :producer_pool, size: 2
# end
