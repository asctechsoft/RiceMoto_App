import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/edit_profile_controller.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Edit Profile screen (pushed from the Account tab).
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller =
        Get.isRegistered<EditProfileController>()
            ? Get.find<EditProfileController>()
            : Get.put(EditProfileController());

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
                  _Avatar(controller: controller),
                  SizedBox(height: 24.h),
                  _LabeledField(
                    labelKey: AppStrings.fullName,
                    controller: controller.nameCtrl,
                  ),
                  SizedBox(height: 16.h),
                  _LabeledField(
                    labelKey: AppStrings.phone,
                    value: controller.phone,
                    enabled: false,
                    helperKey: AppStrings.epPhoneLocked,
                  ),
                  SizedBox(height: 16.h),
                  _LabeledField(
                    labelKey: AppStrings.email,
                    controller: controller.emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
              child: PrimaryButton(
                label: AppStrings.save.tr,
                onPressed: controller.save,
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
              AppStrings.setEditProfile.tr,
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

class _Avatar extends StatelessWidget {
  const _Avatar({required this.controller});

  final EditProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: controller.changePhoto,
        child: Column(
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: 88.w,
                  height: 88.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.10),
                  ),
                  child: Icon(Icons.person_rounded,
                      size: 48.w, color: AppColors.primary),
                ),
                Positioned(
                  right: -2.w,
                  bottom: -2.h,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                    child: Icon(Icons.camera_alt_rounded,
                        size: 14.w, color: AppColors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              AppStrings.epChangePhoto.tr,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.labelKey,
    this.controller,
    this.value,
    this.enabled = true,
    this.helperKey,
    this.keyboardType,
  });

  final String labelKey;
  final TextEditingController? controller;
  final String? value;
  final bool enabled;
  final String? helperKey;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          labelKey.tr,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: value,
            hintStyle: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            filled: true,
            fillColor: enabled ? AppColors.surface : AppColors.background,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
            ),
          ),
        ),
        if (helperKey != null) ...<Widget>[
          SizedBox(height: 6.h),
          Text(
            helperKey!.tr,
            style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
          ),
        ],
      ],
    );
  }
}
