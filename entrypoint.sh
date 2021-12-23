#!/bin/bash

if [ -z ${KOMPOST_SUBJECT_NAME+x} ]; then
    echo Please set KOMPOST_SUBJECT_NAME
    exit 1
fi

if [ -z ${KOMPOST_SUBJECT_IMAGE+x} ]; then
    echo Please set KOMPOST_SUBJECT_IMAGE
    exit 1
fi

export MODULES_DIR="${PWD}/modules"

# Configure docker-compose project name and add main compose file
export COMPOSE_PROJECT_NAME="kompost-${KOMPOST_SUBJECT_NAME}"
export DC="docker-compose -f ${MODULES_DIR}/docker-compose.yml"
echo Using docker-compose project name: $COMPOSE_PROJECT_NAME

# include modules
source modules/main.sh
source modules/results.sh

# REST module
if [[ -v KOMPOST_MODULE_REST_ENABLED ]]; then
    source modules/rest/init.sh
fi

# Kafka module
if [[ -v KOMPOST_MODULE_KAFKA_ENABLED ]]; then
    source modules/kafka/init.sh
fi

# mySQL module
if [[ -v KOMPOST_MODULE_MYSQL_ENABLED ]]; then
    source modules/mysql/init.sh
fi

# postgres module
if [[ -v KOMPOST_MODULE_POSTGRES_ENABLED ]]; then
    source modules/postgres/init.sh
fi

# cleanup
$DC down -v 2>&1 | silenceLogs

# start the test subject
startSubject

# run user defined test cases
source testcases/runTests.sh

# show results and exit
exitSuccess