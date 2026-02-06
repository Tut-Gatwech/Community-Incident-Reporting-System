@echo off
echo ========================================
echo Incident Reporting System - Build Script
echo ========================================
echo.

echo Current Directory: %CD%
echo.

rem Check for Java
java -version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Java not found!
    echo Please install Java JDK 8 or higher
    pause
    exit /b 1
)

rem Check for Maven
mvn --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Maven not found!
    echo Please install Maven from https://maven.apache.org/
    pause
    exit /b 1
)

echo Building project...
echo.

echo 1. Cleaning previous build...
call mvn clean
echo.

echo 2. Compiling source code...
call mvn compile
if errorlevel 1 (
    echo ERROR: Compilation failed!
    echo Check for syntax errors in Java files
    pause
    exit /b 1
)
echo.

echo 3. Creating WAR package...
call mvn package -DskipTests
if errorlevel 1 (
    echo ERROR: Failed to create WAR file!
    pause
    exit /b 1
)
echo.

echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo.
echo WAR file: target\incident-reporting-system.war
echo.
echo To deploy:
echo 1. Copy to Tomcat webapps folder
echo 2. Start Tomcat server
echo 3. Access: http://localhost:8080/incident-reporting-system
echo.
pause
