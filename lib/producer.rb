module Producer
  def self.produce_random
    # Generate fields
    fields = {}
    _produce(fields)
  end

private

  def self._produce(fields={})
    puts "Produce message with fields: #{fields}"
  end
end
