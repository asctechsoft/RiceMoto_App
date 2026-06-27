import "package:get/get.dart";
import "package:ricemoto/configs/app_routes.dart";
import "package:ricemoto/controller/backup_controller.dart";
import "package:ricemoto/controller/camera_scan_controller.dart";
import "package:ricemoto/controller/edit_profile_controller.dart";
import "package:ricemoto/controller/export_controller.dart";
import "package:ricemoto/controller/forgot_password_controller.dart";
import "package:ricemoto/controller/history_controller.dart";
import "package:ricemoto/controller/premium_controller.dart";
import "package:ricemoto/controller/settings_controller.dart";
import "package:ricemoto/controller/home_controller.dart";
import "package:ricemoto/controller/login_controller.dart";
import "package:ricemoto/controller/onboarding_controller.dart";
import "package:ricemoto/controller/register_controller.dart";
import "package:ricemoto/controller/splash_controller.dart";
import "package:ricemoto/controller/vehicle_setup_controller.dart";
import "package:ricemoto/presentation/history/history_search_screen.dart";
import "package:ricemoto/presentation/home/home_screen.dart";
import "package:ricemoto/presentation/login/forgot_password_screen.dart";
import "package:ricemoto/presentation/login/login_screen.dart";
import "package:ricemoto/presentation/onboarding/onboarding_screen.dart";
import "package:ricemoto/presentation/register/register_screen.dart";
import "package:ricemoto/presentation/scan/camera_scan_screen.dart";
import "package:ricemoto/presentation/settings/backup_sync_screen.dart";
import "package:ricemoto/presentation/settings/edit_profile_screen.dart";
import "package:ricemoto/presentation/settings/export_data_screen.dart";
import "package:ricemoto/presentation/settings/premium_screen.dart";
import "package:ricemoto/presentation/settings/terms_screen.dart";
import "package:ricemoto/presentation/settings/theme_screen.dart";
import "package:ricemoto/presentation/splash/splash_screen.dart";
import "package:ricemoto/presentation/vehicle/vehicle_detail_screen.dart";
import "package:ricemoto/presentation/vehicle/vehicle_setup_screen.dart";
import "package:ricemoto/presentation/welcome/welcome_screen.dart";
import "package:ricemoto/repository/auth_repository.dart";

/// GetX page table + per-page dependency bindings.
class AppPages {
  const AppPages._();

  static const String initial = AppRoutes.splash;

  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        // Eager: SplashController.onReady drives navigation, so it must
        // be created even though the view never references it.
        Get.put<SplashController>(SplashController());
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OnboardingController>(OnboardingController.new);
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.welcome,
      page: () => const WelcomeScreen(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthRepository>(AuthRepository.new);
        Get.lazyPut<RegisterController>(
          () => RegisterController(Get.find<AuthRepository>()),
        );
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthRepository>(AuthRepository.new);
        Get.lazyPut<LoginController>(
          () => LoginController(Get.find<AuthRepository>()),
        );
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.vehicleSetup,
      page: () => const VehicleSetupScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<VehicleSetupController>(VehicleSetupController.new);
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(HomeController.new);
        Get.lazyPut<HistoryController>(HistoryController.new);
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.cameraScan,
      page: () => const CameraScanScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CameraScanController>(CameraScanController.new);
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.vehicleDetail,
      page: () => const VehicleDetailScreen(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.historySearch,
      page: () => const HistorySearchScreen(),
      binding: BindingsBuilder(() {
        // Normally already alive behind the History tab; guard for deep links.
        if (!Get.isRegistered<HistoryController>()) {
          Get.lazyPut<HistoryController>(HistoryController.new);
        }
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.backupSync,
      page: () => const BackupSyncScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<BackupController>(BackupController.new);
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.exportData,
      page: () => const ExportDataScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ExportController>(ExportController.new);
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.premium,
      page: () => const PremiumScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PremiumController>(PremiumController.new);
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.theme,
      page: () => const ThemeScreen(),
      binding: BindingsBuilder(() {
        // Normally already alive behind the Account tab; guard for deep links.
        if (!Get.isRegistered<SettingsController>()) {
          Get.lazyPut<SettingsController>(SettingsController.new);
        }
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<SettingsController>()) {
          Get.lazyPut<SettingsController>(SettingsController.new);
        }
        Get.lazyPut<EditProfileController>(EditProfileController.new);
      }),
    ),
    GetPage<dynamic>(
      name: AppRoutes.terms,
      page: () => const TermsScreen(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ForgotPasswordController>(ForgotPasswordController.new);
      }),
    ),
  ];
}
