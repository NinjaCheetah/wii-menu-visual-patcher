# wii-menu-visual-patcher
Shell script to make modifying visual elements of the Wii Menu easier.
## Current Features:
- Unpacking `diskBann.ash` for modifying the Disc Channel's banner
- Automatically patching the Disc Channel's banner to enable the normally hidden picture of a DVD (after unpacking)
- Repacking `diskBann.ash` PROPERLY with a binary patch that fixes issues with crashing when the modified Disc Channel banner is displayed
- Repacking the System Menu WAD with any modified .app files to apply patches

For Korean Wiis (and any region of the Wii Mini), please use the `kr` variant of the script. These consoles store files differently, and for now an alternate version of the script is required the accomodate them. This script will enable both the DVD *and* the GameCube disc, since it is normally hidden on these consoles.
### Requirements
- A Linux system
- `wine` installed (the tools required for extraction/packing are Windows-only)
- `vim` installed (xxd is used for patching files and is included with vim)
- A WAD for the Wii System Menu version you intend to modify
### Wii Menu Support
This script has been tested with and works on the following System Menu versions:
- U: 2.0-4.3
- E: 2.0-4.3
- J: 2.0-4.3

The **Korean variant** of the script has been tested with and works on the following System Menu versions:
- K: 3.5-4.3
- Wii Mini U: 4.3
- Wii Mini E: 4.3

This script does *not* work with the following System Menu versions:
- J: 1.0RC

This script has not been tested with the following System Menu versions:
- U: 1.0
- E: 1.0
- J: 1.0
### Usage
`chmod +x wii-menu-visual-patcher.sh`

`./wii-menu-visual-patcher.sh /path/to/system-menu.wad`

or

`chmod +x wii-menu-visual-patcher-kr.sh`

`./wii-menu-visual-patcher-kr.sh /path/to/kr-system-menu.wad`

The script will download and extract all of the tools it requires to work. Just pick the options you want from the menu, and let it do the work!

> [!WARNING]  
> **BE CAREFUL WHEN INSTALLING THE MODIFIED WAD!**
> The Wii has *very little* brick protection/error handling so any changes may result in crashes or bricks. I am not responsible for any damaged consoles. This script is designed mostly just for fun, so please just stick to using Dolphin.

> [!WARNING]  
> **DO NOT MIX VARIANTS OF THE SCRIPT!**
> While attempting to use the regular script on a Korean or Wii Mini WAD will yield no issues but no results, using the Korean script on any other console may create a potentially harmful WAD! Please use the appropriate version of the script for the System Menu you are patching. This will be automated in the future.

Example video of the result: [https://cdn.ncxprogramming.com/file/blog/2023-06-19/wii-dvd-p3-finally-working.mp4](https://cdn.ncxprogramming.com/file/blog/2023-06-19/wii-dvd-p3-finally-working.mp4)
