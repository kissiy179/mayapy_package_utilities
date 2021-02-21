@echo off

@REM カレントディレクトリを呼び出し元に設定（管理者権限で実行した際のへの対応）
cd /d %~dp0

@REM 遅延環境変数有効
setlocal EnableDelayedExpansion

@REM 親ディレクトリ名を取得
set DIR_PATH=%cd%\
for %%1 in ("%DIR_PATH:~0,-1%") do set DIR_NAME=%%~nx1

@REM パッケージ名を取得
set DIR_PATH=%cd%\..\
for %%1 in ("%DIR_PATH:~0,-1%") do set PACKAGE_NAME=%%~nx1

@REM pythonが使うエンコードを指定
set PYTHONIOENCODING=utf-8

@REM ライブラリインストールパスを取得
set LIB_PATH=%1
set UPGRADE=

@REM インストールパスが取得できない場合デフォルトパスにする & アップグレードオプションON
if "%LIB_PATH%"=="" (
    set LIB_PATH=..\Lib\site-packages
    set UPGRADE=--upgrade
)

@REM ------- githookをを登録 -------------------------
echo %cd%\..\.git\modules\%DIR_NAME%\hooks\post-merge
echo %cd%\parent_githooks\post-merge
mklink %cd%\..\.git\modules\%DIR_NAME%\hooks\post-merge %cd%\parent_githooks\post-merge

@REM ------- レジストリからMayaインストールフォルダ検索 -------------------------
set MAYA_APP_PATH=null

for /l %%v in (2030, -1, 2015) do (
    FOR /F "TOKENS=1,2,*" %%I IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Autodesk\Maya\%%v\Setup\InstallPath" /v "MAYA_INSTALL_LOCATION"') DO IF "%%I"=="MAYA_INSTALL_LOCATION" SET MAYA_APP_PATH=%%K

    if not !MAYA_APP_PATH!==null goto install_pip
)

@REM Mayaが見つからなければ例外処理に移動
goto except

@REM ------- pipインストール -------------------------
:install_pip
@REM mayapyのパスを取得
set MAYAPY_PATH="%MAYA_APP_PATH%bin\mayapy.exe"

@REM pipがインストールされているか確認
call %MAYAPY_PATH% -m pip -V

@REM インストールされてなければインストール、されていればアップデート
if not %errorlevel%==0 (
    curl https://bootstrap.pypa.io/2.7/get-pip.py | %MAYAPY_PATH%
) else (
    call %MAYAPY_PATH% -m pip install --upgrade pip
)

@REM ------- パッケージインストール -------------------------
call %MAYAPY_PATH% -m pip install %UPGRADE% -r ..\requirements.txt -t %LIB_PATH% --use-feature=2020-resolver

echo ==============================================================================
echo  Complete setup of %PACKAGE_NAME%.
echo ==============================================================================
goto end

@REM Mayaインストールされてない場合の例外処理
:except
echo Maya is not installed.

:end
pause
