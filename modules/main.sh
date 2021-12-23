echo "Initializing module: main"

function startSubject {
  $DC up -d subject 2>&1 | silenceLogs
}

function stopSubject {
  $DC kill subject 2>&1 | silenceLogs
}

function removeSubject {
  $DC rm -f -v subject 2>&1 | silenceLogs
}

function resetSubject {
  echo "Resetting subject..."
  stopSubject
  removeSubject
  startSubject
}

function runTestCase {
  BASEPWD=$(pwd)
  echo "Running test case: $1"
  cd testcases/$1
  source runTest.sh
  cd $BASEPWD
}

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Monitor log output of container and wait for string
# Parameter 1: service name
# Parameter 2: string to search for
function waitForLogLine {
  FOO=${2//\"/\\\"}
  echo -e "${BLUE}Waiting for log entry ${NC}[$MAGENTA$1$NC] $GREEN$FOO$NC"
  ( timeout 60s $DC logs -f "$1" & ) | grep -q "$FOO"
}

# Wait for healthy container (container status health=healthy)
# Parameter 1: service name
function waitForHealthyContainer {
  RETRIES=30
  echo -n -e "Waiting for service $MAGENTA$1$NC to become healthy (timeout $GREEN$RETRIES$NC seconds)..."
  PID=$($DC ps -q $1)
  i=1
  while [ "$i" -ne 30 ] && ! [ $(docker inspect --format "{{.State.Health.Status}}" $PID | grep healthy) ]; do
    sleep 1
    i=$(( i + 1 ))
    echo -n "."
  done 
  if [[ $i -ge $RETRIES ]]; then
    echo -e Service $MAGENTA$1$NC did not become healthy within the timeout of $GREEN$RETRIES$NC seconds.
    exit 1
  else
    echo ok
  fi
}


function silenceLogs {
  [[ -z "$DEBUG" ]] || cat && cat >/dev/null
}

