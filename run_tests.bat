@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Erro: informe o ambiente. Uso: run_tests.bat ^<QA1^|QA2^|QA3^>
    exit /b 1
)

set "ENV=%~1"
set "ENV=!ENV:qa=QA!"

if /I "%~1"=="QA1" (
    set "ENV=QA1"
    set "VAR_FILE=resources\variables\qa1_vars.py"
) else if /I "%~1"=="QA2" (
    set "ENV=QA2"
    set "VAR_FILE=resources\variables\qa2_vars.py"
) else if /I "%~1"=="QA3" (
    set "ENV=QA3"
    set "VAR_FILE=resources\variables\qa3_vars.py"
) else (
    echo Erro: ambiente invalido '%~1'. Use QA1, QA2 ou QA3.
    exit /b 1
)

echo Executando testes no ambiente: %ENV%
echo Arquivo de variaveis: %VAR_FILE%

robot ^
    --variable ENV:%ENV% ^
    --variablefile %VAR_FILE% ^
    --outputdir results ^
    --name Automacao_%ENV% ^
    tests\

endlocal
