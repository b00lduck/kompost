echo "Initializing module: postgreSQL"

if [ -z ${KOMPOST_MODULE_POSTGRES_DATABASE+x} ]; then    
    echo KOMPOST_MODULE_POSTGRES_DATABASE not set, using "kompost"
    export KOMPOST_MODULE_POSTGRES_DATABASE=kompost
fi

if [ -z ${KOMPOST_MODULE_POSTGRES_USER+x} ]; then    
    echo KOMPOST_MODULE_POSTGRES_USER not set, using "kompost"
    export KOMPOST_MODULE_POSTGRES_USER=kompost
fi

if [ -z ${KOMPOST_MODULE_POSTGRES_PASSWORD+x} ]; then    
    echo KOMPOST_MODULE_POSTGRES_PASSWORD not set, using "kompost"
    export KOMPOST_MODULE_POSTGRES_PASSWORD=kompost
fi

# add compose file
export DC="$DC -f ${MODULES_DIR}/postgres/docker-compose.yml"

# pull images
$DC pull postgres 2>&1 | silenceLogs

# start mysql
$DC up -d postgres 2>&1 | silenceLogs

# wait for startup of postgres
waitForHealthyContainer postgres
