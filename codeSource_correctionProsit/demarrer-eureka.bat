@echo off
title Eureka Discovery Server (Port 8761)
color 0A

echo =====================================================================
echo           DEMARRAGE DE EUREKA DISCOVERY SERVER (PORT 8761)
echo =====================================================================
echo.

set "JAVA_BIN="

REM 1. Verifier si JAVA_HOME existe
if defined JAVA_HOME (
    if exist "%JAVA_HOME%\bin\java.exe" set "JAVA_BIN=%JAVA_HOME%\bin\java.exe"
)

REM 2. Verifier dans le repertoire IntelliJ JDKs ou JDK local
if not defined JAVA_BIN (
    if exist "C:\jdk-17.0.12_windows-x64_bin\jdk-17.0.12\bin\java.exe" (
        set "JAVA_BIN=C:\jdk-17.0.12_windows-x64_bin\jdk-17.0.12\bin\java.exe"
    ) else if exist "C:\Users\manel\.jdks\ms-17.0.17\bin\java.exe" (
        set "JAVA_BIN=C:\Users\manel\.jdks\ms-17.0.17\bin\java.exe"
    ) else if exist "C:\Users\manel\.jdks\jbr-17.0.14\bin\java.exe" (
        set "JAVA_BIN=C:\Users\manel\.jdks\jbr-17.0.14\bin\java.exe"
    ) else if exist "C:\Users\manel\.jdks\ms-17.0.20.1\bin\java.exe" (
        set "JAVA_BIN=C:\Users\manel\.jdks\ms-17.0.20.1\bin\java.exe"
    )
)

REM 3. Fallback sur la commande standard
if not defined JAVA_BIN (
    set "JAVA_BIN=java"
)

set "EUREKA_DIR=%~dp0codeSource_correctionProsit\backend\backend\eureka-server"
if not exist "%EUREKA_DIR%" (
    set "EUREKA_DIR=%~dp0codeSource_correctionProsit\backend\backend\microservices\eureka-server"
)

set "JAR_PATH=%EUREKA_DIR%\target\eureka-server-0.0.1-SNAPSHOT.jar"

if not exist "%JAR_PATH%" (
    echo [INFO] JAR introuvable, demarrage via mvnw spring-boot:run...
    cd /d "%EUREKA_DIR%"
    call mvnw.cmd spring-boot:run
    pause
    exit /b 0
)

echo Java utilise : %JAVA_BIN%
echo.
echo URL du Dashboard Eureka : http://localhost:8761/
echo URL de registration     : http://localhost:8761/eureka
echo.
echo Appuyez sur Ctrl+C dans cette fenetre pour arreter Eureka.
echo =====================================================================
echo.

"%JAVA_BIN%" -jar "%JAR_PATH%"

pause
