#!/bin/bash 

FILES=*.bson
EXT=".bson"

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "usage : sh ./restore_dbs.sh [db name]"
    exit
fi

DBNAME=$1

confirm() {
	echo $(printf "The database to restore is : %s ? Y/n" $DBNAME)

	read answer

	  case $answer in
	    "Y")
	      restoring ;;
	    "n")
	      echo "canceling..."
	      exit ;;
	    *)
	      confirm ;;
	  esac
}

restoring() {

	# Getting each file

	# Restoring
	for f in $FILES
	do
		tmpFile=${f%$EXT}
		eval $(printf "mongorestore -d %s %s -c %s --drop --host=127.0.0.1" $DBNAME $f $tmpFile)
	done
}

confirm
