*** Settings ***
Resource        ../variables/mobile_capabilities.resource


*** Variables ***
${OVERLAY_CLEANUP_JS}    SEPARATOR=
...    var sels=['.download-app-bottom-banner-opacity','[class*="download-app"]',
...    '[class*="bottom-banner"]','[class*="app-banner"]','#onetrust-banner-sdk',
...    '.onetrust-pc-dark-filter','[id*="onetrust"][class*="filter"]',
...    '[class*="adopt-c"]','[id*="adopt"]','[aria-hidden="true"][class*="adopt"]',
...    '[class*="cookie"][class*="banner"]','[class*="modal-backdrop"]'];
...    sels.forEach(function(s){document.querySelectorAll(s).forEach(function(e){e.remove();});});
...    document.documentElement.style.overflow='auto';document.body.style.overflow='auto';


*** Keywords ***
Dismiss Cookie Banner Mobile
    [Documentation]    Fecha o banner de cookies/consentimento, se existir. Nao falha o
    ...                teste caso o banner esteja ausente ou momentaneamente coberto por
    ...                outro overlay (ex.: no Mercado Livre o botao fica sob o banner
    ...                "baixe o app" e gera ElementClickInterceptedException) — nesse caso
    ...                o overlay e removido logo depois via JS em Clear Home Overlays Mobile.
    ...
    ...                Nao se usa Get WebElements para checar presenca porque, no
    ...                AppiumLibrary, ele LANCA erro quando o seletor nao casa nada (ao
    ...                contrario de retornar lista vazia). Em vez disso, o clique e
    ...                tolerante (Run Keyword And Ignore Error) e, durante ele, o
    ...                run-on-failure e trocado por No Operation e restaurado em seguida,
    ...                evitando o ~5s de Capture Page Screenshot quando o clique falha.
    Register Keyword To Run On Failure    No Operation
    Run Keyword And Ignore Error    Click Element    ${SEL_COOKIE_ACCEPT}
    Register Keyword To Run On Failure    Capture Page Screenshot

Clear Home Overlays Mobile
    [Documentation]    Garante que nenhum componente (banner "baixe o app", modal de
    ...                cookies/consentimento, backdrop) fique sobre a home interceptando
    ...                o foco/clique da busca. Aceita o cookie (se houver, via checagem
    ...                de presenca) e remove via JS os overlays conhecidos. Nao falha se
    ...                nada existir.
    Dismiss Cookie Banner Mobile
    Run Keyword And Ignore Error    Execute Script    ${OVERLAY_CLEANUP_JS}

Search For Product Mobile
    [Documentation]    Preenche a barra de busca com ${term} e dispara a pesquisa.
    ...                No Chrome do emulador o Enter via teclado de software (keycode
    ...                66) nem sempre submete o formulario e o botao de busca pode
    ...                ficar recolhido/nao-interagivel no layout mobile; por isso a
    ...                submissao e feita via JS no formulario do campo focado
    ...                (document.activeElement.form.requestSubmit()), que e generico
    ...                e confiavel entre os sites. A remocao de overlays e feita na
    ...                pre-condicao (Clear Home Overlays Mobile); aqui apenas damos foco
    ...                no campo com Click Element para o activeElement ser o input.
    [Arguments]    ${term}
    Wait Until Element Is Visible    ${SEL_SEARCH_INPUT}    ${TIMEOUT}
    Click Element    ${SEL_SEARCH_INPUT}
    Input Text    ${SEL_SEARCH_INPUT}    ${term}
    Execute Script    document.activeElement.form.requestSubmit();

Wait For Search Results Mobile
    [Documentation]    Aguarda ao menos um card de resultado ficar visivel,
    ...                garantindo que a listagem de busca foi renderizada.
    Wait Until Element Is Visible    ${SEL_RESULT_ITEM}    ${TIMEOUT}

Get Results Count Mobile
    [Documentation]    Retorna a quantidade de cards de resultado exibidos. Usa uma
    ...                unica chamada Execute Script (querySelectorAll().length) em vez de
    ...                Get WebElements, evitando o round-trip de ~2s do Appium.
    ${raw}=    Remove String    ${SEL_RESULT_ITEM}    css=
    ${count}=    Execute Script    return document.querySelectorAll('${raw}').length;
    RETURN    ${count}

Get Result Titles Mobile
    [Documentation]    Retorna a lista de textos dos titulos dos resultados em UMA unica
    ...                chamada Execute Script. Antes, um FOR chamava Get Text por card
    ...                (~2s cada): com ~48 resultados isso custava ~96s com a tela parada.
    ...                Agora o querySelectorAll + map roda no browser e retorna o array de
    ...                uma vez (~2s no total). O prefixo "css=" do seletor e removido
    ...                porque querySelectorAll espera CSS puro.
    ${raw}=    Remove String    ${SEL_RESULT_TITLE}    css=
    ${js}=    Catenate    SEPARATOR=${SPACE}
    ...    return Array.from(document.querySelectorAll('${raw}'))
    ...    .map(function(e){return (e.innerText||e.textContent||'').trim();})
    ...    .filter(function(t){return t.length>0;});
    ${texts}=    Execute Script    ${js}
    RETURN    ${texts}
