@echo off

REM 遅延環境変数有効
setlocal EnableDelayedExpansion

@REM .pycファイルを生成しない
Set PYTHONDONTWRITEBYTECODE=1

@REM MAYA_MODULE_PATHにカレントディレクトリを追加
cd /d %~dp0\..\
Set MAYA_MODULE_PATH=%cd%;%MAYA_MODULE_PATH%

@REM ------- Mayaインストールフォルダを検索 -------------------------
set MAYA_APP_PATH=null
Set MAYA_VER=%1

@REM 指定されたバージョンがレジストリから見つかったら実行処理へ移動
FOR /F "TOKENS=1,2,*" %%I IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Autodesk\Maya\%MAYA_VER%\Setup\InstallPath" /v "MAYA_INSTALL_LOCATION"') DO IF "%%I"=="MAYA_INSTALL_LOCATION" SET MAYA_APP_PATH=%%K

if not !MAYA_APP_PATH!==null (
    goto execute
) else (
    goto except
)

@REM レジストリから全Mayaインストールフォルダを検索して見つかったら実行処理へ移動
for /l %%v in (2020, -1, 2015) do (
    FOR /F "TOKENS=1,2,*" %%I IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Autodesk\Maya\%%v\Setup\InstallPath" /v "MAYA_INSTALL_LOCATION"') DO IF "%%I"=="MAYA_INSTALL_LOCATION" SET MAYA_APP_PATH=%%K

    if not !MAYA_APP_PATH!==null goto execute
)
goto except

@REM ------- Maya実行 -------------------------
:execute
@REM 言語設定(en_US or ja_JP)
Set LANGUAGE=%2
Set MAYA_UI_LANGUAGE=%LANGUAGE%

@REM Maya起動
start "" "%MAYA_APP_PATH%\bin\maya.exe"
goto end

@REM ------- インストールされてない場合の例外処理 -------------------------
:except
echo Maya is not installed.
pause

:end
