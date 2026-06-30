import "package:dsp_base/app_localize.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ricemoto/configs/app_routes.dart";
import "package:ricemoto/services/storage_service.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";

/// Theme options surfaced in the "Chủ đề" picker. Only [light] is wired to a
/// real theme today; the others are stored as a preference for when a dark
/// theme is added.
enum AppThemeChoice { light, dark, system }

extension AppThemeChoiceLabel on AppThemeChoice {
  String get labelKey {
    switch (this) {
      case AppThemeChoice.light:
        return AppStrings.setThemeLight;
      case AppThemeChoice.dark:
        return AppStrings.setThemeDark;
      case AppThemeChoice.system:
        return AppStrings.setThemeSystem;
    }
  }
}

/// Backs the Account/Settings tab: profile summary, preference toggles, and the
/// destructive logout / delete-account actions.
///
/// Profile data is a local stub — swap [fullName] / [phoneNumber] for the real
/// user once the backend persists one (see [StorageService]).
class SettingsController extends GetxController {
  // --- Profile (stub) --------------------------------------------------------

  bool get isLoggedIn => StorageService.isLoggedIn;

  final RxString fullName = "Nguyễn Văn A".obs;
  final RxString phoneNumber = "0912 345 678".obs;
  final RxString email = "".obs;

  /// Persist the edited profile (in-memory stub for now).
  void updateProfile({required String name, required String email}) {
    if (name.trim().isNotEmpty) fullName.value = name.trim();
    this.email.value = email.trim();
  }

  // --- Guest actions ---------------------------------------------------------

  void goToRegister() => Get.toNamed(AppRoutes.register);

  void goToLogin() => Get.toNamed(AppRoutes.login);

  /// Tapped a feature that requires an account while in guest mode.
  void lockedTap() => Get.snackbar(
        AppStrings.setGuestTitle.tr,
        AppStrings.setLockedHint.tr,
        snackPosition: SnackPosition.BOTTOM,
      );

  // --- Preferences -----------------------------------------------------------

  final RxBool notifications = true.obs;

  /// Translation key for the last-sync subtitle.
  final RxString lastSyncKey = AppStrings.setBackupSynced.obs;

  /// Current UI language code ("vi" / "en"), kept reactive for the trailing
  /// value label.
  late final RxString languageCode = CommLocalize.getAppLocale().languageCode.obs;

  final Rx<AppThemeChoice> theme = AppThemeChoice.light.obs;

  String get languageLabelKey =>
      languageCode.value == "vi" ? AppStrings.setLangVi : AppStrings.setLangEn;

  void toggleNotifications(bool value) => notifications.value = value;

  Future<void> setLanguage(Locale locale) async {
    await CommLocalize.setAppLocale(locale);
    languageCode.value = locale.languageCode;
  }

  void setTheme(AppThemeChoice choice) => theme.value = choice;

  void openTheme() => Get.toNamed(AppRoutes.theme);

  // --- Navigation ------------------------------------------------------------

  void editProfile() => Get.toNamed(AppRoutes.editProfile);

  void upgradePremium() => Get.toNamed(AppRoutes.premium);

  void backupSync() => Get.toNamed(AppRoutes.backupSync);

  void exportData() => Get.toNamed(AppRoutes.exportData);

  void openTerms() => Get.toNamed(AppRoutes.terms);

  // --- Destructive actions ---------------------------------------------------

  void confirmLogout() => _confirm(
        titleKey: AppStrings.setLogoutConfirmTitle,
        messageKey: AppStrings.setLogoutConfirmMsg,
        confirmKey: AppStrings.setLogout,
        onConfirm: _signOut,
      );

  void confirmDelete() => _confirm(
        titleKey: AppStrings.setDeleteConfirmTitle,
        messageKey: AppStrings.setDeleteConfirmMsg,
        confirmKey: AppStrings.setDelete,
        onConfirm: _signOut,
      );

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      // Firebase not configured on this platform — clear local state anyway.
    }
    await StorageService.clearTokens();
    await StorageService.setLoggedIn(false);
    Get.offAllNamed(AppRoutes.welcome);
  }

  void _confirm({
    required String titleKey,
    required String messageKey,
    required String confirmKey,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(titleKey.tr),
        content: Text(messageKey.tr),
        actions: <Widget>[
          TextButton(
            onPressed: Get.back,
            child: Text(
              AppStrings.cancel.tr,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(
              confirmKey.tr,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
