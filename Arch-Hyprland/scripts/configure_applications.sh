#!/bin/bash
set -euo pipefail
REPO_DIR="$(pwd)"

echo -e "\n+ + [ Now configuring user applications ] + + \n"

echo -e " - ( Now selecting image viewers) -\n"
select choice in "nsxiv" "imv" "sxiv" "chafa" "timg" "none"; do
  case $choice in
    "nsxiv")
      sudo  pacman -S --needed --noconfirm nsxiv
      break
      ;;
    "imv")
      sudo  pacman -S --needed --noconfirm imv
      break
      ;;
    "sxiv")
      sudo  pacman -S --needed --noconfirm sxiv
      break
      ;;
    "chafa")
      sudo  pacman -S --needed --noconfirm chafa
      break
      ;;
    "timg")
      sudo  pacman -S --needed --noconfirm timg
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

echo -e " - ( Now selecting  video players) -\n"
select choice in "mpv" "celluloid"  "ffplay" "haruna" "none"; do
  case $choice in
    "mpv")
      sudo  pacman -S --needed --noconfirm mpv
      break
      ;;
    "celluloid")
      sudo  pacman -S --needed --noconfirm celluloid
      break
      ;;
    "ffplay")
      sudo  pacman -S --needed --noconfirm ffmpeg
      grep -qxF "alias ffplay='ffplay -autoexit'" ~/.bashrc || echo "alias ffplay='ffplay -autoexit'" >> ~/.bashrc
      break
      ;;
    "haruna")
      sudo  pacman -S --needed --noconfirm haruna
      break
      ;;
    "none")
      echo -e "Skipping video player \n"
      break
      ;;
    *)
      echo -e "Not a valid option, try again. \n"
      ;;
  esac
done

echo -e " - ( Now selecting audio players) -\n"
select choice in "cmus" "mpv"  "sox" "mpg123" "ncmpcpp" "none"; do
  case $choice in
    "cmus")
      sudo  pacman -S --needed --noconfirm cmus
      break
      ;;
    "mpv")
        if pacman -Q mpv &> /dev/null; then
            echo "mpv already installed, skipping"
        else
            sudo pacman -S --needed --noconfirm mpv
        fi
      break
      ;;
    "sox")
      sudo  pacman -S --needed --noconfirm sox  
      break
      ;;
    "mpg123")
      sudo  pacman -S --needed --noconfirm mpg123
      grep -qxF "alias mplay='mpg123 -C" ~/.bashrc || echo "alias mplay='mpg123 -C'" >> ~/.bashrc
      break
      ;;
    "ncmpcpp")
      sudo  pacman -S --needed --noconfirm mpd ncmpcpp
      break
      ;;
    "none")
      echo -e "Skipping audio player \n"
      break
      ;;
    *)
      echo -e "Not a valid option, try again. \n"
      ;;
  esac
done


echo -e "\n - ( Now Selecting GUI applications ) - \n"

echo -e " [Office and utility software] \n"

read -p "Would you like install Blueman and enable bluetooth? (Y/N)" blue
if [[ "$blue" == "Y" || "$blue" == "y" ]];then
      sudo  pacman -S --needed --noconfirm blueman bluez bluez-utils
      sudo systemctl enable --now bluetooth.service
      rfkill list
      rfkill unblock bluetooth
else
   echo "- Skipping Bluetooth -"
fi

read -p "Would you like install Libreoffice? (Y/N)" office
if [[ "$office" == "Y" || "$office" == "y" ]];then
      sudo  pacman -S --needed --noconfirm libreoffice-still mythes-en hunspell-en_us  
else
    echo "- Skipping libre office -"
fi

read -p "Would you like install File roller for archives (zip,rar,ect)? (Y/N)" fileroller
if [[ "$fileroller" == "Y" || "$fileroller" == "y" ]];then
      sudo  pacman -S --needed --noconfirm file-roller
else
  echo "- Skipping File roller -"
fi

read -p "Would you like install Zathura PDF viewer? (Y/N)" zathura
if [[ "$zathura" == "Y" || "$zathura" == "y" ]];then
      sudo  pacman -S --needed --noconfirm zathura zathura-pdf-mupdf
else
  echo "- Skipping zathura -"
fi

read -p "Would you like install Obsidian for note taking? (Y/N)" obsidian
if [[ "$obsidian" == "Y" || "$obsidian" == "y" ]];then
      sudo  pacman -S --needed --noconfirm obsidian glow
else
     echo "- Skipping obsidian -"
fi

echo -e " [ Communication and entertainment software] \n"

read -p "Would you like install Steam? (Y/N)" steam
if [[ "$steam" == "Y" || "$steam" == "y" ]];then
      sudo  pacman -S --needed --noconfirm steam
else
     echo "- Skipping Steam -"
fi

read -p "Would you like install Webcord/Discord? (Y/N)" webcord
if [[ "$webcord" == "Y" || "$webcord" == "y" ]];then
      sudo  pacman -S --needed --noconfirm webcord
else
     echo "- Skipping Webcord -"
fi

read -p "Would you like install Thunderbird email client? (Y/N)" thunderbird
if [[ "$thunderbird" == "Y" || "$thunderbird" == "y" ]];then
      sudo  pacman -S --needed --noconfirm thunderbird
else
     echo "- Skipping Thunderbird -"
fi

read -p "Would you like install Qbittorrent for torrent support? (Y/N)" qbit
if [[ "$qbit" == "Y" || "$qbit" == "y" ]];then
      sudo  pacman -S --needed --noconfirm qbittorrent 
else
     echo "- Skipping Qbittorrent -"
fi


echo -e " [Creative software] \n"
read -p "Would you like install Krita? (Y/N)" krita
if [[ "$krita" == "Y" || "$krita" == "y" ]];then
      sudo  pacman -S --needed --noconfirm krita
else
     echo "- Skipping krita -"
fi

read -p "Would you like install Inkscape ? (Y/N)" ink
if [[ "$ink" == "Y" || "$ink" == "y" ]];then
      sudo  pacman -S --needed --noconfirm inkscape
else
     echo "- Skipping inkscape -"
fi

read -p "Would you like install Libresprite ? (Y/N)" libsprite
if [[ "$libsprite" == "Y" || "$libsprite" == "y" ]];then
      sudo  pacman -S --needed --noconfirm libresprite
else
     echo "- Skipping libresprite -"
fi
read -p "Would you like install Obs Studio? (Y/N)" obs
if [[ "$obs" == "Y" || "$obs" == "y" ]];then
      sudo  pacman -S --needed --noconfirm obs-studio 
else
     echo "- Skipping obsstudio -"
fi

echo -e "\n+ + [ Done ] + + \n"
echo "\n+ + [ User applications configured ] + +\n"
