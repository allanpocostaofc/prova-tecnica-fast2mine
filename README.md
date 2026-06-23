# Automação de Busca em E-commerce — Robot Framework

Testes de busca de produto em e-commerces reais com duas suítes que rodam o mesmo cenário
(pesquisar um termo e validar ao menos 1 resultado contendo o termo):

- **WEB** — desktop, via [Browser Library](https://robotframework-browser.org/) (Playwright).
- **MOBILE** — Chrome no emulador Android, via [AppiumLibrary](https://github.com/serhatbolsu/robotframework-appiumlibrary).

| Ambiente | Site          | Categoria             | Termo de busca   |
|----------|---------------|-----------------------|------------------|
| QA1      | Mercado Livre | Celulares e Telefones | Galaxy S26 Ultra |
| QA2      | Amazon Brasil | Eletrônicos           | Echo Dot         |
| QA3      | KaBuM!        | Tecnologia            | Apple Watch      |

## Pré-requisitos

- Python 3.10+ e Robot Framework 7.x
- Node.js (instalado junto com a Browser Library, para o Playwright)
- Para a suíte mobile: Android SDK (`ANDROID_HOME`), AVD criado (`pixel_9_pro_xl`),
  Appium 3.x e o driver `uiautomator2`

## Instalação

```bash
pip install -r requirements.txt      # Robot Framework, Browser Library, AppiumLibrary
rfbrowser init                       # baixa os navegadores do Playwright (suíte web)
appium driver install uiautomator2   # driver Android do Appium (suíte mobile)
```

## Execução

### Tudo junto (web + mobile, todos os ambientes)

```powershell
.\run_all_tests.ps1          # PowerShell — roda QA1, QA2 e QA3 (web + mobile)
```

```bash
./run_tests.sh QA1           # Linux/macOS — um ambiente por vez
run_tests.bat QA1            # Windows Batch — um ambiente por vez
```

> O script PowerShell itera pelos três ambientes automaticamente e exibe um resumo
> ao final. A suíte mobile exige emulador e Appium no ar (veja abaixo); sem isso,
> as execuções mobile falharão, mas as web continuarão normalmente.

### Somente Web

```bash
robot --variable ENV:QA1 --variablefile resources/variables/qa1_vars.py --outputdir results/qa1_web --name Web_QA1 tests/web/
robot --variable ENV:QA2 --variablefile resources/variables/qa2_vars.py --outputdir results/qa2_web --name Web_QA2 tests/web/
robot --variable ENV:QA3 --variablefile resources/variables/qa3_vars.py --outputdir results/qa3_web --name Web_QA3 tests/web/
```

### Subir ambiente mobile

```bash
# 1. Emulador (PowerShell — não redirecione a saída, derruba o processo)
& "$env:ANDROID_HOME\emulator\emulator.exe" -avd pixel_9_pro_xl -no-snapshot-load

# 2. Aguardar boot completo
adb wait-for-device
adb shell getprop sys.boot_completed   # repetir até retornar "1"

# 3. Appium Server
appium --port 4723
```

### Somente Mobile

```bash
robot --variable ENV:QA1 --variablefile resources/variables/qa1_vars.py --outputdir results/qa1_mobile --name Mobile_QA1 tests/mobile/
robot --variable ENV:QA2 --variablefile resources/variables/qa2_vars.py --outputdir results/qa2_mobile --name Mobile_QA2 tests/mobile/
robot --variable ENV:QA3 --variablefile resources/variables/qa3_vars.py --outputdir results/qa3_mobile --name Mobile_QA3 tests/mobile/
```

## Resultados

Relatórios gerados em `results/`: `report.html`, `log.html`, `output.xml`.
