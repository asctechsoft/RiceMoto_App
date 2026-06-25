import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Bottom sheet shown from the center "Add expense" button, offering to
/// capture a receipt with the camera or pick one from the gallery.
class ReceiptSourceSheet extends StatelessWidget {
  const ReceiptSourceSheet({
    required this.onCamera,
    required this.onGallery,
    super.key,
  });

  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                AppStrings.addReceiptTitle.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 4.h),
              Text(
                AppStrings.addReceiptSubtitle.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption,
              ),
              SizedBox(height: 20.h),
              _SourceTile(
                icon: Icons.camera_alt_rounded,
                title: AppStrings.captureReceipt.tr,
                subtitle: AppStrings.captureReceiptDesc.tr,
                onTap: onCamera,
              ),
              SizedBox(height: 12.h),
              _SourceTile(
                icon: Icons.photo_library_rounded,
                title: AppStrings.chooseFromGallery.tr,
                subtitle: AppStrings.chooseFromGalleryDesc.tr,
                onTap: onGallery,
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: Get.back,
                child: Text(
                  AppStrings.cancel.tr,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24.w),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2.h),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 22.w, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
