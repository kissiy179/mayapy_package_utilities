@echo off
chcp 65001
cd /d %~dp0

@REM ------------------------------------------------------------
@REM 親パッケージのsetup.pyにパッケージ名を適用して上書きする
@REM ------------------------------------------------------------

@REM パッケージ名を取得
set DIR_PATH=%cd%\..\
for %%1 in ("%DIR_PATH:~0,-1%") do set PACKAGE_NAME=%%~nx1

@REM 置換文字指定
set BEFORE_STRING={__PACKAGE_NAME__}
set AFTER_STRING=%PACKAGE_NAME%

@REM テンプレート/コピー先ファイル指定
set INPUT_FILE=setup.py
set OUTPUT_FILE=..\setup.py

@REM コピー先をいったん削除
del %OUTPUT_FILE%

REM テンプレートにパッケージ名を適用して保存
setlocal enabledelayedexpansion
for /f "delims=" %%a in (%INPUT_FILE%) do (
set line=%%a
echo !line:%BEFORE_STRING%=%AFTER_STRING%!>>%OUTPUT_FILE%
)

pause