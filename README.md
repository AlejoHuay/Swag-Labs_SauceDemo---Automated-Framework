# Framework de automatización — SauceDemo

Base técnica para que el equipo desarrolle pruebas de humo de https://www.saucedemo.com/.
Esta entrega contiene configuración, ejecución, aislamiento, evidencias y documentación.
No contiene comportamientos de negocio, escenarios, steps, selectores ni datos de usuarios.

**Esta base todavía no contiene escenarios de negocio. Una ejecución con
0 escenarios no demuestra que SauceDemo haya superado pruebas de humo**.

## Entorno y dependencias

| Componente | Versión fijada |
| --- | --- |
| Ruby x64 (RubyInstaller con Devkit) | 3.0.2 |
| RubyGems | 3.2.22 |
| cucumber | 9.2.1 |
| capybara | 3.40.0 |
| selenium-webdriver | 4.26.0 |
| selenium | 0.2.11 |
| rspec | 3.13.2 |
| capybara-screenshot | 1.0.27 |

Windows 10, MSYS2 y MinGW fueron declarados como entorno base. Ruby, arquitectura,
RubyGems y las seis gemas fueron comprobados; no se reinstaló ni modificó el sistema.
Bundler 2.2.22 está disponible. `Gemfile.lock` se generó realmente mediante
`bundle lock --local`; `bundle check` confirmó la resolución local.
La gema `selenium` se conserva con `require: false`; la integración usa únicamente
`selenium-webdriver`. No utilizar `Bundler.require` para cargar indiscriminadamente gemas.

No instalar, actualizar ni agregar dependencias sin autorización del equipo.
Si falta una versión, registrar el error y acordar el cambio mínimo antes de actuar.
El lockfile pertenece al repositorio; no editarlo manualmente.

## Organización

- `config/`: variables validadas, perfiles y construcción compartida del driver.
- `features/smoke/`: reservado para futuros escenarios en inglés.
- `features/step_definitions/`: reservado para futuras conexiones entre Gherkin y objetos.
- `features/pages/`: solo `BasePage`, con el DSL de Capybara.
- `features/support/`: carga determinista, RSpec Expectations y evidencias técnicas.
- `scripts/`: diagnósticos independientes del entorno y navegador.
- `reports/`: reportes HTML locales, ignorados en Git salvo `.gitkeep`.
- `screenshots/`: PNG de fallos, ignorados en Git salvo `.gitkeep`.
- `docs/`: arquitectura y acuerdos de trabajo.

Se añadió `config/browser.rb` para compartir exactamente la configuración entre
Cucumber y el diagnóstico; no introduce una capa de negocio.

## Variables desde PowerShell

Ejecutar desde la raíz del proyecto:

```powershell
$env:BASE_URL = 'https://www.saucedemo.com'
$env:HEADLESS = 'false'
$env:WAIT_TIME = '10'
```

Estos son los valores predeterminados. `HEADLESS` admite true/false sin distinguir
mayúsculas. `WAIT_TIME` admite números finitos positivos en segundos, usando punto
decimal. `BASE_URL` debe ser HTTP/HTTPS con host, sin credenciales, query ni fragmento.
No se utiliza dotenv. Las variables afectan solamente a la sesión de PowerShell y
sus procesos hijos. Para volver a los valores predeterminados:

```powershell
Remove-Item Env:BASE_URL, Env:HEADLESS, Env:WAIT_TIME -ErrorAction SilentlyContinue
```

Chrome se busca en PATH, ubicaciones habituales de Windows y caché local de Selenium.
ChromeDriver se busca en PATH y en esa caché. En caché se elige la versión más alta
disponible de cada componente. Si no son compatibles, indicar una pareja compatible
ya instalada con `CHROME_BINARY` y `CHROMEDRIVER_PATH` (rutas completas a los `.exe`).
Una variable explícita inválida produce un error, no una búsqueda alternativa.

Se comprobó Chrome y ChromeDriver 158.0.8127.88 existentes en la caché local.
Se pasan el binario y el servicio explícitamente: Selenium Manager no interviene y
el framework no descarga componentes. Si faltan, detener el diagnóstico y solicitar
autorización antes de cualquier instalación. No se desactiva TLS, sandbox ni seguridad web.

## Comandos disponibles

```powershell
ruby scripts/check_environment.rb
bundle check
bundle exec ruby scripts/check_browser.rb
bundle exec cucumber -p default
bundle exec cucumber -p smoke
bundle exec cucumber -p dry_run
```

El diagnóstico abre únicamente `about:blank` y cierra en `ensure`. Código 0 significa
sesión creada y cerrada; 1 indica fallo de configuración o apertura; 2 indica error
de cierre. No es un Smoke Test de la AUT. Para comprobar Chrome sin ventana:

```powershell
$env:HEADLESS = 'true'
bundle exec ruby scripts/check_browser.rb
Remove-Item Env:HEADLESS -ErrorAction SilentlyContinue
```

`default` descubre los futuros archivos bajo `features/`; `smoke` selecciona `@smoke`.
`dry_run` carga soporte y comprueba correspondencia de pasos cuando existan escenarios,
sin ejecutar steps ni hooks. Actualmente no hay escenarios ni steps: no se verificó
ninguna correspondencia entre ellos. La carga no abre Chrome. No combinar estos perfiles en
un mismo comando. No habilitar publicación de Cucumber mediante variables externas.

Cada perfil escribe consola legible y su propio archivo: `reports/default.html`,
`reports/smoke.html` y `reports/dry_run.html`. Repetir un perfil reemplaza su reporte.
Los reportes actuales con cero escenarios solo documentan carga técnica.
Las capturas de fallo se guardan en `screenshots/failure_<fecha>_<aleatorio>.png`
y se adjuntan al HTML. Los nombres no incluyen textos de escenarios ni caracteres
inválidos en Windows. Revisar evidencias antes de compartirlas, pues pueden mostrar
información de la sesión.

## Validación y siguientes pasos

Consultar [validación técnica](docs/validation.md) para resultados y limitaciones,
[arquitectura](docs/architecture.md) para carga y hooks, y
[flujo del equipo](docs/team_workflow.md) para ampliar la base.
El equipo debe acordar los flujos críticos y criterios de aceptación, redactar Gherkin
en inglés y después implementar steps y Page Objects. Esa selección no forma parte
de esta entrega.
