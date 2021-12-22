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
export DC="docker-compose -f ${MODULES_DIR}/main.yml"
echo Using docker-compose project name: $COMPOSE_PROJECT_NAME

# include modules
source modules/main.sh
source modules/results.sh
source modules/common.sh


# REST module
if [ -n ${KOMPOST_MODULE_REST+x} ]; then
    source modules/rest.sh
    export DC="$DC -f ${MODULES_DIR}/rest.yml"    
    $DC pull curl 2>&1 | silenceLogs
fi

# Kafka module
if [ -n ${KOMPOST_MODULE_KAFKA+x} ]; then
    source modules/kafka.sh
    export DC="$DC -f ${MODULES_DIR}/kafka.yml"
    $DC pull zookeeper kafka 2>&1 | silenceLogs
    $DC up -d kafka
fi

echo $DC

# cleanup
$DC down -v 2>&1 | silenceLogs

# build test subject from source
# TODO: use image instead
$DC build subject 2>&1 | silenceLogs

startSubject

# run user defined test cases
source testcases/runTests.sh

# show results
exitSuccess