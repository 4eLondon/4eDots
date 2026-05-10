#!/bin/bash

echo "Generating London default file structure"
sleep 0.5s

# Create Folders

mkdir -p ~/bin
sleep 0.2s
echo "Created Bin folder in Home"

mkdir -p ~/Pictures/Screenshots/{Saved,Unsorted}
mkdir -p ~/Pictures/Saved
mkdir -p ~/Pictures/Wallpapers
echo "Created Pictures subdirectories"
sleep 0.2s

mkdir -p ~/Documents/Projects/{Active,Archive,Temp,Logs}
mkdir -p ~/Documents/Documentaion/{Guides,Notes}
echo "Created Documents subdirectories"
sleep 0.2s

mkdir -p ~/Music/{Songs,Sounds}
echo "Created Music subdirectories"
sleep 0.2s

mkdir -p ~/Videos/{Guides,Unsorted}
echo "Created Videos subdirectories"
sleep 0.2s

# Cofirmation n Error Handeling
if [ $? -eq 0 ]; then
    echo "Folder structure created successfully in Home directory"
    ls -lR ~/
else
    echo "Error creating folders"
    exit 1
fi

