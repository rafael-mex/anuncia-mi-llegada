#### 1\. INFORMACIÓN INICIAL

- **Autor:** Mex Lozano Rafael Emilio
- **Título del proyecto:** ¡Anuncia mi llegada!

#### 2\. RESUMEN DEL PROYECTO, METAS Y OBJETIVOS

- **Resumen:**  
    ¡Anuncia mi llegada! Es una aplicación que le permite al usuario mandar un mensaje de texto a sus contactos de que a llegado a una estación de la red de movilidad integrada de la Ciudad de México o del Estado de México. 
- **Metas:**  
    * Crear una interfaz intuitiva que permita moverse entre la aplicación de forma fluida y eficiente.
    * Permitirle a los usuarios de la red de movilidad integrada una comunicación instántanea al momento de realizar el ascenso o el descenso de las estaciones de este sistema.
- **Objetivos:**
    * Lanzar el MVP antes del 10 de Agosto del 2026.
#### 3\. PÚBLICO OBJETIVO (UX)
Sectores de la población que son usuarios constantes de la red de movilidad integrada de la Ciudad de México y del Estado de México. 
#### 4\. PROPÓSITO Y ALCANCE

- **En alcance (Entregables):**  
    + Utilizar la aplicación como usuario receptor o remitente.
    + Registrarse mediante un correo electrónico.
    + Crear un usuario y contraseña para ingresar a la aplicación.

    + Usuario remitente.
        + Crear hasta 5 rutas de las estaciones que ocupan del Metro. 
        + Permitir que la aplicación mande el mensaje de que ya llegada a la estación. 
        + Decidir que estaciones serán en las que se mandará el mensaje de llegada a la estación.
        * Personalizar el mensaje de llegada a la estación.
        + Obtener su localización mediante el GPS.
        + Decidir quien será el receptor de sus mensajes de llegada a la estación
        + Iniciar el rastreo de su ruta.

    + Usuario receptor.
        + Autorizar ser el receptor del usuario remitente que lo eligió.
        + Recibir el mensaje de llegada del usuario remitente. 
        + Revisar la ruta en tiempo real del usuario remitente.
- **Fuera de alcance:**
    + Utilizar la aplicación como usuario receptor o remitente al mismo tiempo.
    + Registrarse mediante su número telefónico.

    + Usuario remitente.
        + Crear hasta 5 rutas con las estaciones o paradas de los medios de transporte de todo el sistema de la Movilidad Integrada.
        + Decidir si la aplicación mandará automáticamente el mensaje de llegada a la estación o parada.

    + Usuario receptor.
        + Permitir que el mensaje de llegada del remitente se mande a la aplicación de Mensajes predeterminada de su celular.
#### 5\. ESPECIFICACIONES FUNCIONALES

\\

#### 6\. REQUISITOS NO FUNCIONALES
| Categoría | Requisito |
| :---- | :---- |
| **Rendimiento** | Tiempo de carga inicial rápido (LCP). |
| **Accesibilidad** | La aplicación debe ser navegable mediante teclado y lectores de pantalla. |
| **Universabilidad** | La aplicación podrá ser ocupada en los sistemas operativos de iOS y Android |
| **Seguridad** | Toda la información del usuario debe estar encriptada. |
#### 7\. ARQUITECTURA DE LA INFORMACIÓN Y UX

\

#### 8\. ESPECIFICACIONES TÉCNICAS

- **Frontend:** Flutter, framework multiplataforma que permite otorgar a la aplicación una interfaz moderna.
- **Backend:** Dart, lenguaje de programación multiplataforma que permite crear un solo código y ejecutarlo en sistemas iOS y Android
- **Base de Datos:** MySQL ya que su integrción con Flutter y Dart es sencila, además de proporcionar una base de datos segura y estable. 

## Uso de Inteligencia Artificial

### Modelo utilizado

Se utilizó el modelo **opencode/big-pickle** a través de la herramienta **opencode** (CLI de asistencia de desarrollo con IA) para el diseño arquitectónico y la implementación de funcionalidades de la aplicación "¡Anuncia mi llegada!".

### Contexto del proyecto y arquitectura existente

El proyecto es una aplicación Flutter multiplataforma (iOS y Android) que permite a usuarios de la red de movilidad integrada de la Ciudad de México y del Estado de México enviar mensajes de texto de llegada a estaciones a sus contactos. La arquitectura del proyecto sigue un patrón de capas dentro del directorio `lib/`:

- **`main.dart`**: Punto de entrada de la aplicación.
- **`config/`**: Capa de configuración, contiene el enrutador (`app_router.dart`) basado en `go_router`.
- **`presentation/`**: Capa de presentación subdividida en:
  - **`screens/`**: Pantallas completas organizadas por funcionalidad (`selectors/`, `settings/`, `splash_page/`).
  - **`widgets/shared/`**: Widgets reutilizables como `SelectorWidget`, `MapIconLight` y `SettingsButton`.
- **`assets/data/`**: Contiene los archivos JSON con datos de movilidad.
- **`lib/data/`**: Contiene el repositorio de parseo (`repositories/mi_repository.dart`) y los modelos de datos (`models/mi_model.dart`), accesibles como código Dart importable.

### Modelos de datos

Se definieron dos modelos principales en `lib/data/models/mi_model.dart`:

1. **`TransportsModel`**: Representa un medio de transporte (Metro, Metrobús, etc.) con un `name` (nombre del transporte) y una lista de `LinesModel` (líneas del transporte).
2. **`LinesModel`**: Representa una línea específica con `name` (nombre de la línea), `lineNameInMessage` (nombre a incluir en el mensaje, puede estar vacío según preferencias) y `stations` (lista de estaciones de esa línea).

### Repositorio de datos (`MiRepository`)

El repositorio en `lib/data/repositories/mi_repository.dart` implementa la lógica de carga y parseo de archivos JSON:

- **`loadTransports()`**: Método principal que recibe dos booleanos (`showLineNamesInMessage`, `showInstitutionsName`) para determinar qué archivo JSON cargar.
- **`_stationsPreferences()`**: Método privado que selecciona el archivo JSON adecuado según las preferencias del usuario (4 combinaciones posibles: `movilidadIntegrada.JSON`, `_SIG.JSON`, `_SNL.JSON`, `_Ambos.JSON`).
- **`_parse()`**: Método privado que decodifica el JSON y construye la lista de `TransportsModel` con sus `LinesModel` anidadas. Cuando `showLineNames` es `true`, el primer elemento del array se interpreta como `lineNameInMessage`; cuando es `false`, todos los elementos se interpretan como estaciones.

### Enrutamiento con `go_router`

Se configuró `go_router` en `app_router.dart` con las siguientes rutas:

| Ruta | Nombre | Descripción |
|------|--------|-------------|
| `/splash` | `splash` | Pantalla de carga inicial |
| `/` | `transports_screen` | Pantalla principal de selección de transporte |
| `/lineas` | `lines_screen` | Pantalla de selección de línea (recibe `TransportsModel` via `extra`) |
| `/estaciones` | `stations_screen` | Pantalla de selección de estación (recibe `LinesModel` via `extra`) |
| `/settings` | `settings_screen` | Pantalla de configuración |

La navegación entre pantallas se realiza mediante `context.pushNamed()` pasando objetos de modelo a través del parámetro `extra` de `go_router`, que permite transferir datos complejos entre rutas sin serialización.

### Widget reutilizable `SelectorWidget`

El `SelectorWidget` es el componente visual principal de las pantallas de selección. Recibe los siguientes parámetros:

- **`selectorsTitle`**: Título mostrado en la parte superior del contenedor naranja.
- **`listItems`**: Lista de widgets (`List<Widget>`) que se renderizan como elementos interactivos dentro del contenedor de vidrio. El `ListView.separated` se construye internamente.
- **`glassContainerWidth`**: Ancho del contenedor de vidrio (por defecto 320px).
- **`glassContainerHeight`**: Alto del contenedor de vidrio (por defecto 255px).
- **`orangePadding`**: Espacio entre el contenedor naranja y el de vidrio en cada lado (por defecto 20px).
- **`listContentPadding`**: Espacio interno del listado en cada lado (por defecto 5px).
- **`dividerWidthModifier`**: Valor que se resta al ancho del divider para hacerlo más corto que el contenido (por defecto 9).

### Implementación de pantallas

1. **`TransportsScreen`**: Utiliza un `FutureBuilder` que invoca `MiRepository().loadTransports()` con ambos booleanos en `true`. Muestra un `CircularProgressIndicator` durante la carga, maneja errores, y renderiza la lista de transportes como `ListTile` dentro del `SelectorWidget`. Cada elemento navega a `/lineas` pasando el `TransportsModel` completo.

2. **`LinesScreen`**: Recupera el `TransportsModel` desde `GoRouterState.of(context).extra`. Lista las líneas del transporte como `ListTile` dentro del `SelectorWidget`. Al seleccionar una línea, navega a `/estaciones` pasando el `LinesModel` correspondiente.

3. **`StationsScreen`**: Recupera el `LinesModel` desde `GoRouterState.of(context).extra`. Evalúa condicionalmente si `lineNameInMessage` no está vacío:
   - Si tiene texto: inyecta un `ListTile` adicional en la posición 0 con el texto "Únicamente mencionar el nombre de la línea" que imprime en consola el nombre de la línea.
   - Para el resto de elementos: lista las estaciones reales, compensando el índice cuando la sugerencia está activada, e imprime en consola el nombre de la estación seleccionada.

---

### Registro de cambios y prompts

#### Primera sesión — 20 de agosto de 2026

**Prompt enviado (resumen):**
> "Continuando con el desarrollo de mi aplicación. Ya se encuentra la lógica de parseo de archivos JSON en mi_repository.dart que devuelve una lista de objetos TransportsModel (que a su vez contienen listas de LinesModel definidas en mi_model.dart). También tengo configurado go_router en mi archivo de rutas y un widget UI reutilizable llamado SelectorWidget que recibe selectorsTitle y listContent.
> Tarea 1: Actualización del Router — Agrega dos nuevas rutas de go_router: una ruta /lineas (cuyo nombre sea LineScreen.name) que reciba un objeto TransportsModel mediante el extra, y una ruta /estaciones (cuyo nombre sea StationsScreen.name) que reciba un objeto LinesModel mediante el extra.
> Tarea 2: Integración de la UI — Modifica mi TransportsScreen con un FutureBuilder que llame a MiRepository().loadTransports(), crea LineScreen y StationsScreen con navegación entre ellas.
> Tarea 3: Documentación — Crea una sección AI Usage en el README.md."

**Cambios realizados:**
- Se crearon las pantallas `LinesScreen` y `StationsScreen` con navegación vía `go_router`.
- Se modificó `TransportsScreen` para integrar `FutureBuilder` con `MiRepository`.
- Se agregaron rutas `/lineas` y `/estaciones` en `app_router.dart`.
- Se actualizó el barrel file `screens.dart`.
- Se movieron `mi_model.dart` y `mi_repository.dart` de `assets/data/` a `lib/data/` para que las importaciones Dart funcionaran correctamente (los archivos en `assets/` no son importables desde `lib/` en Flutter).
- Se creó la sección "AI Usage" en el README.

#### Segunda sesión — 20 de agosto de 2026

**Prompt enviado (resumen):**
> "Haz estas configuraciones en los selector widget: El listContent que tienen debe de estar con opacidad de 1, no debe de ser afectado por el valor de opacidad del Glass Container. El font que debe de tener el texto que se muestra es 'Nunito', con un tamaño de 17, letterSpacing de 0, fontWeight: FontWeight.w700, color: Colors.white. El espacio entre cada elemento debe ser de 0.7, el Divider debe ser de color blanco, con thickness de 5. Para cada Selector Widget alterno al de Transports Screen: el Orange Container debe tener un ancho acorde al Glass Container dejando 20px de espacio en los lados (configurable), la altura no cambia. El Glass Container debe tener un ancho acorde al espacio de los elementos del listContent con 5px de espacio en cada lado (configurable). El divider debe tener anchura igual al tamaño del listContent menos 9 (configurable). Activa el efecto de rebote para el scroll en Android. Redacta en el apartado de AI Usage los cambios, cómo funcionan, el prompt exacto y la fecha."

**Cambios realizados:**

1. **Refactorización de `SelectorWidget` — Separación de capas de opacidad:**
   - El contenedor de vidrio (glass container) y el contenido del listado ahora son dos widgets `Positioned` hermanos dentro del `Stack`, en lugar de estar anidados.
   - El glass container mantiene su `Opacity(opacity: 0.38)` para el efecto visual de vidrio esmerilado.
   - El contenido del listado se renderiza con opacidad 1.0, fuera de la capa de `Opacity` del glass. Esto permite que el texto y los elementos interactivos se muestren con nitidez total sin verse afectados por la transparencia del fondo.

2. **Cambio de API — de `listContent: Widget?` a `listItems: List<Widget>`:**
   - Anteriormente, `SelectorWidget` recibía un `Widget? listContent` que generalmente era un `ListView.separated` pre-construido. Esto impedía que el widget controlara el scroll physics, el divider o el padding interno.
   - Ahora recibe `List<Widget> listItems` y construye el `ListView.separated` internamente, dando control total sobre:
     - **Scroll physics**: `BouncingScrollPhysics` en Android (efecto de rebote), `ClampingScrollPhysics` en iOS.
     - **Divider**: color blanco, `thickness: 5`, `height: 0.7`, con `indent`/`endIndent` calculados a partir de `dividerWidthModifier`.
     - **Padding interno**: controlado por `listContentPadding` (5px por defecto en cada eje).

3. **Estilo de texto unificado via `DefaultTextStyle`:**
   - Se envuelve el `ListView.separated` en un `DefaultTextStyle` con fuente Nunito, tamaño 17, `fontWeight: w700`, color blanco y `letterSpacing: 0`.
   - Cualquier `Text` dentro de los `listItems` que no tenga un estilo explícito hereda este estilo automáticamente.

4. **Dimensiones dinámicas del contenedor naranja:**
   - El ancho del contenedor naranja ahora se calcula automáticamente: `glassContainerWidth + (orangePadding * 2)`.
   - Para pantallas alternas (Lines, Stations), se puede configurar `glassContainerWidth` según el contenido, y el contenedor naranja se ajusta proporcionalmente.

5. **Divider con ancho configurable:**
   - Cada `Divider` recibe `indent` y `endIndent` iguales a `dividerWidthModifier / 2` (por defecto 4.5px cada lado), reduciendo visualmente la línea del divisor respecto al ancho total del contenido.

6. **Simplificación de pantallas:**
   - `LinesScreen`, `StationsScreen` y `TransportsScreen` ahora solo construyen la lista de `ListTile` y la pasan como `listItems`. Todo el estilo visual (fuente, color, divider, scroll) está centralizado en `SelectorWidget`.

**Cómo funciona en la aplicación:**
Cuando el usuario navega a cualquiera de las tres pantallas de selección, `SelectorWidget` construye un `Stack` con tres capas: el contenedor naranja con degradado y opacidad 0.87, el contenedor de vidrio con opacidad 0.38, y el listado con opacidad 1.0. El listado usa `ListView.separated` con `BouncingScrollPhysics` en Android para dar sensación de rebote al hacer scroll. Los dividers entre elementos son blancos con un grosor de 5px y una separación vertical de 0.7px. El texto hereda el estilo Nunito 17/w700/blanco del `DefaultTextStyle`. Para las pantallas de líneas y estaciones, el ancho del contenedor de vidrio puede configurarse para adaptarse al contenido, y el contenedor naranja se expande automáticamente con 20px de margen en cada lado.

#### Tercera sesión — 20 de agosto de 2026

**Prompt enviado (resumen):**
> "Agrega una ScrollBar funcional (que también haga scroll si se presiona) y colócala en el espacio que se dejó en el lado derecho entre el Orange y el Glass Container. Haz transparente el highlightColor y splashColor de los elementos del listContent. Bloquea la orientación de la aplicación a solo Vertical. Agrega estos cambios, su funcionamiento y prompt exacto en el README."

**Cambios realizados:**

1. **ScrollBar funcional en el `SelectorWidget`:**
   - Se envolvió el `ListView.separated` con un widget `Scrollbar` con `thumbVisibility: true` y `trackVisibility: true`.
   - El scrollbar se posiciona visualmente en el espacio derecho entre el contenedor naranja y el de vidrio (el área de `orangePadding`).
   - Se configuró el tema del scrollbar vía `ScrollbarThemeData`: thumb blanco semitransparente (`alpha: 0.5`), track blanco muy tenue (`alpha: 0.1`), borde transparente, grosor 3px y esquinas redondeadas de 10px.
   - El scrollbar es completamente funcional: al presionar y arrastrar el thumb se desplaza el listado.

2. **HighlightColor y SplashColor transparentes:**
   - Se envolvió el `ListView.separated` en un `Theme` con `splashColor: Colors.transparent` y `highlightColor: Colors.transparent`.
   - Al tocar cualquier `ListTile` del listado, ya no se muestra el efecto de onda (splash) ni el resaltado (highlight) del ink, dando una experiencia visual más limpia.

3. **Orientación bloqueada a vertical:**
   - En `main.dart` se agregó `SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])` antes de `runApp()`.
   - La aplicación ahora solo funciona en modo vertical, evitando que la pantalla rote al girar el dispositivo.

#### Cuarta sesión — 21 de agosto de 2026

**Prompt enviado (resumen):**
> "Solamente haz estas tres cosas: -Mueve todo el SettingsView al centro de la pantalla, NO CAMBIES LA POSICIÓN DEL TITLE Y EL SUBTITLE -Haz visibles los SVGAssets y hazlos de tamaño 70px x 70px -Anota estos cambios, su funcionalidad, prompt y fecha en el README"

**Cambios realizados:**

1. **`SettingsView` centrado en pantalla (`settings_screen.dart`):**
   - El `ListView.builder` de `_SettingsView` estaba anclado con `Positioned.fill(top: 300)`, es decir, a una posición fija bajo el engranaje.
   - Ahora se envuelve en `Center` con `Positioned.fill` y el `ListView` usa `shrinkWrap: true` con `padding: EdgeInsets.zero`, de modo que el bloque de los tres ítems se centra vertical y horizontalmente dentro del `Stack`.
   - No se modificó `_CustomListTitle`: las posiciones relativas de `title` y `subtitle` dentro de cada `ListTile` se mantienen intactas.

2. **SVGAssets visibles y a 70x70 px (`settings_items.dart`):**
   - Las rutas de los tres SVG estaban mal escritas (`assets/data/icons/config_icons/*.svg`), lo que lanzaba `Unable to load asset` y cerraba la app al navegar a settings; se corrigieron a `assets/icons/config_icons/*.svg`.
   - Cada `SvgPicture.asset` ahora recibe `width: 70, height: 70`.

3. **Documentación en README:** esta misma sección con los cambios, su funcionamiento, el prompt y la fecha.

**Cómo funciona en la aplicación:**
Al navegar a `/settings`, el `Stack` del `Scaffold` renderiza el engranaje y el botón de regreso en sus posiciones originales, y debajo `_SettingsView` ocupa toda la pantalla pero centra su contenido: el `ListView.builder` con `shrinkWrap` mide su altura real (tres `ListTile`) y `Center` lo coloca en el punto medio de la pantalla. Los iconos SVG de Estaciones, Mensajes y Apariencia cargan desde `assets/icons/config_icons/` (ruta registrada en `pubspec.yaml`) y se muestran con dimensiones fijas de 70x70 px como `leading` de cada elemento.


#### Quinta sesión — 22 de agosto de 2026

**Prompt enviado (resumen):**
> "Implementa el Modo Claro y Oscuro para la aplicación, a partir de lo que ya está hecho en el archivo app_theme.dart, que contiene las constantes de diseño para cada componente que va a modificar su color según el modo establecido por el usuario en la configuración de la aplicación, así como los ThemeData para ambos modos. Si te es útil, se encuentra el ValueNotifier<bool> isTrueDarkMode = ValueNotifier(false); que controla el estado global. Deberás hacer que el cambio entre modo claro y oscuro ocurra en una transición suave y fluida mientras se ejecuta la animación de transición de los íconos de light mode y dark mode. El MapIconLight, renómbralo a MapIcon, cambia el path del asset al momento de cambiar entre modos: 'assets/icons/Map_Icon_Dark.png' en oscuro, 'assets/icons/Map_Icon_W.png' en claro. Haz ese mismo trabajo con la imagen del engranaje de settings: 'assets/icons/config_icons/gear_dark.png' en modo oscuro y 'assets/icons/config_icons/gear_white.png' en modo claro. Para el texto dentro del SelectorWidget déjalos con color blanco fijo; únicamente usa el color para la pantalla de configuraciones: Título claro Colors.black / Subtítulo claro Color.fromRGBO(91, 79, 79, 100); Título oscuro Color.fromRGBO(204, 204, 204, 100) / Subtítulo oscuro Color.fromRGBO(151, 145, 145, 100). Agrega esta sesión en el apartado 'Uso de la Inteligencia Artificial', describe qué cambios hiciste, cómo funcionan, el prompt que te di y la fecha."

**Cambios realizados:**

1. **Estado global (`lib/theme/app_theme.dart`):**
   - Se definió `isTrueDarkMode = ValueNotifier(false)` como única fuente de verdad del tema (`true` = modo oscuro).

2. **`main.dart` — transición suave sincronizada con el toggle:**
   - `MaterialApp.router` quedó envuelto en un `ValueListenableBuilder<bool>` escuchando `isTrueDarkMode`.
   - `theme: AppTheme.lightTheme`, `darkTheme: AppTheme.darkTheme`, `themeMode: isDark ? ThemeMode.dark : ThemeMode.light`.
   - `themeAnimationDuration: const Duration(milliseconds: 500)`: al presionar el toggle, la interpolación entre temas dura ~500 ms, acompañando en simultáneo la animación de expansión del icono `LightDarkThemeToggle`.

3. **`SelectorWidget` (`selector_widget.dart`):**
   - Contenedor naranja: `gradient: isDark ? AppTheme.colorsOfOrangeContainerDM : AppTheme.colorsOfOrangeContianerLM`.
   - Contenedor de vidrio: `color: isDark ? AppTheme.colorOfGlassContainerDM : null` y `gradient: isDark ? null : AppTheme.colorOfGlassContainerLM`.
   - Los textos del título y de los `listItems` permanecen SIEMPRE en `Colors.white`.
   - El listado se envolvió en un `Material(type: MaterialType.transparency)`: los `ListTile` pintan su tinta sobre este Material en lugar de quedar silenciados por el `Container` con fondo de cada pantalla (elimina el aviso "ListTile background color or ink splashes may be invisible").

4. **Renombrado `MapIconLight` → `MapIcon` (`map_icon_white.dart` → `map_icon.dart`):**
   - Evalúa `Theme.of(context).brightness` y alterna el asset entre `'assets/icons/Map_Icon_Dark.png'` y `'assets/icons/Map_Icon_W.png'`. Imports y usos actualizados en `TransportsScreen`, `LinesScreen` y `StationsScreen`.

5. **Fondo dinámico en pantallas (`transports`, `lines`, `stations`, `settings`):**
   - Cada `Scaffold` usa `backgroundColor: Colors.transparent` y su `Stack` se envuelve en un `Container` con `BoxDecoration`: `color: isDark ? null : AppTheme.backgroundColorLM` y `gradient: isDark ? AppTheme.backgroundColorDM : null`.

6. **`SettingsScreen`: engranaje dinámico y textos por modo:**
   - El engranaje alterna entre `'assets/icons/config_icons/gear_dark.png'` y `'assets/icons/config_icons/gear_white.png'`.
   - `_CustomListTitle` re-colorea título y subtítulo según el modo mediante un helper `_withColor` que clona cada `Text` conservando su estilo original y sustituyendo solo el color:
     - Claro: título `Colors.black`, subtítulo `Color.fromRGBO(91, 79, 79, 100)`.
     - Oscuro: título `Color.fromRGBO(204, 204, 204, 100)`, subtítulo `Color.fromRGBO(151, 145, 145, 100)`.

7. **Cableado del interruptor de Apariencia (`settings_items.dart`):**
   - `AppearanceIcon` lee `isTrueDarkMode` (`value: !isTrueDark` para que true = claro en el toggle) y escribe directamente `isTrueDarkMode.value = !value`; el tap sobre la fila del ítem hace lo mismo. Al existir un único notificador no puede haber desincronización.

**Cómo funciona en la aplicación:**
El usuario entra a Ajustes y acciona el interruptor de Apariencia (o toca la fila). Eso muta `isTrueDarkMode`; el `ValueListenableBuilder` de `main.dart` reconstruye `MaterialApp.router` con el `themeMode` opuesto y Flutter interpola ambos `ThemeData` durante 500 ms, logrando una transición gradual que ocurre mientras el icono del toggle termina su animación. Todos los widgets dependientes recalculan `isDark = Theme.of(context).brightness == Brightness.dark` y conmutan sus decoraciones: fondo blanco ↔ degradado diagonal oscuro, naranja tenue ↔ naranja intenso, vidrio degradado ↔ vidrio sólido translúcido, e iconos de mapa y engranaje entre sus versiones clara y oscura sin moverse de su posición.

**Resolución de incidencia y refinamientos (misma sesión):**

1. **Incidencia reportada:** al probar en el dispositivo físico, presionar el interruptor de Apariencia no producía ningún cambio visual, ni siquiera después de un reinicio completo de la aplicación.

2. **Diagnóstico:** se auditó el cableado completo (notificador, `AppearanceIcon`, pantallas y widgets) y hasta el código fuente del paquete `light_dark_theme_toggle 1.1.2`, que resultó ser un `IconButton` controlado estándar sin estado interno que pudiera desincronizarse. Una prueba automatizada de extremo a extremo que reproduce la ruta exacta del usuario (botón de configuración → interruptor → verificación visual de fondo, engranaje y colores de texto) pasó íntegra, demostrando que el código era correcto. La causa real fue ejecutar en el dispositivo una compilación antigua: "reiniciar la app" solo relanza el binario instalado y no recompila. La solución fue `flutter clean && flutter pub get && flutter run`.

3. **Blindaje de arquitectura:** se eliminó la dependencia de `Theme.of(context).brightness`; ahora cada componente dinámico (fondos de pantalla, `SelectorWidget`, `MapIcon`, engranaje y textos de ajustes) escucha directamente a `isTrueDarkMode` mediante `ValueListenableBuilder<bool>`. Si el notificador muta, todo cambia de inmediato y sin intermediarios.

4. **Prueba de regresión permanente (`test/theme_visual_test.dart`):** dos tests visuales que navegan por la interfaz real. Detalles técnicos relevantes: se fija un viewport tipo teléfono porque el `SettingsButton` vive en `top: 760` (fuera del lienzo por defecto de los tests); se usa `tester.runAsync` para que el `FutureBuilder` de transportes resuelva la carga del JSON desde `rootBundle`; y se restablece el `GoRouter` global y el notificador entre tests para evitar contaminación de estado.

5. **Transición gradual tipo iOS:** todos los cambios visuales ahora se interpolan durante exactamente los mismos 500 ms que dura la animación del toggle: `AnimatedContainer` (500 ms, `Curves.easeInOut`) en los fondos de las cuatro pantallas y en los contenedores naranja y de vidrio del `SelectorWidget`; `AnimatedSwitcher` con cross-fade para el engranaje y el ícono de mapa; y `TweenAnimationBuilder<Color>` para el color de los textos de ajustes y del botón de retroceso.

6. **`ReturnButton` dinámico:** antes mantenía su color estático ante el cambio de modo; ahora alterna entre azul claro `Color.fromRGBO(113, 203, 248, 100)` en modo claro y azul oscuro `Color.fromRGBO(13, 97, 255, 30)` en modo oscuro, con transición gradual de 500 ms.
