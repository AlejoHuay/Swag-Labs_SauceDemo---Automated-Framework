# Arquitectura

Gherkin → Step Definitions → Page Objects → Capybara → Selenium WebDriver → Chrome → AUT.

Gherkin expresa comportamiento observable acordado; los steps conectan esa intención
con objetos y verificaciones mediante RSpec Expectations. Los Page Objects concentran
interacciones y localizadores. Capybara sincroniza esperando condiciones, Selenium
controla Chrome y Chrome accede a la AUT externa. `run_server = false` evita iniciar
un servidor local; `app_host` y la espera provienen de `Settings`.

## Carga y estado

Los perfiles requieren exclusivamente `features/support/env.rb`. Este carga Bundler,
configuración, `capybara/cucumber`, RSpec y el núcleo de capybara-screenshot; registra
el driver sin instanciarlo; carga BasePage primero, los demás objetos ordenados por
ruta, los steps ordenados y finalmente los hooks propios. Las dependencias entre
clases deben declararse con `require_relative`, sin depender de nombres accidentales.
No hay navegador durante la carga ni durante dry-run.

Crear posteriormente una clase por pantalla, en un archivo snake_case y con nombre
CamelCase que herede de BasePage. Sus métodos deben expresar intención en inglés;
los selectores se encapsulan en esa clase. Instanciar los objetos en el World del
escenario, usando variables de instancia de ese contexto. No compartir instancias,
datos mutables ni estado de negocio mediante variables globales o de clase.

## Sesiones y evidencias

Se inspeccionó el código instalado de Capybara 3.40.0: `capybara/cucumber` registra
un Before que selecciona el driver predeterminado y un After con `reset_sessions!`.
No se duplica ese reset. El driver del proyecto especializa `reset!` para llamar a
`quit`: Capybara 3.40.0 envía en su reset de Chrome un comando CDP con origen `*`
que Chrome 158.0.8127.88 rechaza con `invalid argument: * is not a valid URL`.
Cerrar la sesión evita ese comando y aísla cookies y almacenamiento de todos los
orígenes; el siguiente escenario crea un navegador nuevo bajo demanda. Es una
adaptación local sin modificar gemas, a costa de abrir Chrome por escenario.
Cucumber ejecuta los After en orden inverso al registro;
el hook propio, cargado al final, captura antes del reset de Capybara. El driver
Selenium de Capybara registra su propio `at_exit` al crear el navegador y llama a
`quit` al terminar. El diagnóstico independiente utiliza además `ensure`.
El reset cierra la sesión del navegador; no revierte datos persistidos en la AUT.
Los futuros escenarios deben diseñarse independientes también respecto de esos datos.

La integración instalada `capybara-screenshot/cucumber` 1.0.27 lee el PNG y llama
a `attach` fuera de una protección de errores. Una excepción allí podría añadir
un fallo técnico y ocultar la causa inicial. Por eso no se carga esa integración,
se desactiva `autosave_on_failure` y un único After protegido usa su `Saver` y el
renderer Selenium registrado para `framework_chrome`. Se guarda solo PNG mediante
`Saver#save_screenshot`: se demostró que `Saver#save` omite `about:blank` porque
`current_path` está vacío. La llamada directa sigue usando la gema y permite guardar
también esa página técnica, sin generar HTML ni abrir visores externos.
Los errores de captura o adjunto se advierten sin relanzarlos. No hay captura manual
alternativa a la gema ni dos mecanismos simultáneos.

Para no abrir un navegador ante un fallo anterior a su creación, el hook inspecciona
`@browser` del driver fijado en Capybara 3.40.0: esa versión no expone un predicado
público de inicialización. Revisar este punto si se autoriza cambiar versiones.
Si el navegador no existe, no queda evidencia visual; si ya se cerró o falla la captura,
el fallo original permanece. Las sesiones y ventanas nombradas usan el seguimiento
de capybara-screenshot. Un proceso terminado forzosamente no puede garantizar cleanup.

## Referencias de las versiones

La implementación se contrastó con las fuentes de las gemas instaladas y la
[documentación de Capybara](https://www.rubydoc.info/gems/capybara/3.40.0) y de
[capybara-screenshot 1.0.27](https://www.rubydoc.info/gems/capybara-screenshot/1.0.27).
