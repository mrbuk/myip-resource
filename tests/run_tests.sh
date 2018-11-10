#!/bin/bash

set -e

SCRIPT_DIR=$(dirname "$0")
TMPDIR=$(mktemp -d)

export TMPDIR

# check
cp "$SCRIPT_DIR/data/myip-resource-request_empty" "$TMPDIR/myip-resource-request"
result=$(bash -x "$SCRIPT_DIR/../assets/check" 3>1 | jq -n '. | length')
if [ "$result" != "1" ]; then
    echo "Empty request: FAILED"
    exit 1    
else
    echo "Empty request: SUCCESS"
fi

# data/myip-resource-requesti
# data/myip-resource-request_change
