@echo off
cd /d "%~dp0"
start cmd /k "echo === Easily Kitchen - Terminal === && echo. && echo Current folder: %cd% && echo. && echo Run these commands one by one: && echo. && echo   flutter pub get && echo   dart run flutter_launcher_icons && echo   flutter build windows --release && echo."
