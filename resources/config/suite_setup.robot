*** Settings ***
Library         String
Resource        ../core/web_core.resource


*** Keywords ***
Load Environment Configuration
    [Documentation]    Resolve o ambiente alvo a partir de ${ENV} e importa o
    ...                arquivo de variáveis correspondente. Funciona como
    ...                fallback quando o teste é executado apenas com
    ...                --variable ENV:<amb>, sem --variablefile.
    ${env_upper}=    Convert To Upper Case    ${ENV}
    Should Match Regexp    ${env_upper}    ^QA[123]$
    ...    msg=Ambiente inválido: '${ENV}'. Use QA1, QA2 ou QA3.
    Log    Ambiente carregado: ${env_upper} (arquivo: ${env_upper.lower()}_vars.py)    level=INFO

Open Application
    [Documentation]    Abre o browser (com user-agent realista), cria um
    ...                contexto/página e navega até a URL base do ambiente.
    New Browser    browser=${BROWSER}    headless=${HEADLESS}
    ...    args=['--disable-blink-features=AutomationControlled', '--start-maximized']
    New Context    viewport={'width': ${VIEWPORT_WIDTH}, 'height': ${VIEWPORT_HEIGHT}}    userAgent=${USER_AGENT}
    ...    locale=pt-BR
    Set Browser Timeout    ${TIMEOUT}
    New Page    ${BASE_URL}
    Log    Aplicação aberta em: ${BASE_URL}    level=INFO

Suite Setup Actions
    [Documentation]    Keyword de Suite Setup: carrega o ambiente e abre o site
    ...                na URL base. Sites de e-commerce não exigem login. Use em
    ...                "Suite Setup".
    Load Environment Configuration
    Open Application

Suite Teardown Actions
    [Documentation]    Keyword de Suite Teardown: encerra todos os recursos do
    ...                browser. Use em "Suite Teardown".
    Close Browser    ALL
    Log    Browser encerrado. Suíte finalizada no ambiente ${ENVIRONMENT_NAME}    level=INFO
