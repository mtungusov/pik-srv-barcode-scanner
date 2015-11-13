module Producer::JavaProducer
  # java_import org.apache.avro.Schema;
  # java_import org.apache.avro.generic.GenericData;
  # java_import org.apache.avro.generic.GenericRecord;
  # java_import org.apache.kafka.clients.producer.KafkaProducer;
  # java_import org.apache.kafka.clients.producer.Producer;
  # java_import org.apache.kafka.clients.producer.ProducerRecord;

  # java_import java.util.Date;
  # java_import java.util.Properties;
  # java_import java.util.Random;


  module_function

  def create
    puts 'create new producer'
    # binding.pry
  end
end
