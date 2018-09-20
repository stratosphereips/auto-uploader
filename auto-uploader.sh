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

DATASETS_FOLDER='/opt/Datasets'
#cd $DATASETS
# List folders in folder
FOLDERS=`ls -d $DATASETS_FOLDER/*/`

for FLDR in $FOLDERS; do 
    #echo $FLDR
    cd $FLDR
    # Extract from README.md
    README='README.md'
    # Check if exists..
    MD5=`cat $FLDR/$README|grep MD5|awk -F':' '{print $2}'`
    echo $MD5
    STARTTIME=`cat $FLDR/$README|grep Start|awk -F'.' '{print $2}'`
    echo $STARTTIME
    # Get the dataset name in jin
    DATASET_FOLDER_JIN='CTU-IoT-Malware-Capture-8'
    # .... the rest...
    # Size of pcap do an ls -lh
    # Go to jin
    # The base folder is /opt/Malware-Project/BigDataset/IoTScenarios/
    LAST_FOLDER=`ssh -p 902 project@jin ls -d /opt/Malware-Project/BigDataset/IoTScenarios/$DATASET_FOLDER_JIN* | awk -F'/' '{print $6}' | sort -V | tail -1`
    echo $FILES_IN_JIN
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
       NEW_FOLDER=`/opt/Malware-Project/BigDataset/IoTScenarios/$DATASET_FOLDER_JIN-$NEW_INDEX`
	$FOLDERS+=($NEW_FOLDER)
	`ssh -p 902 project@jin mkdir $NEW_FOLDER` 
	scp -C $FILE project@jin:$NEW_FOLDER
	scp -C $README project@jin:$NEW_FOLDER
	ssh -p 902 project@jin ln -s $NEW_FOLDER /opt/Malware-Project/Dataset/NonPublic/$DATASET_FOLDER_JIN-$NEW_INDEX
	NEW_INDEX=$NEW_INDEX+1
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








