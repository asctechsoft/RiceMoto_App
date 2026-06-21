// Firebase configuration for RiceMoto.
//
// Android values are taken from android/app/google-services.json.
// iOS/macOS/web are NOT configured yet — provide a GoogleService-Info.plist
// (and run `flutterfire configure`) before shipping those platforms.

import "package:firebase_core/firebase_core.dart" show FirebaseOptions;
import "package:flutter/foundation.dart"
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        "Web is not configured. Run `flutterfire configure` to add it.",
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          "iOS is not configured yet. Add GoogleService-Info.plist and run "
          "`flutterfire configure`.",
        );
      default:
        throw UnsupportedError(
          "DefaultFirebaseOptions are not configured for "
          "$defaultTargetPlatform.",
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyCDXhCrisj6OvV1bN54O3NzczaT6Htu0Vo",
    appId: "1:810964655230:android:8445d3487cae4431080c2f",
    messagingSenderId: "810964655230",
    projectId: "ricemoto",
    storageBucket: "ricemoto.firebasestorage.app",
  );
}
