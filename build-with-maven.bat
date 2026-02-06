@echo off
echo Using Maven from: C:\apache-maven-3.8.8
"C:\apache-maven-3.8.8\bin\mvn.cmd" clean package -DskipTests
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)
echo Build successful!
pause
