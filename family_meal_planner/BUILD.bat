@echo off
cd /d "%~dp0"
echo.
echo Building Easily Kitchen...
echo.
flutter pub get
if %errorlevel% neq 0 ( echo ERROR: flutter not found! && pause && exit /b 1 )
dart run flutter_launcher_icons
flutter build windows --release
if %errorlevel% neq 0 ( echo BUILD FAILED && pause && exit /b 1 )
echo.
echo SUCCESS! App is ready in build\windows\x64\runner\Release\
echo Now open INSTALLER.iss in Inno Setup and press F9
echo.
pause
