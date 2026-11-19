@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "PZROOT=C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid"
if not exist "%PZROOT%\media\scripts\vehicles" (
 set /p PZROOT=Enter Project Zomboid game directory: 
)
if not exist "%PZROOT%\media\scripts\vehicles" (
 echo ERROR: Cannot find game vehicle scripts.
 pause
 exit /b 1
)
set "MODROOT=%~dp0Workshop\MoreLifeVehicles\Contents\mods\MoreLifeVehicles\42"
py -3 tools\prepare_vehicle.py "%PZROOT%" "%MODROOT%"
if errorlevel 1 (
 echo Generator failed. Original game files unchanged.
 pause
 exit /b 1
)
echo Candidate prepared; NOT approved for public multiplayer.
pause
