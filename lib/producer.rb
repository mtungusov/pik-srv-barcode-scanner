module Producer
  module_function

  def generate_random_msg
    {
      source:  "192.168.254.#{rand 1..4}",
      time:    Time.now.to_i,
      barcode: "000#{(1..9).map {rand 9}.join}"
    }
  end
end
