import "package:dsp_base/convenience_imports.dart";

/// Thin wrapper around dsp_base [PrefAssist] for app-specific keys.
class StorageService {
  const StorageService._();

  static const String _kOnboardingSeen = "ricemoto_onboarding_seen";
  static const String _kLoggedIn = "ricemoto_logged_in";

  static bool get onboardingSeen => PrefAssist.getBoolean(_kOnboardingSeen);

  static Future<void> setOnboardingSeen(bool value) =>
      PrefAssist.setBoolean(_kOnboardingSeen, value);

  static bool get isLoggedIn => PrefAssist.getBoolean(_kLoggedIn);

  static Future<void> setLoggedIn(bool value) =>
      PrefAssist.setBoolean(_kLoggedIn, value);
}
