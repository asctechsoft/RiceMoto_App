import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/onboarding_controller.dart";
import "package:ricemoto/models/onboarding_item.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Skip
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 12.w, top: 4.h),
                child: TextButton(
                  onPressed: controller.skip,
                  child: Text(
                    AppStrings.skip.tr,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) =>
                    _OnboardingPage(item: controller.pages[index]),
              ),
            ),
            _Indicator(controller: controller),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(
                () => PrimaryButton(
                  label: controller.isLastPage
                      ? AppStrings.getStarted.tr
                      : AppStrings.next.tr,
                  onPressed: controller.next,
                ),
              ),
            ),
            SizedBox(height: 28.h),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.item});

  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Illustration placeholder — swap for Image.asset(item.image)
          // once the artwork is dropped into assets/images.
          Container(
            width: 220.w,
            height: 220.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.image_outlined,
              size: 90.w,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 48.h),
          Text(
            item.titleKey.tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading,
          ),
          SizedBox(height: 14.h),
          Text(
            item.descKey.tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({required this.controller});

  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(controller.pages.length, (index) {
          final isActive = controller.currentPage.value == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            height: 8.h,
            width: isActive ? 24.w : 8.w,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.divider,
              borderRadius: BorderRadius.circular(8.r),
            ),
          );
        }),
      ),
    );
  }
}
