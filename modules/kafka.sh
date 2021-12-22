echo "Initializing module: kafka"

# Produce kafka messages from json file to given topic
# Param 1: topic
# Param 2: filename
function kafkaProduceFromJsonFile {
  echo -e "${BLUE}Producing kafka message from JSON file ${GREEN}$2$NC to topic ${MAGENTA}$1$NC"
  cat $2 | jq -c  | $DC exec -T kafka kafka-console-producer.sh --broker-list kafka:9092 --topic $1 > /dev/null
}

# Consume kafka topic and compare the result with given file
# Param 1: topic
# Param 2: fileneame
function kafkaCheckForMessages {
  echo -e "${BLUE}Consuming kafka topic ${MAGENTA}$1$NC and compare with file ${GREEN}$2$NC"
  diff -b <($DC exec -T kafka kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic $1 --from-beginning --timeout-ms 3000) $2
}

# Initialize kafka topic
# Param 1: topic
function kafkaInitTopic {
  echo -e "${BLUE}Initializing kafka topic ${MAGENTA}$1$NC"
  $DC exec -T kafka kafka-topics.sh --topic $1 --bootstrap-server kafka:9092 --delete --if-exists
  $DC exec -T kafka kafka-topics.sh --topic $1 --bootstrap-server kafka:9092 --create --if-not-exists --partitions 3 --replication-factor 1
}

# add compose file
export DC="$DC -f ${MODULES_DIR}/kafka.yml"

# pull images
$DC pull zookeeper kafka 2>&1 | silenceLogs

# start kafka and zookeeper
$DC up -d kafka
