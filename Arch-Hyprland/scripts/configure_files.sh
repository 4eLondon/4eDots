#!/bin/bash
set -euo pipefail

echo -e "\n+ + [ Now creating user directories ] + + \n"

mkdir -p ~/{Pictures,Downloads,Videos,Desktop,Music,Documents}

read -p "Create custom subfolders? (y/n): " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "- Placing custom subfolders  -"
    mkdir -p ~/Pictures/{Screenshots/{Sorted,Unsorted},Wallpapers,Saved}
    sleep 1s
    mkdir -p ~/Music/{Songs,Sounds}
    sleep 1s
    mkdir -p ~/Videos/{Saved,Unsorted}
    sleep 1s
    mkdir -p ~/Documents/{Projects/{Active,Temp,Logs,Idle},Papers/{Notes,Guides},Misc}
    echo -e "\n+ + [ Done ] + + \n"
    echo  -e "\n+ + [ Folders and subfolders added successfully ] + +\n"
else
    echo -e "\n+ + [ Done ] + + \n"
    echo -e "\n+ + [ All Folders added successfully ] + +\n"
fi
