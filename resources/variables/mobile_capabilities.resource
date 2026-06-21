*** Settings ***
Resource    ../core/mobile_core.resource
Variables   ../variables/${ENV.lower()}_vars.py


*** Variables ***
${ENV}                   QA1

${APPIUM_URL}            http://localhost:4723

${PLATFORM_NAME}         Android
${AUTOMATION_NAME}       UiAutomator2

${BROWSER_NAME}          Chrome

${DEVICE_NAME}           emulator-5554

${AVD_NAME}              pixel_9_pro_xl

${PLATFORM_VERSION}      ${EMPTY}


*** Keywords ***
Open Mobile Browser
    [Documentation]    Abre uma sessão Appium controlando o Chrome do
    ...                emulador/dispositivo Android e navega até a ${BASE_URL}
    ...                do ambiente carregado. As variáveis ${DEVICE_NAME} e
    ...                ${PLATFORM_VERSION} podem ser sobrescritas via --variable.
    ...
    ...                Passa goog:chromeOptions com flags "stealth" para reduzir
    ...                deteccao de automacao (navigator.webdriver=false e sem o
    ...                switch enable-automation). Sem isso, o Mercado Livre (QA1)
    ...                redireciona a pagina de resultados para /captcha/wall.
    ${chrome_options}=    Evaluate
    ...    {'args': ['--disable-blink-features=AutomationControlled'], 'excludeSwitches': ['enable-automation']}
    ${extra_caps}=    Create Dictionary    goog:chromeOptions=${chrome_options}
    Open Application    ${APPIUM_URL}
    ...    platformName=${PLATFORM_NAME}
    ...    automationName=${AUTOMATION_NAME}
    ...    browserName=${BROWSER_NAME}
    ...    deviceName=${DEVICE_NAME}
    ...    avd=${AVD_NAME}
    ...    chromedriverAutodownload=${True}
    ...    &{extra_caps}
    Go To Url    ${BASE_URL}
    Log    Chrome mobile aberto em: ${BASE_URL}    level=INFO
