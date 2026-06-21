*** Settings ***
Library         String


*** Keywords ***
Validate Any Title Contains
    [Documentation]    Valida que ao menos um titulo da lista contem o termo
    ...                buscado (comparacao case-insensitive). Usa o primeiro
    ...                token do termo como fallback, tornando a validacao robusta
    ...                a variacoes de nomenclatura entre anuncios.
    [Arguments]    ${titles}    ${term}
    ${term_lower}=    Convert To Lower Case    ${term}
    ${first_token}=    Evaluate    "${term_lower}".split()[0]
    FOR    ${title}    IN    @{titles}
        ${title_lower}=    Convert To Lower Case    ${title}
        ${has_term}=    Run Keyword And Return Status    Should Contain    ${title_lower}    ${term_lower}
        ${has_token}=    Run Keyword And Return Status    Should Contain    ${title_lower}    ${first_token}
        IF    ${has_term} or ${has_token}
            RETURN    ${title}
        END
    END
    Fail    Nenhum resultado contem o termo '${term}'. Titulos retornados: ${titles}
