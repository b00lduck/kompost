echo "Initializing module: results"

function exitFailure {
    echo "Tests failed"
    echo "Subject log:"
    $DC logs subject
    [[ -z {$DEBUG+x} ]] || $DC down 2>&1 | silenceLogs
    exit 1
}

function exitSuccess {
    $DC down 2>&1 | silenceLogs
    echo "Tests successful"
}

trap 'exitFailure' ERR
set -eE
set -o pipefail