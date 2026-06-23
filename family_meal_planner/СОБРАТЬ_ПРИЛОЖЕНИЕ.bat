@echo off
chcp 65001 >nul
title Сборка Easily Kitchen
color 0A

echo.
echo  ╔══════════════════════════════════════╗
echo  ║     Сборка Easily Kitchen            ║
echo  ╚══════════════════════════════════════╝
echo.

:: Переходим в папку проекта (там, где лежит этот файл)
cd /d "%~dp0"
echo  Папка проекта: %~dp0
echo.

:: Проверяем что Flutter доступен
echo  Проверка Flutter...
flutter --version
if %errorlevel% neq 0 (
    echo.
    echo  ══════════════════════════════════════════
    echo  ОШИБКА: Flutter не найден!
    echo.
    echo  Попробуй запустить эту же команду
    echo  через терминал VS Code или Android Studio
    echo  (там Flutter в PATH).
    echo.
    echo  Или укажи путь к flutter вручную:
    echo  Например: C:\flutter\bin\flutter --version
    echo  ══════════════════════════════════════════
    pause
    exit /b 1
)

echo.
echo [1/3] Загрузка зависимостей...
call flutter pub get
if %errorlevel% neq 0 (
    echo.
    echo  ОШИБКА на шаге flutter pub get
    pause
    exit /b 1
)

echo.
echo [2/3] Генерация иконок...
call dart run flutter_launcher_icons
if %errorlevel% neq 0 (
    echo  Предупреждение: иконки не обновились, продолжаем...
)

echo.
echo [3/3] Сборка Release-версии (1-3 минуты)...
call flutter build windows --release
if %errorlevel% neq 0 (
    echo.
    echo  ОШИБКА при сборке. Проверь вывод выше.
    pause
    exit /b 1
)

echo.
echo  ╔═══════════════════════════════════════╗
echo  ║   ГОТОВО! Теперь открой УСТАНОВЩИК   ║
echo  ║   .iss в Inno Setup и нажми F9        ║
echo  ╚═══════════════════════════════════════╝
echo.

explorer "build\windows\x64\runner\Release"
pause
