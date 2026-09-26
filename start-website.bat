@echo off
setlocal
rem Starts the SkyOpsHub website locally and opens it in your browser.
rem Double-click this file, or run it from a terminal. Press Ctrl+C to stop.
cd /d "%~dp0"
set PORT=5173
set URL=http://localhost:%PORT%/

echo.
echo   SkyOpsHub website  ^>  %URL%
echo   Press Ctrl+C to stop.
echo.

rem Open the browser a moment after the server starts.
start "" /b cmd /c "ping -n 3 127.0.0.1 >nul & start %URL%"

where py >nul 2>nul
if %errorlevel%==0 ( py -m http.server %PORT% --bind 127.0.0.1 & goto :eof )

where python >nul 2>nul
if %errorlevel%==0 ( python -m http.server %PORT% --bind 127.0.0.1 & goto :eof )

where npx >nul 2>nul
if %errorlevel%==0 ( npx --yes serve -l %PORT% . & goto :eof )

echo Could not find Python or Node.js on this machine.
echo Install either one, then run this file again.
pause
