import "package:get/get.dart";
import "package:ricemoto/configs/app_config.dart";
import "package:ricemoto/configs/app_routes.dart";
import "package:ricemoto/services/storage_service.dart";

/// Decides the first screen after the splash animation.
class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(AppConfig.splashDuration);

    if (StorageService.isLoggedIn || StorageService.hasVehicle) {
      Get.offAllNamed(AppRoutes.home);
    } else if (StorageService.onboardingSeen) {
      Get.offAllNamed(AppRoutes.welcome);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}
