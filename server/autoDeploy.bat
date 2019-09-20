@echo off

REM *******************************************************************************************
REM Deploy integrations routines on premise
REM
REM Copyright 2019 -  All rights reserved.
REM *******************************************************************************************

setlocal
set ROOT_FOLDER=%~dp0
cd /D %ROOT_FOLDER%
SET SOURCES_FOLDER=%~dp0sources
cd /D %SOURCES_FOLDER%
call config.bat
setlocal EnableDelayedExpansion

for %%x in (*) do ( echo %SOURCES_FOLDER%/%%x >> %ROOT_FOLDER%tmpRoutes.txt )
call %ROOT_FOLDER%replace "\" "/" %ROOT_FOLDER%tmpRoutes.txt
for /f %%x in (%ROOT_FOLDER%\tmpRoutes.txt) do (
   echo %%~xx
   if "%%~xx" == ".kjb" ( 
        curl -X GET -H "Content-Type: application/json"  -u %USER%:%PASS% http://%DEPLOY_ADDRESS%:%DEPLOY_PORT%/kettle/executeJob/?job=%%x  >> %ROOT_FOLDER%log\autoDeployJobs.log  
    )
    if "%%~xx" == ".ktr" (        
        curl -X GET -H "Content-Type: application/json"  -u %USER%:%PASS% http://%DEPLOY_ADDRESS%:%DEPLOY_PORT%/kettle/executeTrans/?trans=%%x >> %ROOT_FOLDER%log\autoDeployTrans.log  
    )        
)
cd /D %ROOT_FOLDER%
del %ROOT_FOLDER%tmpRoutes.txt