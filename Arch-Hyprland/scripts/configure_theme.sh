#!/bin/bash
set -euo pipefail

echo -e "\n+ + [ Now configuring user theme ] + + \n"


echo -e " - ( Which theme would you like to install? ) -\n"
select choice in "SnowCaution" "HazardWatch" "OceanZero" "Everforest" "none"; do
  case $choice in
    "SnowCaution")
      break
      ;;
    "HazardWatch")
      break
      ;;
    "OceanZero")
      break
      ;;
    "Everforest")
      break
      ;;
    "none")
      echo -e "Skipping image viewer \n"
      break
      ;;
    *)
      echo -e "Not a valid option, try again. \n"
      ;;
  esac
done
