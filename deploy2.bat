@echo off

REM *******************************************************************************************
REM Deploy integrations routines on premise
REM
REM Copyright 2019 -  All rights reserved.
REM *******************************************************************************************

REM *** ASK GITHUB REPOSITORY NAME ***
SET /P GITHUB_REPOSITORY_NAME=GITHUB REPOSITORY NAME:
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

IF EXIST %REPOSITORY_FOLDER% (
    IF EXIST %REPOSITORY_FOLDER%\.git ( 
    rem for /r "%ROOT_FOLDER%\%GITHUB_REPOSITORY_NAME%" %%x in (.) do (
    rem    echo %%x | find ".git" >  nul
    rem    if errorlevel 0 (
            SET REPO_EXIST=1 
            rem goto :break     
    rem    )
    )
 )
:break
 

REM *** VERIFIES IF IS A NEW REPOSITORY OR AN EXISTING ONE ***
git config --local user.name %GIT_DISPLAY_NAME%
git config --local user.email %GIT_EMAIL%
IF /I %REPO_EXIST% EQU 1 (

    REM *** CREATE A README.md FILE INSIDE EACH REPOSITORY FOLDER ***
    FOR /R %%a IN (.) DO ( 
        IF /I %%a NEQ  %REPOSITORY_FOLDER%\. (
        pushd %%a
        echo # Documentation Main page > README.md
        popd
        )
    )

    REM *** CREATE LOCAL REPOSITORY AND ASOCIATE IT A REMOTE GITHUB REPOSITORY ***
    git init 
    git remote add origin  https://github.com/SoftExpertIntegrations/%GITHUB_REPOSITORY_NAME% 
    git pull origin master
    git add .
    git commit -m "Initial Upload from On Premise server"
    git push origin master
) ELSE (
    REM *** MAKE A PULL, ADD AND COMMIT FORM LOCAL REPOSITORY TO A REMOTE GITHUB REPOSITORY ***   
    git pull origin master
    git add .
    git commit -m "Update sources from On Premise server"
    git push origin master)

REM *** START CARTE SERVICE AND DEPLOY JOBS ON PREMISE ***
setlocal
pushd %~dp0

REM set LOG_FILE=%~dp0/logs/deploy.log
REM start "starting up carte" Carte.bat 127.0.0.1 8080 
REM timeout 30 

REM *** ROUTINE TO RUN ALL Start.kjb ON THE REPOSITORY ***
REM set ROOT_FOLDER=%~dp0repository
cd /D %REPOSITORY_FOLDER%
SET REPLACE_FOLDER=%~dp0deploy
setlocal EnableDelayedExpansion

for /r " %REPOSITORY_FOLDER%" %%x in (Start.kjb) do (
    echo %%x|find ".git" >  nul
    if errorlevel 1 (        
        echo %%x >> %REPLACE_FOLDER%\tmpRoutes.txt
   )
)
call %REPLACE_FOLDER%\replace "\" "/" %REPLACE_FOLDER%\tmpRoutes.txt

for /f %%x in (%REPLACE_FOLDER%\tmpRoutes.txt) do (
    echo "curl -X GET -H "Content-Type: application/json"  -u cluster:cluster http://127.0.0.1:8080/kettle/executeJob/?job=%%x"
    REM curl -X GET -H "Content-Type: application/json"  -u cluster:cluster http://127.0.0.1:8080/kettle/executeJob/?job=%%x >> %LOG_FILE%    
)
del /q %REPLACE_FOLDER%\tmpRoutes.txt
REM ***********************************************************************************************************

REM set RUN_JOB=D:/ferramentas/Pentaho/data-integration/repository
REM curl -X GET -H "Content-Type: application/json"  -u cluster:cluster http://127.0.0.1:8080/kettle/executeJob/?job=%RUN_JOB%/cadastroUsuarios/Start.kjb >> %LOG_FILE%
REM curl -X GET -H "Content-Type: application/json"  -u cluster:cluster http://127.0.0.1:8080/kettle/executeJob/?job=%RUN_JOB%/sapAccess/Start.kjb >> %LOG_FILE%
REM curl -X GET -H "Content-Type: application/json"  -u cluster:cluster http://127.0.0.1:8080/kettle/executeJob/?job=%RUN_JOB%/soapAccess/Start.kjb >> %LOG_FILE%
