# wii-menu-visual-patcher
Shell script to make modifying visual elements of the Wii Menu easier.
## Current Features:
- Unpacking `diskBann.ash` for modifying the Disc Channel's banner
- Automatically patching the Disc Channel's banner to enable the normally hidden picture of a DVD (after unpacking)
- Repacking `diskBann.ash` PROPERLY with a binary patch that fixes issues with crashing when the modified Disc Channel banner is displayed
- Repacking the System Menu WAD with any modified .app files to apply patches
### Requirements
- A Linux system
- `wine` and `unrar` installed (the tools required for extraction/packing are Windows-only)
- A WAD for the Wii System Menu version you intend to modify
### Usage
`chmod +x wii-menu-visual-patcher.sh`

`./wii-menu-visual-patcher.sh /path/to/system-menu.wad`

The script will download and extract all of the tools it requires to work. Just pick the options you want from the menu, and let it do the work!

#### BE CAREFUL WHEN INSTALLING THE MODIFIED WAD!
The Wii has *very little* brick protection/error handling so any changes may result in crashes or bricks. I am not responsible for any damaged consoles. This script is designed mostly just for fun, so please just stick to using Dolphin.

Example video of the result: [https://cdn.ncxprogramming.com/file/blog/2023-06-19/wii-dvd-p3-finally-working.mp4](https://cdn.ncxprogramming.com/file/blog/2023-06-19/wii-dvd-p3-finally-working.mp4)
