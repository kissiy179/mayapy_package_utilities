@echo off

REM 遅延環境変数有効
setlocal EnableDelayedExpansion

@REM .pycファイルを生成しない
Set PYTHONDONTWRITEBYTECODE=1

@REM MAYA_MODULE_PATHにカレントディレクトリを追加
cd /d %~dp0\..\
Set MAYA_MODULE_PATH=%cd%;%MAYA_MODULE_PATH%

@REM 引数を取得
Set LANGUAGE=%1
Set MAYA_VER=%2

@REM ------- Mayaインストールフォルダを検索 -------------------------
Set MAYA_APP_PATH=null
Set MAYA_MAX_VER=2020
Set MAYA_MIN_VER=2015

@REM バージョン指定があった場合検索上限を指定バージョンにする
if not "!MAYA_VER!"=="" (
    Set MAYA_MAX_VER=%MAYA_VER%
)

@REM レジストリから全Mayaインストールフォルダを検索して見つかったら実行処理へ移動
for /l %%v in (%MAYA_MAX_VER%, -1, %MAYA_MIN_VER%) do (
    FOR /F "TOKENS=1,2,*" %%I IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Autodesk\Maya\%%v\Setup\InstallPath" /v "MAYA_INSTALL_LOCATION"') DO IF "%%I"=="MAYA_INSTALL_LOCATION" SET MAYA_APP_PATH=%%K

    if not !MAYA_APP_PATH!==null goto execute
)
goto except

@REM ------- Maya実行 -------------------------
:execute
@REM 言語設定(en_US or ja_JP)
Set MAYA_UI_LANGUAGE=%LANGUAGE%

@REM Maya起動
start "" "%MAYA_APP_PATH%\bin\maya.exe"
goto end

@REM ------- インストールされてない場合の例外処理 -------------------------
:except
echo Maya is not installed.
pause

:end
