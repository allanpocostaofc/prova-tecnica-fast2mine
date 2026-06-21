*** Settings ***
Resource        ../../resources/keywords/search_keywords.robot
Resource        ../../resources/config/suite_setup.robot

Suite Setup     Suite Setup Actions
Suite Teardown    Suite Teardown Actions

Test Tags       web    busca


*** Test Cases ***
TC-WEB-001 Buscar Produto E Validar Ao Menos Um Resultado
    [Documentation]    Pesquisa o termo do ambiente na barra de busca e valida
    ...                que ao menos 1 resultado contendo o termo e exibido.
    [Tags]    TC-WEB-001    ${ENVIRONMENT_NAME}    categoria:${CATEGORY_NAME}
    # Pré-condição
    Dado Que A Home Do Site Esta Aberta Sem Overlays
    # Ação
    Quando Pesquiso Pelo Termo    ${SEARCH_TERM}
    # Assert
    Entao Vejo Ao Menos Um Resultado Contendo O Termo    ${SEARCH_TERM}
