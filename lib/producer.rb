module Producer
  def self.produce_random
    # Generate msg
    msg = _generate_msg
    _produce_one(msg)
  end

private

  def self._produce_one(msg={})
    puts "Produce message: #{msg}"
  end

  def self._generate_msg
    {
      "source": "192.168.254.#{rand 1..4}",
      "time": Time.now.to_i,
      "barcode": "000#{(1..9).map {rand 9}.join}"
    }
  end
end
