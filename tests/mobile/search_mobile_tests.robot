*** Settings ***
Resource        ../../resources/keywords/search_mobile_keywords.robot

Suite Setup     Open Mobile Browser
Suite Teardown    Close Application

Test Tags       mobile    busca


*** Test Cases ***
TC-MOB-001 Buscar Produto Mobile E Validar Ao Menos Um Resultado
    [Documentation]    Pesquisa o termo do ambiente no Chrome do emulador e valida
    ...                que ao menos 1 resultado contendo o termo e exibido.
    [Tags]    TC-MOB-001    ${ENVIRONMENT_NAME}    categoria:${CATEGORY_NAME}
    # Pré-condição
    Dado Que O Chrome Mobile Esta Na Home Sem Overlays
    # Ação
    Quando Pesquiso Pelo Termo No Mobile    ${SEARCH_TERM}
    # Assert
    Entao Vejo Ao Menos Um Resultado Contendo O Termo No Mobile    ${SEARCH_TERM}
