@echo off
echo ========================================
echo DIRECT TOMCAT START
echo ========================================
echo.
echo Switching to Tomcat directory...
cd /d "C:\apache-tomcat-9.0.113\bin"
echo.
echo Current directory: %CD%
echo.
echo Starting Tomcat server...
echo.
echo IMPORTANT: Keep this window open!
echo Tomcat will run in this window.
echo.
echo When you see "Server startup in [XXXX] ms"
echo then Tomcat is ready.
echo.
echo Access your application at:
echo http://localhost:8080/incident-reporting-system
echo.
echo ========================================
echo TOMCAT OUTPUT:
echo ========================================
catalina.bat run
