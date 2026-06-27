import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Static Terms of Service & Privacy Policy screen (pushed from Account tab).
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  static const List<List<String>> _sections = <List<String>>[
    <String>[AppStrings.termsS1Title, AppStrings.termsS1Body],
    <String>[AppStrings.termsS2Title, AppStrings.termsS2Body],
    <String>[AppStrings.termsS3Title, AppStrings.termsS3Body],
    <String>[AppStrings.termsS4Title, AppStrings.termsS4Body],
    <String>[AppStrings.termsS5Title, AppStrings.termsS5Body],
  ];

  String get _today {
    final DateTime d = DateTime.now();
    return "${d.day.toString().padLeft(2, "0")}/${d.month.toString().padLeft(2, "0")}/${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const _Header(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                children: <Widget>[
                  Text(
                    AppStrings.termsUpdated
                        .trParams(<String, String>{"date": _today}),
                    style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
                  ),
                  SizedBox(height: 16.h),
                  for (final List<String> s in _sections) ...<Widget>[
                    Text(
                      s[0].tr,
                      style: AppTextStyles.title.copyWith(fontSize: 15.sp),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      s[1].tr,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 18.h),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 4.h, 8.w, 8.h),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textPrimary),
          ),
          Expanded(
            child: Text(
              AppStrings.setTerms.tr,
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }
}
