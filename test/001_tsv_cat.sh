#!/bin/bash

APP_DIR=$(dirname $(dirname $(realpath $0)))
PATH=$PATH:$APP_DIR

if diff <(tsv-cat test/demo-001.txt) test/demo-001.txt 2>&1 >/dev/null; then
	echo "OK"
else
	echo "Failed"
fi

if diff <(tsv-cat test/demo-002.csv) test/demo-001.txt 2>&1 >/dev/null; then
	echo "OK"
else
	echo "Failed"
fi
