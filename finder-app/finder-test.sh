#!/bin/sh
# tester script for assignment 1 and assignment 2 (fixed)
# ensures writer is built and uses script_dir-based paths for conf files

script_dir="$(cd "$(dirname "$0")" && pwd)"

# Tester script for assignment 1 and assignment 2
# Author: fixed for Nishal

set -e
set -u

NUMFILES=10
WRITESTR=AELD_IS_FUN
WRITEDIR=/tmp/aeld-data

# read username from repo conf (script_dir is the finder-app dir)
username="$(cat "$script_dir/../conf/username.txt")"

# ensure native writer is built for the test harness
( cd "$script_dir" && make ) || { echo "native build failed"; exit 1; }

if [ $# -lt 3 ]
then
    echo "Using default value ${WRITESTR} for string to write"
    if [ $# -lt 1 ]
    then
        echo "Using default value ${NUMFILES} for number of files to write"
    else
        NUMFILES=$1
    fi
else
    NUMFILES=$1
    WRITESTR=$2
    WRITEDIR=/tmp/aeld-data/$3
fi

MATCHSTR="The number of files are ${NUMFILES} and the number of matching lines are ${NUMFILES}"

echo "Writing ${NUMFILES} files containing string ${WRITESTR} to ${WRITEDIR}"

rm -rf "${WRITEDIR}"

# read assignment type from repo conf
assignment="$(cat "$script_dir/../conf/assignment.txt")"

if [ "${assignment}" != "assignment1" ]
then
    mkdir -p "$WRITEDIR"
    if [ -d "$WRITEDIR" ]
    then
        echo "$WRITEDIR created"
    else
        echo "Failed to create ${WRITEDIR}" >&2
        exit 1
    fi
fi

# create files using the writer shim located in the same directory as this script
i=1
while [ $i -le "$NUMFILES" ]; do
    "$script_dir/writer.sh" "$WRITEDIR/${username}$i.txt" "$WRITESTR"
    i=$((i+1))
done

# run finder.sh (shim) from the script dir and capture its output
OUTPUTSTRING="$("$script_dir/finder.sh" "$WRITEDIR" "$WRITESTR")"

# remove temporary directories
rm -rf /tmp/aeld-data

set +e
echo "${OUTPUTSTRING}" | grep "${MATCHSTR}" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "success"
    exit 0
else
    echo "failed: expected  ${MATCHSTR} in ${OUTPUTSTRING} but instead found"
    exit 1
fi
