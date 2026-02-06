@echo off
echo ========================================
echo Stopping Apache Tomcat 9.0
echo ========================================
echo.

set TOMCAT_HOME=C:\apache-tomcat-9.0.113

echo Stopping Tomcat service...
net stop Tomcat9 2>nul
if %errorlevel% equ 0 (
    echo ? Tomcat service stopped
) else (
    echo Tomcat service not found or already stopped
)

echo.
echo Stopping via shutdown script...
call "%TOMCAT_HOME%\bin\shutdown.bat" 2>nul

echo.
echo Checking if Tomcat is still running...
timeout /t 3 /nobreak >nul
netstat -ano | findstr :8080 >nul
if %errorlevel% equ 0 (
    echo ? Tomcat still running on port 8080
    echo.
    echo Force stopping...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080') do (
        taskkill /PID %%a /F
    )
) else (
    echo ? Tomcat stopped successfully
)

echo.
pause
