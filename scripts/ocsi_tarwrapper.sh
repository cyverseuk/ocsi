#!/bin/bash
set -e -x

cp /analysis_crash/WhyDidTheAnalysisCrash.txt .

echo "${@:1}"
#run thing
which python
ls -lh /scripts/
python -c 'print "hello"'
python2.7-dbg /scripts/ocsi2.py "${@:1}"
python /scripts/ocsi2.py "${@:1}"

#wrap up output and kick out tempfile
tar -rf FullOutput.tar *
rm WhyDidTheAnalysisCrash.txt
