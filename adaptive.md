# Integración de `adaptive_platform_ui` — documentación

> Estado: **integrado en `develop`** mediante 4 commits (ver sección 9).
> La antigua rama `adaptive` fue eliminada después de integrar su único
> commit (`6bebae7`). Respaldo recuperable en
> `/private/var/folders/yy/ckh_q8rd661_fknjs0z6yqvw0000gn/T/opencode/adaptive-backup-6bebae7.bundle`.

---

## 1. Qué se hizo y por qué

Se integró el paquete `adaptive_platform_ui` **1.0.2** (vendorizado en
`third_party/adaptive_platform_ui`) para que los controles interactivos de la
pantalla de ajustes usen el control nativo de cada plataforma:

- **iOS 26+**: controles nativos de UIKit (platform views).
- **iOS 15–18**: equivalentes Cupertino.
- **Android**: Material Design.

La app **sigue usando `MaterialApp.router`**. No se reemplazó por `AdaptiveApp`
porque eso rompería `Theme`, `ScaffoldMessenger`/`SnackBar`, los widgets
Material existentes y la integración de Mapbox. El paquete se usa **solo en
hojas concretas del árbol de widgets**, no como shell de la aplicación.

Consecuencia importante: esto mejora la fidelidad visual en iOS, **no optimiza
el rendimiento ni reduce el tamaño**. Los costes medidos están en la sección 7.

---

## 2. Archivos modificados y líneas exactas

> Los números de línea corresponden al estado actual del árbol de trabajo.

### 2.1 `pubspec.yaml`

| Línea | Cambio |
|---|---|
| 52 | `adaptive_platform_ui: ^1.0.2` |
| 55–59 | `dependency_overrides` que apunta a `third_party/adaptive_platform_ui` |

El override es obligatorio: la versión publicada en pub.dev trae un
`android/build.gradle` incompatible con AGP 9 / Gradle 9. Ver sección 6.

### 2.2 `analysis_options.yaml`

| Línea | Cambio |
|---|---|
| 21–22 | Se excluye `third_party/**` del análisis estático (código de terceros) |

### 2.3 `lib/config/menu/settings_items.dart`

| Líneas | Cambio |
|---|---|
| 5 | Import de `package:adaptive_platform_ui/adaptive_platform_ui.dart` (sustituye a `flutter/cupertino.dart`) |
| 119, 173, 195, 256 | Los cuatro `SwitchListTile` pasan a `_AdaptiveSwitchTile` |
| 654–692 | `CupertinoMenuAnchor` + `CupertinoMenuItem` → `AdaptivePopupMenuButton.widget<String>` |
| 700–733 | Nueva clase `_AdaptiveSwitchTile` (fila + `AdaptiveSwitch`) |
| 891–901 | `CupertinoSlidingSegmentedControl` → `AdaptiveSegmentedControl` |
| 320 | `PlatformDialogAction(text: 'Rechazar', isCancel: true)` en el diálogo de borrar historial |

Otros cambios del diff son **solo formato** (espacios finales, indentación) y
la eliminación de `dynamicColor`/`MenuController` que ya no se usan.

**Por qué existe `_AdaptiveSwitchTile`:** la versión 1.0.2 no incluye
`AdaptiveSwitchListTile`. La clase replica el comportamiento de
`SwitchListTile`: `ListTile` con `AdaptiveSwitch` en `trailing` y `onTap` en
toda la fila para que tocar el texto también cambie el valor. El color de
acento se mantiene en `#F26400`.

### 2.4 `lib/utils/platform_dialog_helper.dart`

| Líneas | Cambio |
|---|---|
| 1 | Import del paquete |
| 7, 13 | Nuevo campo `isCancel` en `PlatformDialogAction` |
| 27–49 | Rama iOS: usa `AdaptiveAlertDialog.show` (iOS 26 nativo / Cupertino en versiones anteriores) |
| 32 | Se propaga `barrierDismissible` (requiere el parche local, ver 6.2) |
| 39–43 | Traducción de flags: `isDestructive` → `destructive`, `isCancel` → `cancel`, resto → `defaultAction` |
| 51–69 | Rama Android: `showDialog` + `AlertDialog` Material (sin cambios funcionales) |

### 2.5 `lib/presentation/screens/history_screen/history_screen.dart`

| Línea | Cambio |
|---|---|
| 71 | `isCancel: true` en la acción "Rechazar" del diálogo de eliminar |

### 2.6 `lib/presentation/widgets/buttons/reset_button.dart`

| Líneas | Cambio |
|---|---|
| 52–55 | `isCancel: true` en la acción "Rechazar" del diálogo de reset |

### 2.7 `test/messaging_app_selector_test.dart`

| Líneas | Cambio |
|---|---|
| 31–39 | Nuevo `_pumpHarness`: fija superficie 800×4000 para que el selector quede dentro del viewport |
| 46–50 | `setUp` que restablece la app de mensajería predeterminada |
| 54–68 | El test ya no busca `CupertinoMenuItem`; comprueba las opciones del menú adaptativo |
| 71–84 | Igual para la prueba de actualización de preferencia |

### 2.8 `third_party/adaptive_platform_ui/` (nuevo)

Copia local del paquete con los parches descritos en su `PATCHES.md`.
Incluye `lib/` (Dart), `ios/` (Swift + SPM) y `android/` (stub Java).

---

## 3. Cómo funciona la app a partir de ahora

### 3.1 Matriz de comportamiento

| Control | Android | iOS 15–18 | iOS 26+ |
|---|---|---|---|
| Interruptores de ajustes | `Switch` Material | `CupertinoSwitch` | `UISwitch` nativo (platform view) |
| Selector Claro/Oscuro/Sistema | `SegmentedButton` Material | `CupertinoSlidingSegmentedControl` | `UISegmentedControl` nativo |
| Selector de app de mensajería | `PopupMenuButton` Material | `CupertinoActionSheet` | menú contextual nativo |
| Diálogos (`showPlatformDialog`) | `AlertDialog` Material | `CupertinoAlertDialog` | `UIAlertController` nativo |
| Shell de la app, tema, snackbars | Material | Material | Material |

La decisión se toma **en runtime**. `PlatformInfo` lee `Platform.isIOS` y
`Platform.operatingSystemVersion`; si detecta iOS 26 o superior usa el widget
nativo, si detecta iOS usa Cupertino y si detecta Android usa Material.
No hay compilación condicional: el código Dart de las tres ramas viaja en
ambos binarios (el tree shaker elimina lo que no es alcanzable, no lo que es
condicional).

### 3.2 Lo que el usuario percibe

- **Android**: todo sigue siendo Material; los controles se ven y se comportan
  como antes (el `SwitchListTile` se sustituyó por una fila equivalente).
- **iOS 26**: switches, selector de tema, menú de mensajería y alertas se
  dibujan con UIKit nativo; gestos, animaciones, colores y accesibilidad los
  aporta el sistema.
- **iOS 15–18**: se mantiene el aspecto Cupertino clásico, sin platform views.

---

## 4. Sintaxis y semántica de la integración

### 4.1 Regla de oro

Solo se usa para **controles concretos**. No se debe envolver la app en
`AdaptiveApp` ni sustituir `MaterialApp`, `Scaffold`, `Navigator` o
`Theme` por equivalentes del paquete.

### 4.2 `AdaptiveSwitch`

```dart
AdaptiveSwitch(
  value: value,                    // bool, controlado
  onChanged: onChanged,            // null = deshabilitado
  activeColor: const Color(0xFFF26400), // color del track/on
  thumbColor: null,                // opcional
)
```

- Es un widget **sin estado**: hay que reconstruirlo con el nuevo `value`
  (aquí lo hace `ValueListenableBuilder`).
- `onChanged` recibe el valor nuevo, **no** el delta.
- En iOS <26, si `activeColor` es `null` conserva el verde del sistema.

### 4.3 `_AdaptiveSwitchTile` (privado de `settings_items.dart`)

```dart
_AdaptiveSwitchTile(
  title: Text('...'),
  subtitle: Text('...'),   // opcional
  value: value,
  onChanged: PreferencesService.metodo,
)
```

Semántica idéntica a `SwitchListTile`: tocar la fila o el interruptor cambia
el valor. No usar `SwitchListTile` con `AdaptiveSwitch` dentro; esta clase ya
resuelve el layout y el área táctil.

### 4.4 `AdaptiveSegmentedControl`

```dart
AdaptiveSegmentedControl(
  labels: const ['Claro', 'Oscuro', 'Sistema'],
  selectedIndex: selected,          // índice 0..n-1
  onValueChanged: (index) { ... },  // int, nunca null
  color: ...,
  selectedTextColor: Colors.white,
  height: 36,
  shrinkWrap: true,
)
```

- `selectedIndex` es obligatorio y debe ser válido; si el estado puede no
  coincidir, normalízalo antes (como se hace con `firstWhere` + `orElse`).
- `onValueChanged` entrega el índice seleccionado.
- `shrinkWrap: true` centra el control y evita que ocupe todo el ancho.

### 4.5 `AdaptivePopupMenuButton` / `AdaptivePopupMenuItem`

```dart
AdaptivePopupMenuButton.widget<String>(
  items: [
    AdaptivePopupMenuItem<String>(
      label: 'WhatsApp',   // texto mostrado
      icon: Icons.phone,   // IconData
      selected: value == 'WhatsApp',
      value: 'WhatsApp',   // valor tipado que recibirás
    ),
  ],
  onSelected: (index, item) {
    final selectedApp = item.value; // T?
  },
  child: ...,
)
```

- `T` es el tipo del valor. `onSelected` recibe **el índice y la entrada**;
  el valor de negocio está en `item.value`.
- `selected: true` muestra la marca de selección.
- En iOS 26 se abre como menú nativo; en iOS <26 como action sheet; en Android
  como `PopupMenuButton` Material. El `child` es el disparador.
- Si el menú se usa en un `ListTile`, mantén el `child` compacto; el paquete
  gestiona el área táctil.

### 4.6 `showPlatformDialog`

Misma firma que antes, más `isCancel`:

```dart
showPlatformDialog(
  context: context,
  title: '¿Eliminar?',
  content: 'No se puede deshacer',
  barrierDismissible: false,
  actions: [
    PlatformDialogAction(text: 'Rechazar', isCancel: true),
    PlatformDialogAction(
      text: 'Continuar',
      isDestructive: true,
      onPressed: () { ... },
    ),
  ],
);
```

Semántica:

- `isDestructive` → rojo en iOS, `isDestructiveAction` en Cupertino.
- `isCancel` → botón de cancelación separado/negrita en iOS 26 y
  `isDefaultAction` en Cupertino. **En Android no cambia el aspecto**: los
  botones siguen siendo `TextButton` Material.
- El diálogo se cierra antes de ejecutar `onPressed` en ambas plataformas.
- `barrierDismissible: false` impide cerrar tocando fuera **también en iOS**
  (esto depende del parche local descrito en 6.2).
- El valor de retorno solo indica que el diálogo se cerró; usa `onPressed`
  para la lógica.

### 4.7 Añadir un control adaptativo nuevo (checklist)

1. Importar `package:adaptive_platform_ui/adaptive_platform_ui.dart`.
2. Usar el widget adaptativo solo en la hoja concreta, no en el shell.
3. Mantener el estado en la app (el paquete no guarda estado).
4. No meter platform views iOS dentro de listas largas o animaciones pesadas:
   cada una crea una `UIView` nativa y tiene coste de composición.
5. Probar en iOS 26 (nativo), iOS 15–18 (Cupertino) y Android (Material).
6. No editar `ios/Flutter/ephemeral/`: es generado por Flutter/SPM.

---

## 5. Requisitos de plataforma

| Requisito | Valor actual | Estado |
|---|---|---|
| iOS mínimo del proyecto | 15.0 | Coincide con el paquete (`Package.swift` y podspec) |
| Android `minSdk` | el de Flutter (24) | El paquete pide 21; compatible |
| Android `compileSdk` del paquete | 36 | Compatible con el proyecto |
| Java del paquete | 17 | Coincide con el proyecto |
| Swift | 5.0 / tools 5.9 | Compatible con Xcode actual |
| Gestor iOS | Swift Package Manager | El paquete se enlaza como producto SPM |

No hay que subir el deployment target ni tocar `Info.plist` para que funcione.

---

## 6. Build y mantenimiento

### 6.1 Comandos

```bash
flutter pub get
./build_apk.sh                 # release Android con token de Mapbox
flutter build ios --release --no-codesign
```

`mapbox.env` no está versionado; cópialo desde `mapbox.env.example`.

### 6.2 Parches locales (ver `third_party/adaptive_platform_ui/PATCHES.md`)

1. **AGP 9 / Gradle 9**: `android/build.gradle` reescrito sin `buildscript`
   viejo ni Kotlin; stub en Java.
2. **`barrierDismissible`**: `AdaptiveAlertDialog.show` ahora acepta el
   parámetro y lo reenvía a `showCupertinoDialog`/`showDialog`
   (`third_party/.../adaptive_alert_dialog.dart`, líneas 50, 64, 80, 98, 200,
   347 y 353). Sin este parche, el diálogo de borrar historial se podía cerrar
   tocando fuera y la app esperaba 60 s al timeout.

### 6.3 Actualizar el paquete

1. Copiar la nueva versión a `third_party/adaptive_platform_ui`.
2. Reaplicar ambos parches.
3. `flutter pub get`, `flutter analyze` y build en ambas plataformas.
4. Si upstream ya corrige AGP 9, se puede volver a la dependencia normal:
   borrar `third_party/`, quitar `dependency_overrides` y dejar
   `adaptive_platform_ui: ^x.y.z`.

### 6.4 Problemas típicos

| Síntoma | Causa / solución |
|---|---|
| Xcode no encuentra el paquete | `flutter clean && flutter pub get` (regenera SPM) |
| Build Android falla en `build.gradle` del paquete | Revisar que el override apunta a `third_party` |
| El widget iOS no cambia tras hot reload | Hot restart: los `creationParams` de platform views no se refrescan |
| `flutter analyze` revisa `third_party` | Confirmar la exclusión en `analysis_options.yaml` |

---

## 7. Coste medido (release, misma configuración)

Comparación real con y sin la dependencia, con `--split-per-abi` y
`--dart-define-from-file=mapbox.env`:

| Métrica | Con dependencia | Sin dependencia | Diferencia |
|---|---:|---:|---:|
| APK `arm64-v8a` | 50.745.778 B | 50.679.614 B | **+64,6 KiB (+0,13 %)** |
| `libapp.so` (Dart AOT) | 6.685.576 B | 6.620.040 B | +64,0 KiB |
| `Runner` iOS (nativo) | 16.035.480 B | 15.375.288 B | **+644,7 KiB** |
| `App.framework/App` (Dart) | 7.315.072 B | 7.249.024 B | +64,5 KiB |
| `Runner.app` comprimido | 26.191.326 B | 25.964.731 B | **+221,3 KiB (+0,87 %)** |

Lectura: en Android el coste es casi todo Dart; en iOS la mayor parte es el
Swift nativo enlazado por SPM, que incluye la dependencia transitiva
`foldable` (plugin solo-iOS para iPhone Duo). Si en el futuro se quiere
recuperar ese espacio, la palanca es quitar `foldable`, no el paquete.

---

## 8. Verificación realizada

- `flutter analyze`: solo 3 `info` preexistentes en
  `lib/config/menu/custom_location_items.dart` (`use_build_context_synchronously`).
- `flutter test`: 29 pasan; 5 fallos preexistentes no relacionados
  (`test/map_icon_svg_test.dart` ×3, `test/theme_visual_test.dart` ×2).
- Build release Android (`--split-per-abi`) correcto **después** del parche de
  `barrierDismissible`.
- Build release iOS (`--no-codesign`) correcto **después** del parche.
- Build para simulador iOS y arranque real en iPhone 17 Pro Max (iOS 26.5):
  la app arranca, permanece en ejecución y el log no muestra excepciones de
  Flutter ni de platform views.
- La integración ya se había verificado en runtime en emulador Android y
  simulador iOS 26 (switches, selector de tema, menú de mensajería y diálogos).
- Pendiente de prueba manual automatizada: cerrar tocando fuera un diálogo con
  `barrierDismissible: false` en iOS. El parámetro ya se propaga y compila; la
  comprobación visual requiere navegar al historial en el simulador.

---

## 9. Reversión

Los cambios están commiteados en `develop` en 4 commits (dependencia,
ajustes, diálogos y documentación). Para revertir la integración completa:

```bash
git revert --no-commit 09bba42..HEAD
git commit -m "revert: elimina la integración adaptativa"
```

Para recuperar el commit original de la rama eliminada:

```bash
git bundle verify /private/var/folders/yy/ckh_q8rd661_fknjs0z6yqvw0000gn/T/opencode/adaptive-backup-6bebae7.bundle
git fetch /private/var/folders/yy/ckh_q8rd661_fknjs0z6yqvw0000gn/T/opencode/adaptive-backup-6bebae7.bundle 6bebae7:rescate-adaptive
```

---

## 10. Recomendaciones

1. Mantener `third_party/` versionado junto con el resto (es parte del build).
2. Añadir una prueba de humo en iOS 26 y otra en iOS 18 si se puede; el
   fallback Cupertino no se ejercita en el simulador 26.
3. Evaluar en el futuro quitar `foldable` del paquete vendorizado para
   recuperar ~645 KiB en iOS.
4. No presentar esta integración como optimización: es fidelidad visual.
