; Скрипт установщика Easily Kitchen
; Создан для Inno Setup (бесплатно): https://jrsoftware.org/isinfo.php
;
; Как использовать:
; 1. Сначала запусти СОБРАТЬ_ПРИЛОЖЕНИЕ.bat
; 2. Установи Inno Setup если ещё нет: https://jrsoftware.org/isinfo.php
; 3. Открой этот файл в Inno Setup
; 4. Нажми кнопку Compile (или F9)
; 5. Получишь файл  EasilyKitchen_Setup.exe  — отправь его мужу!

#define AppName "Easily Kitchen"
#define AppVersion "1.0"
#define AppExeName "easily_kitchen.exe"
#define AppPublisher "Easily Kitchen"
#define ReleaseDir "build\windows\x64\runner\Release"

[Setup]
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
OutputDir=dist
OutputBaseFilename=EasilyKitchen_Setup
SetupIconFile=windows\runner\resources\app_icon.ico
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
UninstallDisplayIcon={app}\{#AppExeName}
UninstallDisplayName={#AppName}

; Русский язык установщика
[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Tasks]
Name: "desktopicon"; Description: "Создать ярлык на рабочем столе"; GroupDescription: "Дополнительные значки:"; Flags: checkedonce

[Files]
; Главный exe
Source: "{#ReleaseDir}\{#AppExeName}"; DestDir: "{app}"; Flags: ignoreversion

; Все DLL рядом с exe
Source: "{#ReleaseDir}\*.dll"; DestDir: "{app}"; Flags: ignoreversion

; Папка data (ресурсы Flutter)
Source: "{#ReleaseDir}\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; Ярлык в меню Пуск
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"
; Ярлык для удаления
Name: "{group}\Удалить {#AppName}"; Filename: "{uninstallexe}"
; Ярлык на рабочем столе (если выбрано)
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: desktopicon

[Run]
; Предложить запустить приложение после установки
Filename: "{app}\{#AppExeName}"; Description: "Запустить {#AppName}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{app}"
