import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/onboarding_controller.dart";
import "package:ricemoto/models/onboarding_item.dart";
import "package:ricemoto/presentation/widgets/illustration_frame.dart";
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
            _SkipButton(controller: controller),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (_, int index) =>
                    _OnboardingPage(item: controller.pages[index]),
              ),
            ),
            SizedBox(height: 24.h),
            // Bottom action: page dots while browsing, CTA on the last page.
            SizedBox(
              height: 56.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Obx(
                  () => controller.isLastPage
                      ? PrimaryButton(
                          label: AppStrings.getStarted.tr,
                          onPressed: controller.next,
                        )
                      : Center(child: _Indicator(controller: controller)),
                ),
              ),
            ),
            SizedBox(height: 36.h),
          ],
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.controller});

  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: 16.w, top: 8.h),
        child: Obx(
          () => AnimatedOpacity(
            opacity: controller.isLastPage ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: TextButton(
              onPressed: controller.isLastPage ? null : controller.skip,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              ),
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
      padding: EdgeInsets.fromLTRB(28.w, 8.h, 28.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Illustration frame (fills the upper area, centered).
          Expanded(
            child: Center(
              child: IllustrationFrame(image: item.image, icon: item.icon),
            ),
          ),
          SizedBox(height: 28.h),
          Text(
            item.titleKey.tr,
            style: AppTextStyles.heading.copyWith(
              fontSize: 25.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            item.descKey.tr,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          SizedBox(height: 8.h),
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
        children: List<Widget>.generate(controller.pages.length, (int index) {
          final bool isActive = controller.currentPage.value == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOut,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            height: 8.h,
            width: isActive ? 28.w : 8.w,
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
