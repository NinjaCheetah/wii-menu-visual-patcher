#!/bin/bash
# Wii Menu Visual Patcher Script
# Copyright (c) 2023 NinjaCheetah


which unrar
if [ $? != 0 ]
  then
    echo "Unrar not found. Please install unrar from your system's package manager."
    exit
fi

which wine
if [ $? != 0 ]
  then
    echo "WINE not found. Tools used in this script are designed for Windows and therefore require WINE to run. Please install WINE from your system's package manager."
    exit
fi

if [ $# -eq 0 ]
  then
    echo "Wii Menu Visual Patcher by NinjaCheetah"
    echo "Please provide the path to your RVL-WiiSystemmenu-vXXX.wad."
    exit
fi

if [ ! -f "Sharpii.exe" ]; then
    curl -L https://github.com/mogzol/sharpii/releases/latest/download/Sharpii_v1.7.3.zip -o Sharpii.zip
    if [ $? != 0 ]
    then
        echo "An error occurred while downloading Sharpii. Please check your internet connection."
        exit
    fi

    unzip Sharpii.zip
    rm Sharpii.zip
fi

if [ ! -f "ASH.exe" ]; then
    curl -L https://wiibrew.org/w/images/1/14/ASH_v0.1.rar -o ASHextractor.rar
    if [ $? != 0 ]
    then
        echo "An error occurred while downloading ASH Extractor. Please check your internet connection."
        exit
    fi

    unrar e ASHextractor.rar
    rm ASHextractor.rar
fi

if [ ! -f "ashcompress.exe" ]; then
    curl -L https://gbatemp.net/download/ash-compressor.34055/download -o ASHcompress.zip
    if [ $? != 0 ]
    then
        echo "An error occurred while downloading ashcompress. Please check your internet connection."
        exit
    fi

    unzip ASHcompress.zip
    rm ASHcompress.zip
fi

echo -e "\nAll tools are accounted for. Let's extract!\n"
if [ -d "wad" ]; then
    echo "WAD seems to already be unpacked! Skipping... (Remove wad/ to get a clean copy.)"
else
    wine Sharpii.exe WAD -u "$1" wad/
    echo -e "\nWAD extracted!"
fi

unpack_diskbann () {
    echo -e "Now unpacking diskBann.ash, please wait... \n"
    echo -e "\nUnpacking 00000001.app...\n"
    cp "wad/00000001.app" .
    wine Sharpii.exe U8 -u 00000001.app 00000001/
    echo -e "\nUnpacking diskBann.ash...\n"
    cp "00000001/layout/common/diskBann.ash" .
    wine ASH.exe diskBann.ash
    echo -e "\nUnpacking diskBann.ash.arc...\n"
    wine Sharpii.exe U8 -u diskBann.ash.arc diskBann/
    echo -e "\nCleaning up...\n"
    rm 00000001.app diskBann.ash diskBann.ash.arc
    echo -e "Done!\n"
}

enable_dvd () {
    if [ ! -d "diskBann" ]; then
        echo "You have not unpacked diskBann.ash yet!"
        return
    fi
    echo -e "Patching my_DiskCh_a.brlyt to enable the hidden DVD icon in the Disc Channel... \n"
    printf "00001104: 05" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
    printf "0000147C: 07" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
    printf "00001658: 05" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
    printf "00001C88: 05" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
    echo -e "Patch applied! You can now repack diskBann.ash."
}

pack_diskbann () {
    if [ ! -d "diskBann" ]; then
        echo "You have not unpacked diskBann.ash yet!"
        return
    fi
    echo -e "Now packing diskBann.ash, please wait... \n"
    echo -e "\nPacking diskBann.arc...\n"
    wine Sharpii.exe U8 -p "diskBann/" "diskBann.arc"
    echo -e "\nApplying binary patch to diskBann.arc to fix crashing...\n"
    cp diskBann.arc diskBann-patched.arc
    printf "00000032: 00" | xxd -r - diskBann-patched.arc
    printf "00000033: 00" | xxd -r - diskBann-patched.arc
    printf "0000003E: 00" | xxd -r - diskBann-patched.arc
    printf "0000003F: 01" | xxd -r - diskBann-patched.arc
    printf "000000C2: 00" | xxd -r - diskBann-patched.arc
    printf "000000C3: 01" | xxd -r - diskBann-patched.arc
    printf "000000DA: 00" | xxd -r - diskBann-patched.arc
    printf "000000DB: 01" | xxd -r - diskBann-patched.arc
    echo -e "\nPacking diskBann.arc.ash...\n"
    wine ashcompress.exe "diskBann-patched.arc"
    echo -e "\nPlacing diskBann.ash back into 00000001/...\n"
    rm "00000001/layout/common/diskBann.ash"
    mv "diskBann-patched.arc.ash" "00000001/layout/common/diskBann.ash"
    echo -e "Done!\n"
}

pack_sysmenu () {
    echo -e "Now repacking all modified .apps... \n"
    for dir in 0000000*/
    do
        dir=${dir%*/}
        echo -e "\nFound extracted/modified $dir.app, repacking...\n"
        rm "wad/$dir.app"
        wine Sharpii.exe U8 -p "$dir/" "wad/$dir.app"
    done
    echo -e "\nAll modified .apps have been repacked!\n"
    echo -e "Repacking SystemMenu WAD..."
    wine Sharpii.exe WAD -p "wad/" "${1%.*}-MODIFIED.wad"
    echo -e "\nYour WAD is ready to go! Please be EXTREMELY CAREFUL if you intend to install this on any real system. I do not recommend doing so under any circumstance. However, I highly recommend installing it into Dolphin and seeing how your changes worked.\n"
}

echo -e "\nSelect an option to continue:"

PS3='? '
options=("Unpack diskBann.ash" "Enable DVD in Disc Channel" "Pack diskBann.ash" "Pack SystemMenu WAD" "Clean Up" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Unpack diskBann.ash")
                unpack_diskbann;
            ;;
        "Enable DVD in Disc Channel")
                enable_dvd;
            ;;
        "Pack diskBann.ash")
                pack_diskbann;
            ;;
        "Pack SystemMenu WAD")
                pack_sysmenu "$1";
            ;;
        "Clean Up")
            echo -e "Removing all non-tool files used by this script...\n"
            for dir in 0000000*/
            do
                dir=${dir%*/}
                rm -rd "$dir"
            done
            rm *.app
            rm *.arc
            rm -rd "wad/"
            rm -rd "diskBann/"
            echo -e "All done!\n"
            exit
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
