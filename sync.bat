@echo off
REM $Id$

setlocal

echo:
echo --------------------------------------
echo: 
echo Welcome to the USB Photo Sync Utility
echo:
echo --------------------------------------
echo:

REM Initialise the config flag [CONFIGSET] and config file [LOCALCONF]
REM You must name the config file .bat or .cmd to ensure Windows can execute it cleanly
set CONFIGSET=NO
set LOCALCONF=%~dp0conf\%~n0-setup.cmd

REM ===============================================================
REM Configuration section
REM ---------------------------------------------------------------
if "%LOCALCONF%"=="" goto config_help
goto config_do


:config_help
echo This is a configuration help script
echo Call from another script with first parameter being the config file name
echo This script will set the variable CONFIGSET
echo CONFIGSET=NO in the case of error or undefined configuration
echo CONFIGSET=YES in the case where configuration has been successfully read
goto config_exit


:config_do
REM handle configuration file
IF EXIST %LOCALCONF% goto config_cont

echo #
echo # The utility will take you through first-time setup.
:get_host_dir
set /p host_dir="# Enter the sync directory on the host machine: "
IF NOT EXIST %host_dir%\ (
    echo # This directory does not exist!
    goto get_host_dir
)
echo # Configuration confirmed. To change this, edit the HOST_DIR variable in ./conf/sync-setup.cmd

REM generate default setting file
REM adapt this to you needs. Here are some samples
echo REM configuration file> %LOCALCONF%
echo set HOST_DIR=%host_dir%>> %LOCALCONF%

:config_cont
call %LOCALCONF%
set CONFIGSET=YES


:config_exit
if "%CONFIGSET%"=="YES" goto config_ok
echo Configuration is not set
goto exit
:config_ok
REM ---------------------------------------------------------------
REM Configuration section ends
REM ===============================================================


echo Configuration loaded.

echo The utility will sync to this folder:
echo %HOST_DIR%
set /p DUMMY=Press ENTER to confirm and continue...

robocopy ".\Media" %HOST_DIR% /E
robocopy %HOST_DIR% ".\Media" /E


:exit
endlocal