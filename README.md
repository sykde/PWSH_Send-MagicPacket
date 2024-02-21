# PWSH_Send-MagicPacket
Sends WOL packet to a specified MAC address.

## Installation instructions
1. Download the script (`Send-MagicPacket.ps1`) and the JSON (`targetsList.json`) file.
2. Put the script in a directory of your choice
3. Move the JSON file in the `~\.config\WakeOnLan\` folder. To do this you can run these commands in PowerShell (assuming the JSON file is in the `Downloads` folder):

    ```powershell
    New-Item -ItemType Directory -Path $env:HOMEPATH -Name .config -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path $env:HOMEPATH\.config -Name WakeOnLan -ErrorAction SilentlyContinue
    Move-Item -Path $env:HOMEPATH\Downloads\targetsList.json -Destination $env:HOMEPATH\.config\WakeOnLan\
    ```
4. Edit the JSON file to match your configuration

## Usage
To run the script, open PowerShell in any terminal and type:

```powershell
.\path\to\script\Send-MagicPacket.ps1
```

The script will then prompt the user to choose the MAC address of the target machine:

```
List of known hosts:

[0]> AB-C1-D2-E3-EF-F9   Friendly Name:  Example PC #1
[1]> BC-D9-E8-F7-EF-A1   Friendly Name:  Example PC #2
[2]> User-defined

Choose target of Magic Packet:
```

By pressing `0` (or `1`) and then the `Enter` key, a WOL packet will be sent to the Example PC #1 (or #2).
If the input is `2`, the script will prompt the user to insert a MAC address of their choosing. The address'
bytes may be separated using `-` or `:`.
