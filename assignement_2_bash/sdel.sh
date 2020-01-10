#!/bin/bash

clear

(crontab -l 2>/dev/null; echo "*/60 * * * * sdel.sh") | crontab -  # cron to run automatically

mkdir -p "/home/$USER/TRASH"   # create the directory for the trash file if not exist
TrashPath="/home/$USER/TRASH"

find $TrashPath -type f -mtime +2 -exec rm -f {} \; 	#remove files older than 2 days

# gzip all file that pass in command line
 for i in $*; do 
	# check if the file is compressed or not 
   if file $i* |grep -q "compressed";then
	echo "the file is already Compressed"
   else
	 echo "the file is not compressed"
  	 gzip -q $i
   fi
   
    #move gzip file to the trash
    mv "$i.gz" $TrashPath
 done



