# Flujo de trabajo del equipo

1. **Descubrimiento con Tres Amigos:** negocio, desarrollo y QA acuerdan lenguaje,
   reglas y comportamientos antes de automatizar. Registrar preguntas y ejemplos.
2. **Identificar candidatos a smoke:** justificar la criticidad de cada flujo y
   mantener una selección breve que aporte señales rápidas sobre funciones esenciales.
3. **Acordar criterios de aceptación:** definir precondición, acción y resultado
   observable; resolver ambigüedades antes de escribir código.
4. **Formular escenarios declarativos en inglés:** expresar intención de negocio,
   evitando clics, selectores, detalles del navegador e implementación.
5. **Revisar en equipo:** confirmar que negocio entiende el comportamiento y que
   desarrollo y QA comparten el criterio de éxito.
6. **Implementar steps y Page Objects:** reutilizar lenguaje con sentido de negocio,
   encapsular interacción por pantalla y utilizar RSpec Expectations para verificar.
7. **Ejecutar, revisar y mantener:** comenzar con dry-run para detectar pasos ausentes
   o ambiguos; ejecutar el perfil pertinente, investigar fallos y actualizar acuerdos.

## Convenciones

- Archivos y métodos Ruby en snake_case, clases en CamelCase e identificadores en inglés.
  Archivos Gherkin y escenarios en inglés; documentación del equipo en español.
- Usar `@smoke` solo cuando el equipo justifique criticidad, brevedad y estabilidad.
  No etiquetar diagnósticos técnicos como pruebas de la AUT.
- Cada escenario prepara su propio contexto; no depender del orden, de otra sesión
  o de datos creados por un escenario anterior. No guardar Page Objects en globales.
- `Background` expresa contexto de negocio compartido, no configuración de Chrome.
  Los hooks se reservan para necesidades técnicas transversales.
- `Scenario Outline` usa `Examples` y la parametrización nativa de Cucumber; evitar
  ciclos Ruby que oculten casos y resultados independientes.
- Preferir atributos estables acordados con desarrollo y semántica accesible.
  Evitar índices, rutas DOM frágiles y clases puramente visuales. Encapsular todos
  los localizadores en Page Objects y no incorporarlos al texto Gherkin.
- Sincronizar con búsquedas y matchers de Capybara; no utilizar sleeps fijos.
  No acumular utilidades genéricas sin una necesidad concreta.
- En revisión de código comprobar legibilidad, resultado observable, independencia,
  justificación de `@smoke`, ubicación de selectores y ausencia de datos sensibles.
  Revisar evidencias del fallo real, no solo el color del reporte. No aceptar una
  ejecución vacía como demostración de cobertura.

La selección e implementación de los Smoke Tests corresponde al trabajo posterior
del equipo. Esta base no propone comportamientos específicos de SauceDemo.
