@echo off
echo ========================================
echo Deploying to Tomcat
echo ========================================
echo.

set TOMCAT_HOME=C:\apache-tomcat-9.0.113
set WAR_FILE=target\incident-reporting-system.war

if not exist "%WAR_FILE%" (
    echo ERROR: WAR file not found!
    echo Please run build.bat first.
    pause
    exit /b 1
)

if not exist "%TOMCAT_HOME%\webapps" (
    echo ERROR: Tomcat webapps directory not found at %TOMCAT_HOME%\webapps
    echo Please check your Tomcat installation path.
    pause
    exit /b 1
)

echo Copying %WAR_FILE% to %TOMCAT_HOME%\webapps...
copy /Y "%WAR_FILE%" "%TOMCAT_HOME%\webapps\"

if errorlevel 1 (
    echo ERROR: Failed to copy WAR file!
    pause
    exit /b 1
)

echo.
echo Deployment successful!
echo Tomcat should auto-deploy the change.
echo If not, please restart Tomcat using stop-tomcat.bat and start-tomcat.bat.
echo.
pause
