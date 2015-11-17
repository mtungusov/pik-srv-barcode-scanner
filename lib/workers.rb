module Workers; end

class Workers::Producer
  include Celluloid
  include Celluloid::Internals::Logger

  finalizer :close_all

  def initialize
    info "Starting up..."
  end

  def process
    info "Processing..."
  end

  def shutdown
    info "Shuting down begin..."
    sleep 2.0
    info "Shuting complete!"
  end

  def close_all
    info "Finalize"
  end
end

# class Workers::BarcodeGroup < Celluloid::Supervision::Container
#   pool Producer, as: :producer_pool, size: 2
# end
