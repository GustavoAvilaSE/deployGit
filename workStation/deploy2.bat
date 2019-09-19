@echo off

REM *******************************************************************************************
REM Deploy integrations routines on premise
REM
REM Copyright 2019 -  All rights reserved.
REM *******************************************************************************************

REM *** ASK GITHUB REPOSITORY NAME ***
REM SET /P GITHUB_REPOSITORY_NAME=GITHUB REPOSITORY NAME:
REM SET /P GITHUB_REPOSITORY_NAME=INSERT REPOSITORY NAME
SET /P GITHUB_REPOSITORY_NAME=gustavo.avila
SET GIT_DISPLAY_NAME=%GITHUB_REPOSITORY_NAME%
SET GIT_EMAIL=gustavo.avila@softexpert.com

setlocal
set ROOT_FOLDER=%~dp0repository
set REPOSITORY_FOLDER=%ROOT_FOLDER%\%GITHUB_REPOSITORY_NAME%
cd /D %ROOT_FOLDER%

SET REPO_EXIST= 0
SET FLAG=0
REM setlocal EnableDelayedExpansion
ECHO %ROOT_FOLDER%\%GITHUB_REPOSITORY_NAME%

REM IF EXIST %REPOSITORY_FOLDER% (
REM     IF EXIST %REPOSITORY_FOLDER%\.git ( 
    IF EXIST %ROOT_FOLDER%\.git (     
    rem for /r "%ROOT_FOLDER%\%GITHUB_REPOSITORY_NAME%" %%x in (.) do (
    rem    echo %%x | find ".git" >  nul
    rem    if errorlevel 0 (
            SET REPO_EXIST=1 
            goto :break     
    rem    )
    )
REM  )
:break
 

REM *** VERIFIES IF IS A NEW REPOSITORY OR AN EXISTING ONE ***
REM git config --local user.name %GIT_DISPLAY_NAME%
REM git config --local user.email %GIT_EMAIL%
REM IF /I %REPO_EXIST% EQU 1 (

    REM *** CREATE A README.md FILE INSIDE EACH REPOSITORY FOLDER *** -- COULD BE DELETED AND FORCE ALL CONSULTANTS TO WRITE A README.MD FILE
REM     FOR /R %%a IN (.) DO ( 
REM       IF /I %%a NEQ  %REPOSITORY_FOLDER%\. (
REM         pushd %%a
REM         echo # Documentation Main page > README.md
REM         popd
REM         )
REM     )

    REM *** CREATE LOCAL REPOSITORY AND ASOCIATE IT A REMOTE GITHUB REPOSITORY ***
REM     git init 
REM     git remote add origin  https://github.com/SoftExpertIntegrations/%GITHUB_REPOSITORY_NAME% 
REM     git pull origin master
REM     git add .
REM     git commit -m "Initial Upload from On Premise server"
REM     git push origin master
REM ) ELSE (
    REM *** MAKE A PULL, ADD AND COMMIT FORM LOCAL REPOSITORY TO A REMOTE GITHUB REPOSITORY ***   
REM     git pull origin master
REM     git add .
REM     git commit -m "Update sources from On Premise server"
REM     git push origin master)

REM *** START CARTE SERVICE AND DEPLOY JOBS ON PREMISE *** --- COULD BE DELETES IF THE START/STOP OF CARTE SERVICE WILL BE RESPOSABILITE OF INGRASTRUCTURE
REM setlocal
REM pushd %~dp0

set LOG_FILE=%~dp0/logs/deploy.log
REM start "starting up carte" Carte.bat 127.0.0.1 8080 
REM timeout 30 

REM *** ROUTINE TO RUN ALL Start.kjb ON THE REPOSITORY ***
REM set ROOT_FOLDER=%~dp0repository
REM cd /D %REPOSITORY_FOLDER%
SET REPLACE_FOLDER=%~dp0deploy
setlocal EnableDelayedExpansion

for /r " %ROOT_FOLDER%" %%x in (Start.kjb) do (
    echo %%x|find ".git" >  nul
    if errorlevel 1 (        
        echo %%x >> %REPLACE_FOLDER%\tmpRoutes.txt
   )
)
call %REPLACE_FOLDER%\replace "\" "/" %REPLACE_FOLDER%\tmpRoutes.txt

for /f %%x in (%REPLACE_FOLDER%\tmpRoutes.txt) do (

    REM echo "curl -X GET -H "Content-Type: application/json"  -u cluster:cluster http://127.0.0.1:8080/kettle/executeJob/?job=%%x"
    curl -X GET -H "Content-Type: application/json"  -u cluster:cluster http://127.0.0.1:8080/kettle/executeJob/?job=%%x >> %LOG_FILE%    
    if errorlevel 1 (        
        ECHO DEPLOY ERROR, VERIFY deploy.log FILE
   )        
) >> %~dp0/logs/execution.log
del /q %REPLACE_FOLDER%\tmpRoutes.txt
REM ***********************************************************************************************************

REM *** TRY CATCH ***
REM %@Try%
REM %@EndTry%
REM :@Catch
REM :@EndCatch