@echo off
chcp 65001
cd /d %~dp0

copy %cd%\setup.py %cd%\..\setup.py

pause