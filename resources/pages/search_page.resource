*** Settings ***
Resource        ../core/web_core.resource


*** Keywords ***
Dismiss Cookie Banner
    [Documentation]    Tenta fechar o banner de cookies/consentimento, se existir.
    ...                Nao falha o teste caso o banner nao esteja presente.
    Run Keyword And Ignore Error    Click    ${SEL_COOKIE_ACCEPT}

Search For Product
    [Documentation]    Preenche a barra de busca com ${term} e dispara a pesquisa
    ...                pressionando Enter, aguardando o campo ficar visivel antes.
    [Arguments]    ${term}
    Wait For Elements State    ${SEL_SEARCH_INPUT}    visible    ${TIMEOUT}
    Fill Text    ${SEL_SEARCH_INPUT}    ${term}
    Press Keys    ${SEL_SEARCH_INPUT}    Enter

Wait For Search Results
    [Documentation]    Aguarda ao menos um card de resultado ficar visivel,
    ...                garantindo que a listagem de busca foi renderizada. Usa
    ...                "nth=0" para evitar violacao de strict mode quando o
    ...                seletor casa multiplos resultados.
    Wait For Elements State    ${SEL_RESULT_ITEM} >> nth=0    visible    ${TIMEOUT}

Get Results Count
    [Documentation]    Retorna a quantidade de cards de resultado exibidos.
    ${count}=    Get Element Count    ${SEL_RESULT_ITEM}
    RETURN    ${count}

Get Result Titles
    [Documentation]    Retorna a lista de textos dos titulos dos resultados, para
    ...                validacao na camada de negocio.
    ${titles}=    Get Elements    ${SEL_RESULT_TITLE}
    ${texts}=    Create List
    FOR    ${el}    IN    @{titles}
        ${text}=    Get Text    ${el}
        Append To List    ${texts}    ${text}
    END
    RETURN    ${texts}
