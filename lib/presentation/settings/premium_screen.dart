import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/premium_controller.dart";
import "package:ricemoto/presentation/home/widgets/expense_history_list.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Premium / IAP paywall. Lists Premium benefits and the monthly / yearly
/// plans, then a single subscribe CTA. Pushed from the Account tab.
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  static const List<String> _features = <String>[
    AppStrings.iapFeature1,
    AppStrings.iapFeature2,
    AppStrings.iapFeature3,
    AppStrings.iapFeature4,
    AppStrings.iapFeature5,
    AppStrings.iapFeature6,
    AppStrings.iapFeature7,
    AppStrings.iapFeature8,
  ];

  @override
  Widget build(BuildContext context) {
    final PremiumController controller = Get.isRegistered<PremiumController>()
        ? Get.find<PremiumController>()
        : Get.put(PremiumController());

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: Get.back,
                icon: Icon(Icons.close_rounded, color: AppColors.white, size: 24.w),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 12.h),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 76.w,
                      height: 76.w,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.workspace_premium_rounded,
                          size: 44.w, color: AppColors.guestBanner),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      controller.title,
                      style: AppTextStyles.heading.copyWith(
                        color: AppColors.white,
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                        5,
                        (_) => Icon(Icons.star_rounded,
                            size: 18.w, color: AppColors.guestBanner),
                      ),
                    ),
                    SizedBox(height: 22.h),
                    ..._features.map((String key) => _FeatureRow(labelKey: key)),
                  ],
                ),
              ),
            ),
            _BottomSection(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.labelKey});

  final String labelKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        children: <Widget>[
          Icon(Icons.check_circle_rounded,
              size: 20.w, color: AppColors.primaryLight),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              labelKey.tr,
              style: AppTextStyles.body.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSection extends StatelessWidget {
  const _BottomSection({required this.controller});

  final PremiumController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.30),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Obx(
            () => Row(
              children: <Widget>[
                Expanded(
                  child: _PlanCard(
                    plan: PremiumPlan.monthly,
                    selected: controller.plan.value == PremiumPlan.monthly,
                    onTap: () => controller.select(PremiumPlan.monthly),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _PlanCard(
                    plan: PremiumPlan.yearly,
                    selected: controller.plan.value == PremiumPlan.yearly,
                    onTap: () => controller.select(PremiumPlan.yearly),
                    badgeKey: AppStrings.iapBadgeSave,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: controller.subscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.guestBanner,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                AppStrings.iapCta.tr,
                style: AppTextStyles.button.copyWith(
                  color: AppColors.guestBannerText,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            AppStrings.iapFooter.tr,
            style: AppTextStyles.caption.copyWith(color: AppColors.white70),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
    this.badgeKey,
  });

  final PremiumPlan plan;
  final bool selected;
  final VoidCallback onTap;
  final String? badgeKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.guestBanner.withValues(alpha: 0.16)
              : AppColors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected
                ? AppColors.guestBanner
                : AppColors.white.withValues(alpha: 0.25),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          children: <Widget>[
            if (badgeKey != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.guestBanner,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  badgeKey!.tr,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10.sp,
                    color: AppColors.guestBannerText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            else
              SizedBox(height: 18.h),
            SizedBox(height: 8.h),
            Text(
              plan.labelKey.tr,
              style: AppTextStyles.body.copyWith(
                color: AppColors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatMoney(plan.price),
                style: AppTextStyles.title.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
