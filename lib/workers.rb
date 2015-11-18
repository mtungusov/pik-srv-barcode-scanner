require 'producer'

module Workers; end

class Workers::Producer
  include Celluloid
  include Celluloid::Internals::Logger

  attr_reader :producer

  finalizer :close_all

  def initialize
    info "Starting up..."
    @producer = Producer.open
  end

  def process_random
    Producer.produce_random(producer)
  end

  def shutdown
    info "Shuting down begin..."
    producer.close
    sleep 2.0
    info "Shuting complete!"
  end

  def close_all
    producer.close
    info "Finalize"
  end
end

# class Workers::BarcodeGroup < Celluloid::Supervision::Container
#   pool Producer, as: :producer_pool, size: 2
# end
