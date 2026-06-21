*** Settings ***
Resource        ../pages/search_page.resource
Resource        result_assertions.resource


*** Keywords ***
Dado Que A Home Do Site Esta Aberta Sem Overlays
    [Documentation]    PRE-CONDICAO: fecha o banner de cookies/consentimento (se houver)
    ...                e garante que o campo de busca esta visivel e pronto.
    Dismiss Cookie Banner
    Wait For Elements State    ${SEL_SEARCH_INPUT}    visible    ${TIMEOUT}

Quando Pesquiso Pelo Termo
    [Documentation]    ACAO: pesquisa o ${term} na barra de busca e aguarda a listagem
    ...                de resultados renderizar.
    [Arguments]    ${term}
    Search For Product    ${term}
    Wait For Search Results

Entao Vejo Ao Menos Um Resultado Contendo O Termo
    [Documentation]    ASSERT: valida que ha ao menos 1 resultado e que ao menos um
    ...                titulo contem o termo pesquisado (case-insensitive).
    [Arguments]    ${term}
    ${count}=    Get Results Count
    Should Be True    ${count} > 0
    ...    msg=Nenhum resultado retornado para a busca '${term}'.
    ${titles}=    Get Result Titles
    Validate Any Title Contains    ${titles}    ${term}
