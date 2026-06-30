import "package:dsp_base/app_localize.dart";
import "package:dsp_base/comm_app.dart";
import "package:dsp_base/convenience_imports.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:ricemoto/configs/app_config.dart";
import "package:ricemoto/configs/app_pages.dart";
import "package:ricemoto/configs/app_theme.dart";
import "package:ricemoto/firebase_options.dart";

Future<void> main() async {
  // Load local environment config (API_HOST, API_PORT) from app.env.
  // Silently skipped if the file is missing (emulator / CI defaults apply).
  await dotenv.load(fileName: "app.env", mergeWith: {}).catchError((_) {});

  // commRunApp() replaces runApp(): it boots SharedPrefs, device
  // classification, localization and (when configured) Firebase/Crashlytics.
  await commRunApp(
    () => const RiceMotoApp(),
    onBindingInitialized: (_) async {
      // Default to Vietnamese for new installs (user can switch in-app at any time).
      if (CommLocalize.getConfiguredLocale() == null) {
        await PrefAssist.setString(PrefComm.CONFIGURED_LOCALE_BY_USER, "vi_VN");
        // Reload dsp_base strings in Vietnamese now that the default is set.
        await CommLocalize.loadTranslations(
          "packages/dsp_base/lib/xml_strings",
          "strings.xml",
          isChangeLocale: true,
        );
      }

      // Initialize Firebase first so dsp_base's commRunApp wires up
      // Crashlytics (it checks Firebase.apps.isNotEmpty afterwards).
      // Guarded so unconfigured platforms (iOS/web) don't crash startup.
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (e) {
        debugPrint("[RiceMoto] Firebase skipped: $e");
      }

      // Load this app's own XML strings on top of dsp_base's built-in set.
      await CommLocalize.loadTranslations(
        AppConfig.localizationRoot,
        AppConfig.localizationFile,
      );
    },
  );
}

class RiceMotoApp extends StatelessWidget {
  const RiceMotoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CommApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: CommLocalize.getAppLocale(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
