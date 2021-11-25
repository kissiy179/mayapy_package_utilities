@echo off

REM Enable lazy environment variable setting.
setlocal EnableDelayedExpansion

@REM Prevent the generation of .pyc files
Set PYTHONDONTWRITEBYTECODE=1

@REM Add the current directory to MAYA_MODULE_PATH.
cd /d %~dp0\..\
Set MAYA_MODULE_PATH=%cd%;%MAYA_MODULE_PATH%

@REM Get the arguments.
Set LANGUAGE=%1
Set MAYA_VER=%2
Set PYTHON_VER=%3

if "!PYTHON_VER!"=="" (
    Set PYTHON_VER=2
)

@REM ------- Find the Maya installation folder -------------------------
Set MAYA_APP_PATH=null
Set MAYA_MAX_VER=2022
Set MAYA_MIN_VER=2015

@REM If MAYA_VER is specified, set the search limit to the specified version.
if not "!MAYA_VER!"=="" (
    Set MAYA_MAX_VER=%MAYA_VER%
)

@REM Search the registry for all Maya installation folders, and if found, move to the execution process.
for /l %%v in (%MAYA_MAX_VER%, -1, %MAYA_MIN_VER%) do (
    FOR /F "TOKENS=1,2,*" %%I IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Autodesk\Maya\%%v\Setup\InstallPath" /v "MAYA_INSTALL_LOCATION"') DO IF "%%I"=="MAYA_INSTALL_LOCATION" SET MAYA_APP_PATH=%%K

    if not !MAYA_APP_PATH!==null goto execute
)
goto except

@REM ------- Execute Maya -------------------------
:execute
@REM Language setting(en_US or ja_JP)
Set MAYA_UI_LANGUAGE=%LANGUAGE%

@REM Python version setting
Set MAYA_PYTHON_VERSION=%PYTHON_VER%

@REM Execute Maya
start "" "%MAYA_APP_PATH%\bin\maya.exe"
goto end

@REM ------- Exception handling when not installed. -------------------------
:except
echo Maya is not installed.
pause

:end
