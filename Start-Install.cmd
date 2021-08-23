@echo off
echo Starting Installation script...
cd .\data
powershell -ExecutionPolicy Unrestricted -NoLogo -File .\Install-MC.ps1
echo DONE!
pause