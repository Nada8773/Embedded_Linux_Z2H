#!/bin/bash

clear

flag=0
MultiNumber=0
check_numerical=0
input_name=0

# create the directory for the database file if not  exist
mkdir -p "/home/$USER/linux/lectures/Assigments"  

# database file path
FilePath="/home/$USER/linux/lectures/Assigments/phonebookDB.txt"  


# check if the file exist or not 
if [ ! -f "$FilePath" ];then  # not exist
	touch $FilePath       # create file
fi



#check if running the script without choosing any option
if [[ -z $1 ]];then
	flag=1
else
	choice=$1		
fi
	


while :
do

	# Display all options
	if [ $flag -eq 1 ];then
		echo -e "\n"
		echo "__________________________________________________"
		echo "Enter '-i' to insert new contact"
		echo "Enter '-v' to display all saved contacts"
		echo "Enter '-s' to search by contact name"
		echo "Enter '-e' to Delete all Records"
		echo "Enter '-d' to Delete one name"
		echo "Enter '-E' to Exit"
		echo "__________________________________________________"
		echo "Enter your option"
		read choice
	fi

	MultiNumber=0
        input_name=0	
	# switch case
	case $choice in
		'-i') 
			echo "Enter the name"
                        echo "please enter the name without any space"
			read name
                        count=$(grep -c "$name" $FilePath ) # count the matching name
			#check if the name is already exist
			if [ $count != 0 ];then 
				echo "Sorry the name is exist already"
			else
			 	echo "Enter the phone number"
				read PhoneNumber

				while [ $MultiNumber -eq 0 ] 
				do		  
		                        # check if the phone number not numerical 
				       echo $PhoneNumber | grep -q "^[0-9]*$" && check_numerical=1 || 									                 check_numerical=0
				      
		                       # if phone number isnot numerical  enter it again
				        while [ $check_numerical -eq 0 ]
					do
					  echo " Your input is wrong "
				          echo " Please enter the phone number again"
					  read PhoneNumber
				          echo $PhoneNumber | grep -q "^[0-9]*$"&&check_numerical=1|| 										           check_numerical=0
				        done
					if [ $input_name != 1 ];then  
                                               # create newline
						echo -e "\n" >> $FilePath
						# update database with your entry
						echo $name $PhoneNumber >>$FilePath
						input_name=1
					fi
		                       
		                        #check if it has multiple number
		                        echo "Do you want to Enter another phone number? Y/N"
					read MultiNumber_choice

					if [ $MultiNumber_choice = 'Y' ];then
						echo "Enter the another phone number"
						read PhoneNumber2
						truncate -s-1 $FilePath
						echo -n " $PhoneNumber2" >> $FilePath
					else
						MultiNumber=1			
					fi
				done
			       flag=1   
			fi
		 ;;

		'-v')  
			echo "All your contacts "
			#Display all Database and remove space line
                        cat  $FilePath | grep '\S'
			flag=1 
		;;

		'-s')
			echo "Enter the name for search to get the telephone number "
		        read search_name
			count=$(grep -c "$search_name" $FilePath ) # count the matching name
			if [ $count != 0 ];then
				cat  $FilePath | grep -w $search_name
			        
			else
				echo "The name you enter isn't exist in your database"
			fi
			
		       flag=1 
		;;

		'-e') 
			# > to write the (null) input from echo -n to the file.
			echo -n "" > $FilePath   
			echo "ALL contents of your DataBase is deleted"
	 		flag=1
		
		;;

		'-d') 
			echo "Enter the contact name to delete it"
			read deleted_name
                        #check if the contact in your database
			if  grep -q "$deleted_name" "$FilePath" && echo $? > 0 ;then
				sed -i "/$deleted_name/d" $FilePath  # delete the name from database
				echo "the contact name is deleted successfully"
			else
				 echo "The name you enter isn't exist in your database"
			fi
			
			flag=1
		;;
	     
		'-E') exit
		;;
		
	esac
done

