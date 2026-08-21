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

