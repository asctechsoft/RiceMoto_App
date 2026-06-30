import "package:dsp_base/app_localize.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Compact VI / EN toggle shown in the header of onboarding and welcome screens.
/// Calls [CommLocalize.setAppLocale] which triggers a full GetX locale rebuild.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final currentCode = Get.locale?.languageCode ?? "vi";
    return Container(
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(2.r),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _LangChip(
            label: "VI",
            isSelected: currentCode == "vi",
            onTap: () => CommLocalize.setAppLocale(const Locale("vi", "VN")),
          ),
          _LangChip(
            label: "EN",
            isSelected: currentCode == "en",
            onTap: () => CommLocalize.setAppLocale(const Locale("en", "US")),
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
