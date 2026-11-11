package com.berkaycatak.adaptive_platform_ui;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * Android side of adaptive_platform_ui.
 *
 * <p>Android uses Material Design widgets directly in Dart, so this plugin has
 * no platform views and no work to do on the engine side.
 */
public class AdaptivePlatformUiPlugin implements FlutterPlugin {
  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    // No-op: Material widgets are rendered from Dart.
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    // No-op.
  }
}
