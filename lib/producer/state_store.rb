module Producer; end
require 'thread'

class Producer::StateStore
  include Celluloid
  include Celluloid::Internals::Logger

  attr_reader :queue, :producer

  def initialize(worker)
    @queue = Queue.new
    @producer = worker
  end

  def size
    queue.size
  end

  def push_and_send(item)
    _push item
    _send_messages
  end

  def save

  end

  def _load

  end

  def _pop
    result = nil
    unless queue.empty?
      result = queue.pop rescue nil
    end
    result
  end

  def _push(item)
    queue << item
    info "Queue <<: #{item}"
  end

  def _send_messages
    err_send = 0
    while err_send.zero? && !queue.empty?
      msg = _pop
      err_send = Celluloid::Actor[producer].send_message(msg) if msg
    end
    unless err_send.zero?
      _push msg
      warn "Delayed messages: #{size}"
    end
  end
end
