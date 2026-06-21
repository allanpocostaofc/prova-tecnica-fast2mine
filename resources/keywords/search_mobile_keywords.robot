*** Settings ***
Resource        ../pages/search_mobile_page.resource
Resource        result_assertions.resource


*** Keywords ***
Dado Que O Chrome Mobile Esta Na Home Sem Overlays
    [Documentation]    PRE-CONDICAO: garante a home carregada e sem banners/overlays
    ...                (cookie, "baixe o app", backdrop) interceptando a busca e valida
    ...                que o campo de busca esta visivel e pronto para interacao.
    Clear Home Overlays Mobile
    Wait Until Element Is Visible    ${SEL_SEARCH_INPUT}    ${TIMEOUT}

Quando Pesquiso Pelo Termo No Mobile
    [Documentation]    ACAO: pesquisa o ${term} no Chrome do emulador e aguarda a
    ...                listagem de resultados renderizar.
    [Arguments]    ${term}
    Search For Product Mobile    ${term}
    Wait For Search Results Mobile

Entao Vejo Ao Menos Um Resultado Contendo O Termo No Mobile
    [Documentation]    ASSERT: valida que ha ao menos 1 resultado e que ao menos um
    ...                titulo contem o termo pesquisado (case-insensitive).
    [Arguments]    ${term}
    ${count}=    Get Results Count Mobile
    Should Be True    ${count} > 0
    ...    msg=Nenhum resultado retornado para a busca '${term}'.
    ${titles}=    Get Result Titles Mobile
    Validate Any Title Contains    ${titles}    ${term}
