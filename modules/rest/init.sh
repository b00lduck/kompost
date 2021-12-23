echo "Initializing module: rest"

# Compare the returned body of curl call with a given file
# Parameter 1: URL
# Parameter 2: expected file
#function compareCurlResultWithFile {
#  echo -e "${BLUE}Comparing requested HTTP call $NC$MAGENTA$1$NC against $GREEN$2$NC"
#  diff -b <($DC run curl -f $1 | jq) <(cat $2 | jq)
#}

# Parameter 1: URL
# Parameter 2: expected status code (i.e. 200)
function restGetCheckStatus {
  echo -e "${BLUE}Checking HTTP status code of $NC$MAGENTA$1$NC to be $GREEN$2$NC"
  STATUS=$($DC run --rm curl -sS -I -X GET $1 | head -n 1 | cut -d$' ' -f2)
  diff <(echo $STATUS) <(echo $2)
}

# add compose file
export DC="$DC -f ${MODULES_DIR}/rest/docker-compose.yml"    

# pull images
$DC pull curl 2>&1 | silenceLogs