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

## AI Usage

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

### Integración de UI con `SelectorWidget`

El widget reutilizable `SelectorWidget` recibe dos parámetros principales:

- **`selectorsTitle`**: Título que se muestra en la parte superior del contenedor naranja con efecto glassmorphism.
- **`listContent`**: Widget (generalmente un `ListView.separated`) que se inyecta dentro del contenedor de vidrio para mostrar la lista de elementos interactivos.

### Implementación de pantallas

1. **`TransportsScreen`**: Utiliza un `FutureBuilder` que invoca `MiRepository().loadTransports()` con ambos booleanos en `true`. Muestra un `CircularProgressIndicator` durante la carga, maneja errores, y renderiza la lista de transportes en un `ListView.separated` dentro del `SelectorWidget`. Cada `ListTile` navega a `/lineas` pasando el `TransportsModel` completo.

2. **`LinesScreen`**: Recupera el `TransportsModel` desde `GoRouterState.of(context).extra`. Lista las líneas del transporte en un `ListView.separated`. Al seleccionar una línea, navega a `/estaciones` pasando el `LinesModel` correspondiente.

3. **`StationsScreen`**: Recupera el `LinesModel` desde `GoRouterState.of(context).extra`. Evalúa condicionalmente si `lineNameInMessage` no está vacío:
   - Si tiene texto: inyecta un `ListTile` adicional en la posición 0 con el texto "Únicamente mencionar el nombre de la línea" que imprime en consola el nombre de la línea.
   - Para el resto de elementos: lista las estaciones reales, compensando el índice cuando la sugerencia está activada, e imprime en consola el nombre de la estación seleccionada.

### Prompts utilizados

Se proporcionaron instrucciones detalladas y estructuradas que incluían:

1. **Tarea 1 - Actualización del Router**: Solicitó agregar dos rutas nuevas (`/lineas` y `/estaciones`) con nombres específicos y recepción de objetos de modelo vía `extra`.
2. **Tarea 2 - Integración de la UI**: Solicitó implementar el flujo completo de navegación entre tres pantallas con `FutureBuilder`, `SelectorWidget` y lógica condicional para estaciones.
3. **Tarea 3 - Documentación**: Solicitó crear esta sección de documentación técnica en español.

Los prompts fueron específicos en cuanto a la arquitectura existente (mencionando `mi_repository.dart`, `mi_model.dart`, `app_router.dart` y `SelectorWidget`), lo que permitió al modelo comprender el contexto completo y generar código consistente con los patrones ya establecidos en el proyecto.

