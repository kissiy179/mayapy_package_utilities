@echo off

@REM Set the current directory as the caller (for when executed with administrator privileges).
cd /d %~dp0

REM Enable lazy environment variable setting.
setlocal EnableDelayedExpansion

@REM Get parent directory name.
set DIR_PATH=%cd%\
for %%1 in ("%DIR_PATH:~0,-1%") do set DIR_NAME=%%~nx1

@REM Get package name.
set DIR_PATH=%cd%\..\
for %%1 in ("%DIR_PATH:~0,-1%") do set PACKAGE_NAME=%%~nx1

@REM Specify the encoding used by python.
set PYTHONIOENCODING=utf-8

@REM Get library installation path.
set LIB_PATH=%1
set UPGRADE=

@REM Use default path if installation path cannot be obtained and enable upgrade option.
if "%LIB_PATH%"=="" (
    set LIB_PATH=..\Lib\site-packages
    set UPGRADE=--upgrade
)

@REM ------- Copy setup.py to parent package.
echo | call copy_setup_py.jse

@REM ------- Register githooks -------------------------
echo | call link_githooks

@REM ------- Find the Maya installation folder(Only Python2) -------------------------
Set MAYA_APP_PATH=null
Set MAYA_MAX_VER=2020
Set MAYA_MIN_VER=2015

@REM Search the registry for all Maya installation folders, and if found, move to the execution process.
for /l %%v in (%MAYA_MAX_VER%, -1, %MAYA_MIN_VER%) do (
    FOR /F "TOKENS=1,2,*" %%I IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Autodesk\Maya\%%v\Setup\InstallPath" /v "MAYA_INSTALL_LOCATION"') DO IF "%%I"=="MAYA_INSTALL_LOCATION" SET MAYA_APP_PATH=%%K

    if not !MAYA_APP_PATH!==null goto install_pip
)
goto except

@REM ------- Installing pip -------------------------
:install_pip
@REM Get mayapy path.
set MAYAPY_PATH="%MAYA_APP_PATH%bin\mayapy.exe"

@REM Make sure pip is installed.
call %MAYAPY_PATH% -m pip -V

@REM Install if not installed, otherwise update it.
if not %errorlevel%==0 (
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py | %MAYAPY_PATH%
) else (
    call %MAYAPY_PATH% -m pip install --upgrade pip
)

@REM ------- Install packages -------------------------
call %MAYAPY_PATH% -m pip install %UPGRADE% -r ..\requirements.txt -t %LIB_PATH%

echo ==============================================================================
echo  Complete setup of %PACKAGE_NAME%.
echo ==============================================================================
goto end

@REM Exception handling when Maya is not installed.
:except
echo Maya is not installed.

:end
pause
