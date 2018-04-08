@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

FOR /F "tokens=1,2 delims==" %%A IN (.env) DO (
    IF "%%A"=="APP_DOCKER_IP" SET APP_DOCKER_IP=%%B
)

FOR /F "tokens=1,2 delims==" %%A IN (.env) DO (
    IF "%%A"=="APP_DOMAIN" SET APP_DOMAIN=%%B
)

FOR /F "tokens=1,2 delims==" %%A IN (.env) DO (
    IF "%%A"=="APP_ENV" SET APP_ENV=%%B
)


SET API_URL=%APP_ENV%api.%APP_DOMAIN%
SET ELK_URL=%APP_ENV%elk.%APP_DOMAIN%


FINDSTR /M "%API_URL%" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 (
  ECHO[>>%WINDIR%\System32\drivers\etc\hosts
  ECHO %APP_DOCKER_IP% %API_URL%>>%WINDIR%\System32\drivers\etc\hosts
)

FINDSTR /M "%ELK_URL%" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 (
  ECHO %APP_DOCKER_IP% %ELK_URL%>>%WINDIR%\System32\drivers\etc\hosts
)
