echo "Initializing module: mySQL"

if [ -z ${KOMPOST_MODULE_MYSQL_ROOT_PASSWORD+x} ]; then    
    echo KOMPOST_MODULE_MYSQL_ROOT_PASSWORD not set, using "root"
    export KOMPOST_MODULE_MYSQL_ROOT_PASSWORD=root
fi

if [ -z ${KOMPOST_MODULE_MYSQL_DATABASE+x} ]; then    
    echo KOMPOST_MODULE_MYSQL_DATABASE not set, using "kompost"
    export KOMPOST_MODULE_MYSQL_DATABASE=kompost
fi

if [ -z ${KOMPOST_MODULE_MYSQL_USER+x} ]; then    
    echo KOMPOST_MODULE_MYSQL_USER not set, using "kompost"
    export KOMPOST_MODULE_MYSQL_USER=kompost
fi

if [ -z ${KOMPOST_MODULE_MYSQL_PASSWORD+x} ]; then    
    echo KOMPOST_MODULE_MYSQL_PASSWORD not set, using "kompost"
    export KOMPOST_MODULE_MYSQL_PASSWORD=kompost
fi

# add compose file
export DC="$DC -f ${MODULES_DIR}/mysql/docker-compose.yml"

# pull images
$DC pull mysql 2>&1 | silenceLogs

# start mysql
$DC up -d mysql 2>&1 | silenceLogs

# wait for startup of mysql
waitForHealthyContainer mysql
