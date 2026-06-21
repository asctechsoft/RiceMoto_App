// PLACEHOLDER — generate the real file with the FlutterFire CLI:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// That command overwrites this file with valid platform options and wires up
// google-services.json / GoogleService-Info.plist. Until then, do NOT call
// Firebase.initializeApp() — dsp_base's commRunApp() already no-ops Firebase
// features when no app is configured.

import "package:firebase_core/firebase_core.dart" show FirebaseOptions;
import "package:flutter/foundation.dart"
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        "Web is not configured. Run `flutterfire configure` to generate "
        "firebase_options.dart.",
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        throw UnimplementedError(
          "Firebase is not configured yet. Run `flutterfire configure` to "
          "generate the real firebase_options.dart before calling "
          "Firebase.initializeApp().",
        );
      default:
        throw UnsupportedError(
          "DefaultFirebaseOptions are not configured for "
          "$defaultTargetPlatform.",
        );
    }
  }
}
