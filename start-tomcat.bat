@echo off
echo ========================================
echo Starting Apache Tomcat 9.0
echo ========================================
echo.

set TOMCAT_HOME=C:\apache-tomcat-9.0.113
set CATALINA_HOME=%TOMCAT_HOME%

if not exist "%TOMCAT_HOME%\bin\startup.bat" (
    echo ERROR: Tomcat not found at %TOMCAT_HOME%
    echo.
    echo Searching for Tomcat...
    dir C:\*tomcat* /ad /b 2>nul
    echo.
    echo Please update TOMCAT_HOME in this file
    pause
    exit /b 1
)

echo Tomcat directory: %TOMCAT_HOME%
echo CATALINA_HOME: %CATALINA_HOME%
echo.

echo Checking if Tomcat is already running...
netstat -ano | findstr :8080 >nul
if %errorlevel% equ 0 (
    echo Port 8080 is in use! Tomcat may already be running.
    echo.
    echo To stop Tomcat: net stop Tomcat9
    echo OR: "%TOMCAT_HOME%\bin\shutdown.bat"
    pause
    exit /b 1
)

echo Starting Tomcat...
echo.
cd /d "%TOMCAT_HOME%\bin"
call startup.bat

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Failed to start Tomcat!
    echo Check CATALINA_HOME environment variable
    pause
    exit /b 1
)

echo.
echo ========================================
echo Tomcat started successfully!
echo ========================================
echo.
echo Access Tomcat at: http://localhost:8080
echo.
echo Access your application at:
echo http://localhost:8080/incident-reporting-system
echo.
echo ? IMPORTANT: Keep this window open!
echo Tomcat will stop if you close this window.
echo.
echo Press Ctrl+C to stop Tomcat
echo.
pause >nul
