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

set /a jobs_to_register=0
set /a kjb_linea=1
set value="<job_configuration>"
for /f "delims=" %%i IN (%value%) DO SET openJ=%%i
set value2= "<job_execution_configuration> <log_level>BASIC</log_level> <safe_mode>N</safe_mode> </job_execution_configuration> </job_configuration>"
for /f "delims=" %%i in (%value2%) DO SET closeJ=%%i

set /a trans_to_register=0
set /a ktr_linea=1 
set value="<transformation_configuration>"
for /f "delims=" %%i IN (%value%) DO SET openT=%%i
set value2= "<transformation_execution_configuration> <log_level>BASIC</log_level> <safe_mode>N</safe_mode> </transformation_execution_configuration> </transformation_configuration>"
for /f "delims=" %%i in (%value2%) DO SET closeT=%%i

setlocal EnableDelayedExpansion
rem /*** OBTER INFORMACAO DE CONFIGURACAO DO REPOSTIORIO ***/
curl -H "Accept:application/vnd.github.v3.raw" -L https://raw.github.com/SoftExpertIntegrations/OnPremise-Config/master/client1.deploy --output client1.deploy
for /f %%x in (client1.deploy) do (
    curl -H 'Accept:application/vnd.github.v3.raw' --remote-name -L %%x 
)


for /r "%ROOT_FOLDER%" %%x in (*) do (

    echo %%x|find ".git" >  nul
    if errorlevel 1 (     
                    
        if "%%~xx" == ".kjb" (          
             set /a jobs_to_register=%jobs_to_register%+1
             echo  !jobs_to_register!
             for /f "delims=·" %%a in (%%x) do (
            
                rem echo %%a >> !ROOT_FODER!job%jobs_to_register%.xml
                echo %%a >> !ROOT_FODER!job.xml
                rem echo %%a 
                if /I !kjb_linea! EQU 1 (echo !openJ! >> !ROOT_FODER!job.xml)
                rem  if /I !kjb_linea! EQU 1 (echo !openJ!)
                 set  /a kjb_linea=!kjb_linea!+1
                 rem echo !kjb_linea!
            ) 
            rem echo !closeJ! >> !ROOT_FODER!job%jobs_to_register%.xml
            echo !closeJ! >> !ROOT_FODER!job.xml
            rem /*** REGISTRO DO JOB NO CARTE SERVER ***/ *********************SACAR HACER DESPUÉS DEL RECORRIDO ************************
            rem curl -X POST -H "Content-Type: application/json"  -u cluster:cluster -d @job.xml http://192.168.56.1:8088/kettle/registerJob/?xml=Y >> autoDeployJobs.log
            rem curl -X POST -H "Content-Type: application/json"  -u cluster:cluster -d @job%jobs_to_register%.xml http://127.0.0.1:8080/kettle/registerJob/?xml=Y >> autoDeployJobs.log
            rem del !ROOT_FODER!job.xml
        )
     
        if "%%~xx" == ".ktr" (    
            set /a trans_to_register=!trans_to_register!+1
            echo !trans_to_register!
            for /f "delims=·" %%a in (%%x) do (
              
                rem echo %%a >> !ROOT_FODER!trans%trans_to_register%.xml
                echo %%a >> !ROOT_FODER!trans.xml
                rem echo %%a 
                if /I !ktr_linea! EQU 1 (echo !openT! >> !ROOT_FODER!trans.xml)
                rem if /I !ktr_linea! EQU 1 (echo !openT! )
                set   /a ktr_linea=!ktr_linea!+1    
                rem echo !kjb_linea!
            ) 
            rem echo !closeT! >> !ROOT_FODER!trans%trans_to_register%.xml
            echo !closeT! >> !ROOT_FODER!trans.xml
            rem /*** REGISTRO DO TRNASFORMATION NO CARTE SERVER ***/ *********************SACAR HACER DESPUÉS DEL RECORRIDO ************************
            rem curl -X POST -H "Content-Type: application/json"  -u cluster:cluster -d @trans.xml http://192.168.56.1:8088/kettle/registerTrans/?xml=Y  >> autoDeployTrans.log
            rem curl -X POST -H "Content-Type: application/json"  -u cluster:cluster -d @trans%trans_to_register%.xml http://127.0.0.1:8080/kettle/registerTrans/?xml=Y  >> autoDeployTrans.log
            rem del !ROOT_FODER!trans.xml
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
