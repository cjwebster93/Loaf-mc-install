
$MCLauncher = "C:\Program Files (x86)\Minecraft Launcher\MinecraftLauncher.exe"
$MCInstallerPath = ".\packages\MinecraftInstaller.msi"
$MCDownload = "https://launcher.mojang.com/download/MinecraftInstaller.msi"
$MCVer = "1.12.2"

$ForgeDownload = "https://maven.minecraftforge.net/net/minecraftforge/forge/1.12.2-14.23.5.2855/forge-1.12.2-14.23.5.2855-installer.jar"
$ForgePath = ".\packages\forge-1.12.2-14.23.5.2855-installer.jar"

$ModsPath = "%appdata%\.minecraft\mods"

$Error.Clear()

#Install base MineCraft game
If (Test-Path -Path $MCInstallerPath) {
    Write-Host -ForegroundColor Green ("Installer found!")
    #msiexec.exe /i .\data\packages\MinecraftInstaller.msi /qb
    Start-Process $MCInstallerPath -Wait
} else {
    Write-Host -ForegroundColor Yellow ("Minecraft Installer not found. Attempting to download now...")
    Invoke-WebRequest -Uri $MCDownload -OutFile $MCInstallerPath
    Write-Host -ForegroundColor Green ("Download complete! Launching Installer`nClick throught the installer to continue.")
    Start-Process $MCInstallerPath -Wait
}
    
Write-Host -BackgroundColor Yellow -ForegroundColor Red ("Start the Minecraft Launcher and finish installing Minecraft.")
If (Get-Process -Name MinecraftLauncher -ErrorAction SilentlyContinue) {
    Pause
} else {
    Start-Process $MCLauncher
    Pause
}

#Install Forge
If (Get-Process -Name MinecraftLauncher -ErrorAction SilentlyContinue) {
    Stop-Process -Name MinecraftLauncher
}

If (Test-Path $ForgePath) {
    Write-Host -ForegroundColor Green ("Forge installer found! Starting installer...")
    Start-Process $ForgePath -Wait
} Else {
    Write-Host -ForegroundColor Yellow ("Forge installer not found! Downloading installer...")
    Invoke-WebRequest -Uri $ForgeDownload -OutFile $ForgePath
    Write-Host -ForegroundColor Green ("Download complete! Launching Installer`nClick throught the installer to continue.")
    Start-Process $ForgePath -Wait
}

Write-Host -BackgroundColor Yellow -ForegroundColor Red ("Go ahead and launch the game, the come back to this to continue :)`nMake sure you launch Forge")
If (Get-Process -Name MinecraftLauncher -ErrorAction SilentlyContinue) {
    Pause
} else {
    Start-Process $MCLauncher
    Pause
}

