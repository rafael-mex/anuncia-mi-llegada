# Parche local de `adaptive_platform_ui`

Este directorio contiene una copia local de `adaptive_platform_ui` **1.0.2**
(https://pub.dev/packages/adaptive_platform_ui), usada mediante
`dependency_overrides` en el `pubspec.yaml` de la app.

## ¿Por qué está aquí y no como dependencia normal?

La versión publicada en pub.dev aplica en `android/build.gradle`:

- un `buildscript` con AGP 7.3.0 y Kotlin 1.7.10, y
- `apply plugin: 'kotlin-android'`.

Eso rompe el build de Android de este proyecto, que usa AGP 9.0.1 y
Gradle 9.1.0. El código Android del paquete es únicamente un stub vacío
(no aporta nada: todos los widgets son Dart), así que el parche es seguro.

## Cambios aplicados

1. `android/build.gradle` reescrito sin `buildscript` ni Kotlin: usa solo
   `com.android.library`, `compileSdk 36`, Java 17 y `minSdk 21`.
2. El stub `AdaptivePlatformUiPlugin.kt` se reemplazó por su equivalente en
   Java (`android/src/main/java/.../AdaptivePlatformUiPlugin.java`) para no
   depender del Kotlin Gradle Plugin.
3. Se quitó la sección `screenshots` del `pubspec.yaml` y se excluyeron de la
   copia `img/`, `example/` y `test/` (solo documentación, no afectan la app).
4. `AdaptiveAlertDialog.show` ahora acepta `barrierDismissible` (por defecto
   `true`) y lo reenvía a `showCupertinoDialog`/`showDialog`. Upstream lo
   ignoraba, por lo que los diálogos con `barrierDismissible: false` (por
   ejemplo el de borrar un elemento del historial) se podían cerrar tocando
   fuera en iOS. Sin este parche, la app esperaba hasta el timeout de 60 s.

## Cuándo eliminar este parche

Cuando upstream corrija el `build.gradle` para AGP 9 / Gradle 9 (issue #160),
se puede borrar `third_party/adaptive_platform_ui` y quitar el
`dependency_overrides`, dejando únicamente:

```yaml
adaptive_platform_ui: ^1.0.2
```
