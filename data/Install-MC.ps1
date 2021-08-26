<#

Script to assist in installing the correct components to join the modded LOAF Minecraft server.

It does require user interaction where the 3rd-party files don't appear to have any silent functions.

Written by Craig Webster

#>

#Parameters
param ([switch] $ForgeOnly=$false)

#Variables
$MCLauncher = "C:\Program Files (x86)\Minecraft Launcher\MinecraftLauncher.exe"
$MCInstallerPath = ".\packages\MinecraftInstaller.msi"
$MCDownload = "https://launcher.mojang.com/download/MinecraftInstaller.msi"
$MCVer = "1.12.2"

$ForgeDownload = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.12.2-14.23.5.2855/forge-1.12.2-14.23.5.2855-installer.jar"
$ForgePath = ".\packages\forge-1.12.2-14.23.5.2855-installer.jar"

$ModsSourcePath = ".\packages\Mods"
$ModsInstallPath = "$env:APPDATA\.minecraft\mods\"

### Modules ###
Import-Module BitsTransfer

#Clear $Error
$Error.Clear()


### FUNCTIONS ###

function AquireFile {
    param (
        [string]$Name,
        [string]$URL,
        [string]$Output
    )
    #Check if file already exists
    If (Test-Path -Path $Output) {
        Write-Host -ForegroundColor Green ("$Name found!")
        
    } else {
        Write-Host -ForegroundColor Yellow ("$Name not found. Attempting to download now...")
        #Use BitsTransfer to download file to target directory
        Start-BitsTransfer $URL $Output -DisplayName "Downloading $Name..."  
        Write-Host -ForegroundColor Green ("Download complete!")
    }
      
}

function StartMC {
    If (Get-Process -Name MinecraftLauncher -ErrorAction SilentlyContinue) {
        Pause
    } else {
        Start-Process $MCLauncher
        Pause
    }
}

function StopMC {
    If (Get-Process -Name MinecraftLauncher -ErrorAction SilentlyContinue) {
        Stop-Process -Name MinecraftLauncher
    }      
}

function CopyMods {
    param (
        $ModList = $ModList
    )
    Write-Host -ForegroundColor Yellow ("Copying $($ModList.Count) mods...")
    foreach ($mod in $ModList) {
        Write-Host -ForegroundColor Yellow ("Copying $mod...")
        Copy-Item -Path $ModsSourcePath\$mod -Destination $ModsInstallPath -Force
    }
    
}


### MAIN SCRIPT ###

#Install base Minecraft game
AquireFile -Name 'Minecraft' -URL $MCDownload -Output $MCInstallerPath
Start-Process $MCInstallerPath -Wait

#Minecraft has to be launched for it to full populate the %appdata%\.minecraft directory    
Write-Host -BackgroundColor Yellow -ForegroundColor Red `
("Start the Minecraft Launcher and finish installing Minecraft.")
StartMC

#Install Forge
StopMC
AquireFile -Name "Forge $MCVer" -URL $ForgeDownload -Output $ForgePath
Start-Process $ForgePath -Wait
Write-Host -BackgroundColor Yellow -ForegroundColor Red `
("Go ahead and launch the game, then come back to this to continue :)`nMake sure you launch Forge")
StartMC
StopMC

### Mods to be installed below ###

If (!$ForgeOnly) {
    $ModList = Get-ChildItem $ModsSourcePath -Filter *.jar | Select-Object Name
    $ModList = $ModList.Name
    $exitMenuLoop=$false


    Write-Host ("Installing mods...")
    CopyMods -ModList $ModList
    }
    
Write-Host -ForegroundColor Green ("INSTALLATION COMPLETE! :)")