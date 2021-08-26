@echo off
echo Starting Installation script...
cd .\data\
set /p modsinstall="Install mods? (Y/N): "
IF %modsinstall% == N (
    powershell -ExecutionPolicy Unrestricted -NoLogo -File .\Install-MC.ps1 -ForgeOnly
) ELSE (
    powershell -ExecutionPolicy Unrestricted -NoLogo -File .\Install-MC.ps1
)
pause