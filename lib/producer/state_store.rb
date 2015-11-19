module Producer; end
require 'thread'

class Producer::StateStore
  include Celluloid
  include Celluloid::Internals::Logger

  attr_reader :queue, :producer

  def initialize(worker)
    @queue = Queue.new
    @producer = worker
    _load
  end

  def size
    queue.size
  end

  def push_and_send(item)
    _push item
    _send_messages
  end

  def to_json
    result = []
    while !queue.empty?
      msg = _pop
      result << msg if msg
    end
    result.empty? ? nil : result.to_json
  end

  def save
    data = to_json
    return unless data
    f = File.open($config["file-state-name"], "w")
    f.write data
  ensure
    f.close unless f.nil?
  end

  def _load
    return unless File.exist?($config["file-state-name"])
    begin
      f = File.open($config["file-state-name"], "r")
      data = JSON(f.read)
      data.each { |m| _push m }
      info "Into Queue loaded #{data.count} messages"
      File.delete($config["file-state-name"])
    rescue Exception => e
      error e.message
    ensure
      f.close
    end
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
