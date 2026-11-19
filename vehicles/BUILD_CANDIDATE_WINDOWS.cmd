@echo off
setlocal
cd /d "%~dp0"
set "GAME=C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid"
if not exist "%GAME%\media\scripts" set /p "GAME=Project Zomboid installation folder: "
if not exist "%GAME%\media\scripts" (
  echo No installed game scripts found. No files changed.
  pause
  exit /b 1
)
where py >nul 2>nul
if not errorlevel 1 (
  py -3 tools\prepare_drivable_candidate.py --game "%GAME%"
) else (
  python tools\prepare_drivable_candidate.py --game "%GAME%"
)
if errorlevel 1 (
  echo Candidate generation failed. No game installation files changed.
) else (
  echo Experimental candidate created in Workshop folder. NOT GAME TESTED.
)
pause
