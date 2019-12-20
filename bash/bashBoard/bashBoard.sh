#Build ~/.bashrc custom aliases for cluster use
#to activate source ~/.bashrc

#Aliases
#List your current aliases
alias extility='echo | cat ~/.bashrc | grep -E "alias"'

#Basic commands with safety arguments defaulted
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias chmod='chmod -v'

#ask for currently running jobs, refresh every 10 seconds, ctrl+c to exit
alias jobs='squeue -u $USER -i10'

#Show specs on last jobs ran - job history usually 24hr but depends on cluster
alias specs='sacct --format="JobName%30, JobID, Start, Partition, NCPUS, MaxRSS,MaxDiskWrite, Elapsed, STATE" --units=G'

#Shows farm usage across all node
alias traffic='sinfo --Node --long --sort=PARTITION'

#open the last file in a list, useful for long lists of .out and .err files
alias catLast='cat "$(ls -rt | tail -n1)"'

#Count the number of files in current directory
alias countFiles='ls -1 | wc -l'

#Show the account QOS limitations on the cluster
alias limits='sacctmgr -p list qos $@ format=Name,Priority,GraceTime,GrpTRES,GrpJobs,GrpSubmit,GrpSubmit,MaxTRES,MaxTRESPerUser,MaxJobsPU | column -ts"|"'

#Show the limits on your own account
alias mylimits='sacctmgr list associations format=Account,User,Partition,qos'

#Show cluster configuration settings
alias configs='scontrol show config'

#Run interactive R in pseudo terminal on FARM
alias ptyR='srun --mem=60000 --time=24:00:00 --partition=high --pty R'

#Run interactive bash in pseudo terminal on FARM
alias ptyBash='srun --mem=60000 --time=24:00:00 --partition=high --pty bash'

