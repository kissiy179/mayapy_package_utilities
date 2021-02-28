@echo off
chcp 65001
cd /d %~dp0

@REM 親ディレクトリ名を取得
set DIR_PATH=%cd%\
for %%1 in ("%DIR_PATH:~0,-1%") do set DIR_NAME=%%~nx1

@REM シンボリックリンク作成
set DST=%cd%\..\.git\modules\%DIR_NAME%\hooks\post-merge
set SRC= %cd%\parent_githooks\post-merge
echo %DST%
mklink %DST% %SRC%

pause