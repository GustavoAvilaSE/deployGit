@echo off

REM *******************************************************************************************
REM Deploy integrations routines on premise
REM
REM Copyright 2019 -  All rights reserved.
REM *******************************************************************************************

REM *** ASK GITHUB REPOSITORY NAME ***
SET GITHUB_REPOSITORY_NAME=OnPremise-Config
SET GIT_DISPLAY_NAME=%GITHUB_REPOSITORY_NAME%
SET GIT_EMAIL=gustavo.avila@softexpert.com

setlocal
set ROOT_FOLDER=%~dp0
cd /D %ROOT_FOLDER%


set ktr_linea=1 



REM set LOG_FILE=%~dp0/logs/deploy.log
REM start "starting up carte" Carte.bat 127.0.0.1 8080 
REM timeout 30 

REM *** ROUTINE TO RUN ALL Start.kjb ON THE REPOSITORY ***
REM set ROOT_FOLDER=%~dp0repository

setlocal EnableDelayedExpansion
set kjb_linea=1      
set value="<job_configuration>"
for /f "delims=" %%i in (%value%) DO SET open=%%i
set value2= " <job_execution_configuration>  <log_level>BASIC</log_level>  <safe_mode>N</safe_mode> </job_execution_configuration> </job_configuration>"
for /f "delims=" %%i in (%value2%) DO SET close=%%i

REM set kjb_linea=1

REM curl -H 'Accept:application/vnd.github.v3.raw' -L https://raw.github.com/SoftExpertIntegrations/OnPremise-Config/master/client1.deploy --output client1.deploy
REM for /f %%x in (client1.deploy) do (
REM        curl -H 'Accept:application/vnd.github.v3.raw' --remote-name -L %%x 
REM )


for /r "%ROOT_FOLDER%" %%x in (*) do (

    echo %%x|find ".git" >  nul
    if errorlevel 1 (     
                    
        if "%%~xx" == ".kjb" (
            for /f "delims=·" %%a in (%%x) do (

                echo !kjb_linea!
                echo %%a
                if /i !kjb_linea! EQU 1 ( echo !open!)
                set  /a kjb_linea=!kjb_linea!+1
                echo !kjb_linea!
            ) 
            REM echo KJB 
            echo !close!
        )
     
         if "%%~xx" == ".ktr" (            
            for /f "delims=·" %%a in (%%x) do (

                REM echo %%a
            ) 
            REM echo %ktr_linea% 
        )
   )

)

REM call %REPLACE_FOLDER%\replace "\" "/" %REPLACE_FOLDER%\tmpRoutes.txt

REM for /f %%x in (%REPLACE_FOLDER%\tmpRoutes.txt) do (
    REM echo "curl -X GET -H "Content-Type: application/json"  -u cluster:cluster http://127.0.0.1:8080/kettle/executeJob/?job=%%x"
    REM curl -X GET -H "Content-Type: application/json"  -u cluster:cluster http://127.0.0.1:8080/kettle/executeJob/?job=%%x >> %LOG_FILE%    
REM )
REM del /q %REPLACE_FOLDER%\tmpRoutes.txt
REM ***********************************************************************************************************

REM set RUN_JOB=D:/ferramentas/Pentaho/data-integration/repository
REM curl -X GET -H "Content-Type: application/json"  -u cluster:cluster http://127.0.0.1:8080/kettle/executeJob/?job=%RUN_JOB%/cadastroUsuarios/Start.kjb >> %LOG_FILE%
REM curl -X GET -H "Content-Type: application/json"  -u cluster:cluster http://127.0.0.1:8080/kettle/executeJob/?job=%RUN_JOB%/sapAccess/Start.kjb >> %LOG_FILE%
REM curl -X GET -H "Content-Type: application/json"  -u cluster:cluster http://127.0.0.1:8080/kettle/executeJob/?job=%RUN_JOB%/soapAccess/Start.kjb >> %LOG_FILE%