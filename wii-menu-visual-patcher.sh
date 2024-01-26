#!/bin/bash
# Wii Menu Visual Patcher Script
# Copyright (c) 2023-2024 NinjaCheetah


which wine
if [ $? != 0 ]
  then
    echo "WINE not found. Tools used in this script are designed for Windows and therefore require WINE to run. Please install WINE from your system's package manager."
    exit
fi

which xxd
if [ $? != 0 ]
  then
    echo "xxd not found. xxd is required to apply patches to files. Please install xxd by installing vim from your system's package manager."
    exit
fi

export WINEDEBUG=-all

if [ $# -eq 0 ]
  then
    echo "Wii Menu Visual Patcher by NinjaCheetah"
    echo "Please provide the path to your RVL-WiiSystemmenu-vXXX.wad."
    exit
fi

mkdir -p tools
cd tools

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

if [ ! -f "ASH" ]; then
    curl -L https://github.com/NinjaCheetah/ASH_Extractor/releases/latest/download/ASH-Linux.tar -o ASH-Linux.tar
    if [ $? != 0 ]
    then
        echo "An error occurred while downloading ASH. Please check your internet connection."
        exit
    fi

    tar xvf ASH-Linux.tar
    chmod +x ASH
    rm ASH-Linux.tar
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

cd ../

echo -e "\nAll tools are accounted for. Let's extract!\n"

if [ ! -f $1 ]; then
    echo -e "Couldn't find $1. Please make sure you've entered the path to your System Menu WAD correctly."
    exit
fi

if [ -d "wad" ]; then
    echo "WAD seems to already be unpacked! Skipping... (Remove wad/ to get a clean copy.)"
else
    wine tools/Sharpii.exe WAD -u "$1" wad/
    echo -e "\nWAD extracted!"
fi

unpack_diskbann () {
    echo -e "Now unpacking diskBann.ash, please wait... \n"
    echo -e "\nUnpacking 00000001.app...\n"
    cp "wad/00000001.app" .
    wine tools/Sharpii.exe U8 -u 00000001.app 00000001/
    echo -e "\nUnpacking diskBann.ash...\n"
    cp "00000001/layout/common/diskBann.ash" .
    ./tools/ASH diskBann.ash
    echo -e "\nUnpacking diskBann.ash.arc...\n"
    wine tools/Sharpii.exe U8 -u diskBann.ash.arc diskBann/
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
    echo -e "Add additional patch to reposition discs to be more even?"
    read -p "$* [y/n]: " yn
    case $yn in
        [Yy]*)
            echo -e "\nAdding addtional patch...\n"
            printf "000004D4: C4" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000004D5: C7" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000004D6: B7" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000004D7: A4" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000006B0: C4" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000006B1: C7" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000006B2: B7" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000006B3: A4" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000008EC: C4" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000008ED: C7" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000008EE: B7" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000008EF: A4" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001078: C3" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001079: 1D" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000010CC: 43" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "000010CD: 1D" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001188: C4" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001189: C7" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "0000118A: B7" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "0000118B: A4" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001264: C4" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001265: C7" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001266: B7" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001267: A4" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001340: C4" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001341: C7" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001342: B7" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001343: A4" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001444: 00" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001445: 00" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001620: 00" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001621: 00" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001CA5: 34" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001D28: 00" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001D29: 00" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001DAC: 43" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001DAD: 20" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
            printf "00001E37: F6" | xxd -r - "diskBann/arc/blyt/my_DiskCh_a.brlyt"
        ;;
        [Nn]*)
            echo -e "Extra patch won't be applied.\n"
        ;;
    esac
    echo -e "DVD icon enabled! You can now repack diskBann.ash."
}

pack_diskbann () {
    if [ ! -d "diskBann" ]; then
        echo "You have not unpacked diskBann.ash yet!"
        return
    fi
    echo -e "Now packing diskBann.ash, please wait... \n"
    echo -e "\nPacking diskBann.arc...\n"
    wine tools/Sharpii.exe U8 -p "diskBann/" "diskBann.arc"
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
    wine tools/ashcompress.exe "diskBann-patched.arc"
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
        wine tools/Sharpii.exe U8 -p "$dir/" "wad/$dir.app"
    done
    echo -e "\nAll modified .apps have been repacked!\n"
    echo -e "Repacking SystemMenu WAD..."
    wine tools/Sharpii.exe WAD -p "wad/" "${1%.*}-MODIFIED.wad"
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
            read -p "Remove tools? [y/n]: " yn
            case $yn in
                [Yy]*)
                    rm -rd "tools/"
                    echo -e "Tools removed.\n"
                ;;
                [Nn]*)
                    echo -e "Tools not removed.\n"
                ;;
            esac
            echo -e "All done!\n"
            exit
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
