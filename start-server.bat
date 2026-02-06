@echo off
title Tomcat Server - Incident Reporting System
color 0A

set TOMCAT_HOME=C:\apache-tomcat-9.0.113
set CATALINA_HOME=%TOMCAT_HOME%
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_202

echo ========================================
echo     TOMCAT SERVER STARTUP
echo ========================================
echo.
echo Java Home:   %JAVA_HOME%
echo Tomcat Home: %TOMCAT_HOME%
echo.
echo ========================================
echo.

:: Check if Java is installed
if not exist "%JAVA_HOME%\bin\java.exe" (
    echo ERROR: Java not found at %JAVA_HOME%
    echo Please update JAVA_HOME in this file
    echo.
    pause
    exit /b 1
)

:: Check if Tomcat exists
if not exist "%TOMCAT_HOME%\bin\startup.bat" (
    echo ERROR: Tomcat not found at %TOMCAT_HOME%
    echo.
    echo Searching for Tomcat...
    for /f "delims=" %%i in ('dir /b /ad "C:\*tomcat*" 2^>nul') do (
        echo Found: C:\%%i
    )
    echo.
    pause
    exit /b 1
)

:: Check if port 8080 is free
echo Checking port 8080...
netstat -ano | findstr :8080 >nul
if not errorlevel 1 (
    echo ERROR: Port 8080 is already in use!
    echo.
    echo Do you want to stop the existing Tomcat? (Y/N)
    set /p stopchoice=
    if /i "%stopchoice%"=="Y" (
        echo Stopping existing Tomcat...
        call "%TOMCAT_HOME%\bin\shutdown.bat"
        timeout /t 5 /nobreak >nul
    ) else (
        echo Cannot start Tomcat. Port 8080 is busy.
        pause
        exit /b 1
    )
)

echo.
echo ========================================
echo STARTING TOMCAT SERVER...
echo ========================================
echo.

:: Set environment variables
set PATH=%JAVA_HOME%\bin;%PATH%
set CATALINA_HOME=%TOMCAT_HOME%

:: Start Tomcat
cd /d "%CATALINA_HOME%\bin"
start "Tomcat Server" cmd /k "catalina.bat run"

echo.
echo ========================================
echo TOMCAT IS STARTING...
echo ========================================
echo.
echo Server started in a new window.
echo.
echo Please wait 30 seconds for full startup.
echo.
echo THEN open browser to:
echo.
echo   ?? http://localhost:8080/incident-reporting-system
echo.
echo Login with:
echo   ?? Admin:    admin / admin123
echo   ?? Officer:  officer / officer123
echo   ?? Citizen:  citizen / citizen123
echo.
echo ========================================
echo.
echo This window will close in 10 seconds...
timeout /t 10 /nobreak >nul
