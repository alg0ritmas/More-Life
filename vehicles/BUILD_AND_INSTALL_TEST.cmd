@echo off
setlocal EnableExtensions
cd /d "%~dp0"
call BUILD_CANDIDATE_WINDOWS.cmd
if not exist "Workshop\MoreLifeVehicles\Contents\mods\MoreLifeVehicles\42\media\scripts\vehicles\mlv_armoredscout_vehicle.txt" (
 echo Vehicle script not generated; nothing was installed.
 pause
 exit /b 1
)
set "DEST=%USERPROFILE%\Zomboid\mods\MoreLifeVehicles"
if exist "%DEST%" (
 echo STOP: Back up the existing MoreLifeVehicles directory before installing.
 pause
 exit /b 2
)
xcopy /I /E /Y "Workshop\MoreLifeVehicles\Contents\mods\MoreLifeVehicles" "%DEST%" >nul
if errorlevel 1 (echo Copy failed. & pause & exit /b 3)
echo Test mod installed. Create a NEW debug single-player save.
pause
