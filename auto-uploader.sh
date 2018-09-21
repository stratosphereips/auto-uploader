#!/bin/bash

# - In sniffy
    # Start in /opt/Datasets/
    # Get into each IoT folder
    # Read the README and extract
    # the name of the dataset
    # MD5
    # Date of lunch
    # From the folder name get the Rpi id
    # IP address
    # Label of malware
    # Comput the Size of pcap
    # Move the pcap to the correct folder in jin
# Login to Jin
    # Run the pcapsummarizer-iot
    # Link the folder in avast folder non-public
    # Print a CSV summary of all the moved pcaps to put in the spreadsheet
SCRIPT_DIR=`pwd`
DATASETS_FOLDER='/opt/Datasets'
#cd $DATASETS
# List folders in folder
FOLDERS=`ls -d $DATASETS_FOLDER/*/`
#BASE_FOLDER_JIN="/opt/Malware-Project/BigDataset/IoTScenarios/"
BASE_FOLDER_JIN="~/Test/"


for FLDR in $FOLDERS; do 
    cd $FLDR
    # Extract from README.md
    README='README.md'
    # Check if exists..
    MD5=`cat $FLDR/$README|grep MD5|awk -F':' '{print $2}'`
    echo $MD5
    STARTTIME=`cat $FLDR/$README|grep Start|awk -F'.' '{print $2}'`
    echo $STARTTIME
    DURATION=`cat $FLDR/$README|grep Duration|awk -F':' '{print $2}'`
    IP=`cat $FLDR/$README|grep "Infected device"|awk -F': ' '{print $2}'`
    ORIGIN_DEVICE=`cat $FLDR/$README|grep "Origin device"|awk -F': ' '{print $2}'`
    # Get the dataset name in jin
    DATASET_FOLDER_JIN=`cat $FLDR/$README | grep "Generic Dataset name"|awk -F': ' '{print $2}'`
    DATASET_FOLDER_JIN='CTU-IoT-Malware-Capture-8'
    echo $DATASET_FOLDER_JIN
    # .... the rest...
    # Size of pcap do an ls -lh
    # Go to jin
    # The base folder is /opt/Malware-Project/BigDataset/IoTScenarios/
    LAST_FOLDER=`ssh -p 902 project@mcfp.felk.cvut.cz ls -d $BASE_FOLDER_JIN/$DATASET_FOLDER_JIN* | awk -F'/' '{print $6}' | sort -V | tail -1`
    echo $LAST_FOLDER
    NEW_INDEX=`echo $LAST_FOLDER | awk -F'-' '{print $6+1}'`
    # sort ls by name
    # Find the last number used for my folder
    # if first, empty answer. If not, get the last number
    # increment the last number
    # Create the folder in jin
    PCAP_FILES=`ls *.pcap`
    FOLDERS=()
    for FILE in $PCAP_FILES; do
       # create a new folder
       NEW_FOLDER="$BASE_FOLDER_JIN/${DATASET_FOLDER_JIN}-${NEW_INDEX}"
	FOLDERS+=($NEW_FOLDER)
       	`ssh -p 902 project@mcfp.felk.cvut.cz mkdir $NEW_FOLDER` 
	echo "Uploading file $FILE to $NEW_FOLDER"
	`scp -P 902 -C $FILE project@mcfp.felk.cvut.cz:$NEW_FOLDER`
	`scp -P 902 -C $README project@mcfp.felk.cvut.cz:$NEW_FOLDER`
	`ssh -p 902 project@mcfp.felk.cvut.cz ln -s $NEW_FOLDER ~/NonPublic/`
        NEW_INDEX=$((NEW_INDEX+1))
	`ssh -p 902 project@mcfp.felk.cvut.cz pcapsummarizer-iot.sh $NEW_FOLDER`
	SIZE=`ls -lh $FILE|awk -F' ' '{print $5}'`
	echo "$DATASET_FOLDER_JIN-$NEW_INDEX,$MD5,$STARTTIME,$ORIGIN_DEVICE,$DURATION,$IP,Yes,No,,$SIZE," >> $SCRIPT_DIR/report.csv;
    done 
    # cp the pcap and the README.md. If more than one pcap in local folder, a new remote folder for each of them
        # scp -C 
    # remmeber the new folders
    # Run pcapsummarizer-iot.sh. first arg is the folder name.
    # link
    # ln -s /opt/Malware-Project/BigDataset/IoTScenarios/CTU-IoT-Malware-Capture-8-3 /opt/Malware-Project/Dataset/NonPublic/
    #echo 
done

# To print a CSV with all the info
# Name of Dataset,MD5 Malware,Date of launch,Origin Device,Duration (days), IP,Shared with Avast,Analyzed, Label, Size (GB), Notes
