#Build ~/.bashrc custom aliases for cluster use
#Copy Paste into .bashrc
#TO ACTIVATE MANUALLY  > source ~/.bashrc
##########BASHBOARD##########
#Aliases
#Bashboard controls - edit and refresh 
alias editBB='vi ~/.bashrc'
alias refreshBB='source ~/.bashrc'

#Protective functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias chmod='chmod -v'

#Updating job queue
alias jobs='squeue -u $USER -i10'
#See cluster traffic
alias traffic='sinfo --Node --long --sort=PARTITION'
#cat last file in list
alias catLast='cat "$(ls -rt | tail -n1)"'
#Count files in directory
alias countFiles='ls -1 | wc -l'
#Check sh symlink
alias checkShell='file -h /bin/sh'

#Utility functions#############
#Grep your history log for specific commands
alias gh='history|grep'
alias yank='cd $flag'


#FARM-specific
#Quick R roll ups
alias ptyR='srun --mem=60000 --time=24:00:00 --partition=high --pty R'
#Quick Dash roll ups
alias ptyBash='srun --mem=60000 --time=24:00:00 --partition=high --pty bash'

##CERES-specific
#Show cluster configuration settings
alias configs='scontrol show config'
#Show the account QOS limitations on the cluster
alias limits='sacctmgr -p list qos $@ format=Name,Priority,GraceTime,GrpTRES,GrpJobs,GrpSubmit,GrpSubmit,MaxTRES,MaxTRESPerUser,MaxJobsPU | column -ts"|"'
#Show the limits on your own account
alias mylimits='sacctmgr list associations format=Account,User,Partition,qos'
#Show specs on last jobs ran - job history usually 24hr but depends on cluster
alias specs='sacct --format="JobName%30, JobID, Start, Partition, NCPUS, MaxRSS,MaxDiskWrite, Elapsed, STATE" --units=G'


#Functions
#bashboard - prints everything between BashBoad delimiters
function bashboard() {
LOC=$(cat ~/.bashrc | grep -n BASHBOARD | cut -f 1 -d:)
arr=($LOC)
FIRST=${arr[0]}
LAST=${arr[-1]}
sed -n "${FIRST},${LAST}p" ~/.bashrc
}

#tether - save variable tether to pwd, venture away and defines yank() to return to tether
function tether() { 
export flag=$(pwd)
printf "Tethered to $flag\n"
}

#snoop - pull user data by user name - accepts multiple arguments
function snoop() { for user in "$@" ; do echo "Snooping on $user" ;  grep "$user" /etc/passwd; printf "\n"; done }

#rollUp - user command pseudoterminal request
function rollUp () {
printf "Enter Allocation Parameters...\n"
read -p 'Memory (Mb): ' MEM
read -p 'Time (hours): ' TIME
read -p 'Partition: ' PARTITION
read -p 'Program: ' PROGRAM
printf "Requesting...\n"
srun --mem=$MEM --time="$TIME:00:00" --partition=$PARTITION --pty $PROGRAM
}

##########BASHBOARD###########
