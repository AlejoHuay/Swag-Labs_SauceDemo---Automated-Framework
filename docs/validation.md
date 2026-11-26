# Validación técnica de la entrega

Fecha: 26 de noviembre de 2026. No se accedió a SauceDemo ni se crearon escenarios
Gherkin, step definitions, selectores o datos de negocio para validar esta base.

| Comprobación | Resultado observado |
| --- | --- |
| Ruby / arquitectura | 3.0.2p107 / x64-mingw32 |
| RubyGems | 3.2.22 |
| Seis gemas fijadas | Todas presentes en sus versiones exactas |
| Bundler | 2.2.22; resolución local y `bundle check` correctos |
| Gemfile.lock | Generado por `bundle lock --local`, sin descargar dependencias |
| Sintaxis Ruby | Correcta en todos los archivos Ruby creados y Gemfile |
| Settings | Valores predeterminados y HEADLESS=true correctos; rechaza booleano inválido, URL inválida/con credenciales y tiempos cero, negativos, no numéricos o no finitos |
| Chrome visible | 158.0.8127.88; apertura de about:blank y cierre, código 0 |
| Chrome headless | Misma versión; apertura de about:blank y cierre, código 0 |
| ChromeDriver | 158.0.8127.88, existente en caché local; servicio explícito |
| Perfiles default, smoke y dry_run | Código 0; 0 escenarios y 0 pasos; HTML independiente por perfil |
| Dry-run instrumentado | Selenium::WebDriver.for sustituido temporalmente por una excepción; la ejecución terminó con código 0, sin intentar abrir navegador |
| Captura aislada | PNG real de about:blank generado por el Saver; bytes y MIME comprobados en receptor de adjunto de diagnóstico |
| Orden y aislamiento | Hooks invocados en orden inverso de registro; captura antes del reset; driver cerrado y objeto WebDriver nuevo en la siguiente sesión |
| Fallo de evidencia | Excepciones inducidas en creación del Saver y adjunto advertidas sin propagarlas |
| Gema selenium 0.2.11 | Declarada y resuelta; no cargada durante la comprobación del soporte |

## Incidencias resueltas sin cambiar dependencias

- El sandbox de la herramienta denegó WMI a `sys-uname` con HRESULT 0x80041003
  durante la carga de Cucumber. También impidió a Ruby descubrir ejecutables en
  caché. Las comprobaciones se completaron fuera del sandbox con revisión automática
  de permisos. No se alteraron permisos de Windows ni configuración global.
  Si ocurre en otro entorno restringido, ejecutar desde una consola autorizada con
  acceso a WMI y a los ejecutables locales; no reinstalar gemas como primera medida.
- Capybara 3.40.0 y Chrome 158 rechazaron el reset CDP con
  `invalid argument: * is not a valid URL`. El driver local antepone un reset que
  cierra la sesión después de la especialización interna de Chrome. La nueva sesión
  evita compartir cookies y almacenamiento; el costo es abrir Chrome por escenario.
- `Saver#save` de capybara-screenshot omite páginas cuya ruta está vacía, incluyendo
  about:blank. El hook protegido llama a `Saver#save_screenshot` directamente.
  La lectura y el adjunto también se protegen, a diferencia del hook integrado.

No fue necesario solicitar cambios de dependencias. No se ejecutaron instaladores,
actualizaciones ni descargas de Chrome/ChromeDriver.

## Límites de lo comprobado

El diagnóstico de hooks fue un programa Ruby aislado por stdin, con receptores
técnicos para el registro de hooks y el adjunto; no fue un escenario Cucumber.
Por ello se comprobó la captura real y el orden de limpieza, pero **no se validó
de extremo a extremo un PNG embebido en el HTML de un escenario fallido real**.
Las capturas técnicas temporales se eliminaron tras verificar sus bytes; los HTML
de cero escenarios son resultados reales de carga y están ignorados en Git.

La ausencia de escenarios impide comprobar correspondencia de steps de negocio,
etiquetado efectivo de una suite real, interacción con la AUT y cobertura smoke.
MSYS2/MinGW y el instalador exacto se registran como información declarada; no se
reinstalaron ni se hizo una compilación para verificarlos. El control de sesiones
nombradas y ventanas múltiples no se ejercitó en el diagnóstico aislado.

Esta base todavía no contiene escenarios de negocio. Una ejecución con
0 escenarios no demuestra que SauceDemo haya superado pruebas de humo.
