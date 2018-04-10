#!/bin/bash

function debug {
  echo "creating debugging directory"
mkdir .debug
for word in ${rmthis}
  do
    if [[ "${word}" == *.sh ]] || [[ "${word}" == lib ]]
      then
        mv "${word}" .debug;
      fi
  done
}

rmthis=`ls`
echo ${rmthis}

ARGSU=" ${ocsi_framework} ${temperature} ${parental_set_depth} ${gibbs_chain_length} ${burn_in} ${wlh} "
INPUTSU=`echo "${csi_input}" ${orthologue_file} | sed -e 's/ /, /g'`
echo "Input file are " "${INPUTSU}"

CMDLINEARG="-i ${csi_input} -l ${orthologue_file} "

CMDLINEARG+="${ARGSU}"

echo ${CMDLINEARG};

chmod +x launch.sh

echo  universe                = docker >> lib/condorSubmitEdit.htc
echo docker_image            =  cyversewarwick/ocsi:latest >> lib/condorSubmitEdit.htc ######latest at 9th Apr 2018
echo executable               =  ./launch.sh >> lib/condorSubmitEdit.htc 
echo arguments                          = ${CMDLINEARG} >> lib/condorSubmitEdit.htc
echo transfer_input_files = ${INPUTSU}, launch.sh >> lib/condorSubmitEdit.htc
cat /mnt/data/apps/ocsi/lib/condorSubmit.htc >> lib/condorSubmitEdit.htc

less lib/condorSubmitEdit.htc

jobid=`condor_submit -batch-name ${PWD##*/} lib/condorSubmitEdit.htc`
jobid=`echo $jobid | sed -e 's/Sub.*uster //'`
jobid=`echo $jobid | sed -e 's/\.//'`

#echo $jobid

#echo going to monitor job $jobid
condor_tail -f $jobid

debug

exit 0
