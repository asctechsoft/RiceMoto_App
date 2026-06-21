import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/register_controller.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8.h),
                Text(AppStrings.createAccount.tr, style: AppTextStyles.heading),
                SizedBox(height: 8.h),
                Text(
                  AppStrings.registerSubtitle.tr,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 32.h),
                _Field(
                  label: AppStrings.fullName.tr,
                  controller: controller.nameCtrl,
                  icon: Icons.person_outline,
                  validator: controller.validateRequired,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16.h),
                _Field(
                  label: AppStrings.email.tr,
                  controller: controller.emailCtrl,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16.h),
                _Field(
                  label: AppStrings.phone.tr,
                  controller: controller.phoneCtrl,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: controller.validateRequired,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => _Field(
                    label: AppStrings.password.tr,
                    controller: controller.passwordCtrl,
                    icon: Icons.lock_outline,
                    obscureText: controller.obscurePassword.value,
                    validator: controller.validatePassword,
                    textInputAction: TextInputAction.done,
                    suffix: IconButton(
                      onPressed: controller.toggleObscure,
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Obx(
                  () => PrimaryButton(
                    label: AppStrings.register.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.submit,
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppStrings.alreadyHaveAccount.tr,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          AppStrings.signIn.tr,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textHint),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }
}
