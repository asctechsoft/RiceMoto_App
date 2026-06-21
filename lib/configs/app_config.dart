/// App-wide static configuration / feature flags.
class AppConfig {
  const AppConfig._();

  static const String appName = "RiceMoto";

  /// Root asset folder for this app's localization files.
  static const String localizationRoot = "lib/xml_strings";
  static const String localizationFile = "strings.xml";

  /// Splash display duration before routing onward.
  static const Duration splashDuration = Duration(milliseconds: 2200);
}
