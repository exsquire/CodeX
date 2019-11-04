#!/bin/bash
#Flush your user scratch directories from research cluster nodes - implemented on a SLURM scheduled cluster. 
while getopts p: option
do
  case "${option}"
  in
  p) PARTITION=${OPTARG};;
  esac
done

if [ -z $PARTITION ]; then
   echo "Must include partition name using -p" >&2
   exit 1
fi


#Pull all nodes from specified partition
for i in `sinfo | grep -w $PARTITION | sed 's/  */:/g' | cut -d : -f 8`;
do
        #Loop through nodes on partition, listing user directories and removing them
        for j in `scontrol show hostname $i`;
        do
            echo $j
            ssh $j ls -la /scratch/$USER rm -rf /scratch/$USER
        done
done
