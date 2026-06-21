#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Erro: informe o ambiente. Uso: ./run_tests.sh <QA1|QA2|QA3>"
    exit 1
fi

ENV=$(echo "$1" | tr '[:lower:]' '[:upper:]')

case "$ENV" in
    QA1|QA2|QA3) ;;
    *)
        echo "Erro: ambiente inválido '$1'. Use QA1, QA2 ou QA3."
        exit 1
        ;;
esac

VAR_FILE="resources/variables/$(echo "$ENV" | tr '[:upper:]' '[:lower:]')_vars.py"

echo "Executando testes no ambiente: $ENV"
echo "Arquivo de variáveis: $VAR_FILE"

robot \
    --variable ENV:"$ENV" \
    --variablefile "$VAR_FILE" \
    --outputdir results \
    --name "Automacao_$ENV" \
    tests/
