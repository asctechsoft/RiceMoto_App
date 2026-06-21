import "package:flutter/widgets.dart";
import "package:get/get.dart";
import "package:ricemoto/configs/app_routes.dart";
import "package:ricemoto/models/onboarding_item.dart";
import "package:ricemoto/services/storage_service.dart";
import "package:ricemoto/values/app_assets.dart";
import "package:ricemoto/values/app_strings.dart";

/// Drives the 3-step onboarding pager.
class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingItem> pages = const <OnboardingItem>[
    OnboardingItem(
      image: AppAssets.onboard1,
      titleKey: AppStrings.onboardTitle1,
      descKey: AppStrings.onboardDesc1,
    ),
    OnboardingItem(
      image: AppAssets.onboard2,
      titleKey: AppStrings.onboardTitle2,
      descKey: AppStrings.onboardDesc2,
    ),
    OnboardingItem(
      image: AppAssets.onboard3,
      titleKey: AppStrings.onboardTitle3,
      descKey: AppStrings.onboardDesc3,
    ),
  ];

  bool get isLastPage => currentPage.value == pages.length - 1;

  void onPageChanged(int index) => currentPage.value = index;

  void next() {
    if (isLastPage) {
      _finish();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
      );
    }
  }

  void skip() => _finish();

  Future<void> _finish() async {
    await StorageService.setOnboardingSeen(true);
    Get.offAllNamed(AppRoutes.register);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
