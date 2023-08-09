#!/bin/bash
# Author: Nigel Walker
# Website: 
# Description: Script to install San Francisco Fonts
# Dependencies: wget, 7zip


output_dir="/usr/share/fonts/truetype/apple"
tmp_dir="/tmp/fonts-apple"
fontfile1="https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg"
fontfile2="https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg"
fontfile3="https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg"
fontfile4="https://devimages-cdn.apple.com/design/resources/download/NY.dmg"

if [[ $EUID -ne 0 ]]; then
   echo -e "You must be a root user!\nTry: sudo ./fonts-installer.sh" 2>&1
   exit 1
fi

if ! which wget >/dev/null; then
    echo "Error: wget is required to download the file"
    echo "Run the following command to install it:"
    echo "sudo apt install wget"
    exit 1
fi

if ! which 7z >/dev/null; then
    echo "Error: 7zip is required to unpack the files"
    echo "Run the following command to install it:"
    echo "sudo apt install 7zip"
    exit 1
fi

file="$tmp_dir/SF-Pro.dmg"
mkdir -p "$tmp_dir"
echo -e "\n:: Downloading SF Pro Fonts..\n"
wget -O "$file" $fontfile1    
cd "$tmp_dir"
7z x SF-Pro.dmg
cd SFProFonts/
7z x SF\ Pro\ Fonts.pkg
7z x Payload~

file="$tmp_dir/SF-Compact.dmg"
echo -e "\n:: Downloading SF Compact Fonts..\n"
wget -O "$file" $fontfile2    
cd "$tmp_dir"
7z x SF-Compact.dmg
cd SFCompactFonts/
7z x SF\ Compact\ Fonts.pkg
7z x Payload~

file="$tmp_dir/SF-Mono.dmg"
echo -e "\n:: Downloading SF Mono Fonts..\n"
wget -O "$file" $fontfile3    
cd "$tmp_dir"
7z x SF-Mono.dmg
cd SFMonoFonts/
7z x SF\ Mono\ Fonts.pkg
7z x Payload~

file="$tmp_dir/NY.dmg"
echo -e "\n:: Downloading NY Fonts..\n"
wget -O "$file" $fontfile4    
cd "$tmp_dir"
7z x NY.dmg
cd NYFonts/
7z x NY\ Fonts.pkg
7z x Payload~
    
echo -n "\n:: Installing... \n"
mkdir -p "$output_dir"
cp -f /home/nigel/tmp/fonts-apple/SFProFonts/Library/Fonts/*.* "$output_dir"
cp -f /home/nigel/tmp/fonts-apple/SFCompactFonts/Library/Fonts/*.* "$output_dir"
cp -f /home/nigel/tmp/fonts-apple/SFMonoFonts/Library/Fonts/*.* "$output_dir"
cp -f /home/nigel/tmp/fonts-apple/NYFonts/Library/Fonts/*.* "$output_dir"
echo "Done!"
  
echo -n ":: Clean the font cache... "
fc-cache -f "$output_dir"
echo "Done!"

echo -n ":: Cleanup... "
cd - 
rm -rf "$tmp_dir"
echo "Done!"

