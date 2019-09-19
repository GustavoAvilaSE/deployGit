@echo off

REM *******************************************************************************************
REM Deploy integrations routines on premise
REM
REM Copyright 2019 -  All rights reserved.
REM *******************************************************************************************

REM *** ASK GITHUB REPOSITORY NAME ***
REM SET /P GITHUB_REPOSITORY_NAME=GITHUB REPOSITORY NAME:
SET GIT_DISPLAY_NAME=testRepo
SET GIT_EMAIL=gustavo.avila@softexpert.com

setlocal
set ROOT_FOLDER=%~dp0
set SOURCE_FOLDER=%~dp0source

cd /D %SOURCE_FOLDER%
SET REPO_EXIST= 0
REM setlocal EnableDelayedExpansion

for /r "%SOURCE_FOLDER%" %%x in (.) do (
    echo %%x| find ".git" >  nul
    if errorlevel 1 (
        SET REPO_EXIST=1 
        goto :break     
     )
)
:break

REM *** VERIFIES IF IS A NEW REPOSITORY OR AN EXISTING ONE ***
IF /I %REPO_EXIST% EQU 1 (
    REM *** CREATE LOCAL REPOSITORY AND ASOCIATE IT A REMOTE GITHUB REPOSITORY ***
    git init 
    git config --local user.name %GIT_DISPLAY_NAME%
    git config --local user.email %GIT_EMAIL%
    REM git remote add origin  https://github.com/SoftExpertIntegrations/%GITHUB_REPOSITORY_NAME%  *** -> REAL ORGANIZATION
    REM git remote add origin  https://github.com/SoftExpertIntegrations/%GITHUB_REPOSITORY_NAME% 
    git remote add origin https://github.com/GustavoAvilaSE/testRepo
    git pull origin master
    REM git config --local credential.helper "store --file %~dp0/deploy/config/gitcredential"
    git add .
    git commit -m "Initial Upload from Consultor Workstation"
    git push origin master
) ELSE (
    REM *** MAKE A PULL, ADD AND COMMIT FORM LOCAL REPOSITORY TO A REMOTE GITHUB REPOSITORY ***   
    git config --local user.name %GIT_DISPLAY_NAME%
    git config --local user.email %GIT_EMAIL%
    git pull origin master
    git add .
    git commit -m "Update sources from Consultor Workstation"
    git push origin master)
