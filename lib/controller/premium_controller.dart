import "package:get/get.dart";
import "package:ricemoto/configs/app_config.dart";
import "package:ricemoto/values/app_strings.dart";

/// Subscription options on the Premium screen.
enum PremiumPlan { monthly, yearly }

extension PremiumPlanInfo on PremiumPlan {
  String get labelKey {
    switch (this) {
      case PremiumPlan.monthly:
        return AppStrings.iapPlanMonthly;
      case PremiumPlan.yearly:
        return AppStrings.iapPlanYearly;
    }
  }

  /// Price in VND đồng.
  int get price {
    switch (this) {
      case PremiumPlan.monthly:
        return 29000;
      case PremiumPlan.yearly:
        return 290000;
    }
  }
}

/// Backs the Premium / IAP screen. Wire [subscribe] to a real store flow
/// (StoreKit / Play Billing) when available.
class PremiumController extends GetxController {
  /// Yearly is highlighted by default (best value).
  final Rx<PremiumPlan> plan = PremiumPlan.yearly.obs;

  String get title =>
      "${AppConfig.appName} ${AppStrings.iapPremiumSuffix.tr}";

  void select(PremiumPlan value) => plan.value = value;

  void subscribe() => Get.snackbar(
        title,
        AppStrings.featureComingSoon.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
}
