@echo off

call %VSToolsDir%\VsDevCmd.bat 

if defined VSCODE_CWD (
    cd /d "%VSCODE_CWD%"
)
