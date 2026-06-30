import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/controller/vehicle_setup_controller.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

class VehicleSetupScreen extends GetView<VehicleSetupController> {
  const VehicleSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
          child: Column(
            children: <Widget>[
              const _SetupHeader(),
              SizedBox(height: 16.h),
              Text(
                AppStrings.addVehicleTitle.tr,
                style: AppTextStyles.heading.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                AppStrings.addVehicleSubtitle.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _Label(text: AppStrings.vehicleName.tr),
                    _Input(
                      controller: controller.nameCtrl,
                      hint: AppStrings.vehicleNameHint.tr,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 18.h),
                    _Label(text: AppStrings.vehicleBrand.tr),
                    _BrandChips(controller: controller),
                    SizedBox(height: 18.h),
                    _Label(text: AppStrings.currentKm.tr),
                    _Input(
                      controller: controller.kmCtrl,
                      hint: AppStrings.currentKmHint.tr,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      prefixIcon: Icon(
                        Icons.speed_rounded,
                        size: 20.w,
                        color: AppColors.primary,
                      ),
                      suffixText: AppStrings.kmUnit.tr,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 18.h),
                    _Label(text: AppStrings.licensePlate.tr),
                    _Input(
                      controller: controller.plateCtrl,
                      hint: AppStrings.licensePlateHint.tr,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Obx(
                () => PrimaryButton(
                  label: AppStrings.enterApp.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.submit,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                AppStrings.addInfoLater.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixText,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final String? suffixText;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textHint),
        prefixIcon: prefixIcon,
        suffixText: suffixText,
        suffixStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }
}

/// Simple illustration header for the vehicle-setup form.
/// Uses a fixed height and no AspectRatio so it never crashes in
/// unbounded-height scroll contexts.
class _SetupHeader extends StatelessWidget {
  const _SetupHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Center(
        child: Container(
          width: 88.w,
          height: 88.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.motorcycle, size: 48.w, color: AppColors.primary),
        ),
      ),
    );
  }
}

class _BrandChips extends StatelessWidget {
  const _BrandChips({required this.controller});

  final VehicleSetupController controller;

  @override
  Widget build(BuildContext context) {
    final List<String> brands = <String>[
      ...VehicleSetupController.brands,
      AppStrings.brandOther.tr,
    ];
    return Obx(
      () => Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: brands.map((String brand) {
          final bool selected = controller.selectedBrand.value == brand;
          return GestureDetector(
            onTap: () => controller.selectBrand(brand),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.divider,
                ),
              ),
              child: Text(
                brand,
                style: AppTextStyles.body.copyWith(
                  color: selected ? AppColors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
