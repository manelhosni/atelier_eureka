@echo off
title Lanceur de Microservices
color 0B

:MENU
cls
echo =====================================================================
echo               GESTIONNAIRE DE MICROSERVICES
echo =====================================================================
echo  1. Lancer Eureka Server (Port 8761) [REQUIS EN PREMIER]
echo  2. Lancer Candidat (Port 8081 - H2 Database)
echo  3. Lancer Canditature (Port 8085)
echo  4. Lancer Job (Port 8082 - Mode H2 sans MySQL)
echo  5. Lancer Job (Port 8082 - Mode MySQL port 3306)
echo  6. Lancer Meeting (Port 8083 - Node.js Express)
echo  7. Lancer Notification (Port 8084 - Python FastAPI)
echo  8. Lancer API Gateway (Port 9090)
echo  9. Ouvrir le Dashboard Eureka dans le navigateur
echo  10. Quitter
echo =====================================================================
set /p choix="Entrez votre choix (1-10) : "

if "%choix%"=="1" goto EUREKA
if "%choix%"=="2" goto CANDIDAT
if "%choix%"=="3" goto CANDITATURE
if "%choix%"=="4" goto JOB_H2
if "%choix%"=="5" goto JOB_MYSQL
if "%choix%"=="6" goto MEETING
if "%choix%"=="7" goto NOTIFICATION
if "%choix%"=="8" goto GATEWAY
if "%choix%"=="9" goto OPEN_EUREKA
if "%choix%"=="10" goto QUIT

echo Choix invalide.
pause
goto MENU

:EUREKA
start "Eureka Server [8761]" cmd /k "%~dp0demarrer-eureka.bat"
goto MENU

:CANDIDAT
start "Candidat [8081]" cmd /k "cd /d %~dp0codeSource_correctionProsit\backend\backend\microservices\candidat && call mvnw.cmd spring-boot:run"
goto MENU

:CANDITATURE
start "Canditature [8085]" cmd /k "cd /d %~dp0codeSource_correctionProsit\backend\backend\microservices\canditature && call mvnw.cmd spring-boot:run"
goto MENU

:JOB_H2
start "Job [8082] (H2 Dev Mode)" cmd /k "cd /d %~dp0codeSource_correctionProsit\backend\backend\microservices\job && call mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=dev"
goto MENU

:JOB_MYSQL
start "Job [8082] (MySQL Mode)" cmd /k "cd /d %~dp0codeSource_correctionProsit\backend\backend\microservices\job && call mvnw.cmd spring-boot:run"
goto MENU

:MEETING
start "Meeting [8083]" cmd /k "cd /d %~dp0codeSource_correctionProsit\backend\backend\microservices\meeting && npm start"
goto MENU

:NOTIFICATION
start "Notification [8084]" cmd /k "cd /d %~dp0codeSource_correctionProsit\backend\backend\microservices\notification && python -m uvicorn app.main:app --port 8084 --reload"
goto MENU

:GATEWAY
start "API Gateway [9090]" cmd /k "cd /d %~dp0codeSource_correctionProsit\backend\backend\gateway && call mvnw.cmd spring-boot:run"
goto MENU

:OPEN_EUREKA
start http://localhost:8761/
goto MENU

:QUIT
exit
