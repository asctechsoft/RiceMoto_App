import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/configs/app_config.dart";
import "package:ricemoto/controller/home_controller.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

class HomeTab extends GetView<HomeController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          if (controller.isGuest) _GuestBanner(controller: controller),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              children: <Widget>[
                _Header(controller: controller),
                SizedBox(height: 16.h),
                _VehicleCard(controller: controller),
                SizedBox(height: 16.h),
                const _TotalCostCard(),
                SizedBox(height: 24.h),
                _EmptyState(onRecord: controller.onScanPressed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestBanner extends StatelessWidget {
  const _GuestBanner({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.guestBanner,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: <Widget>[
          Icon(Icons.info_outline_rounded,
              size: 16.w, color: AppColors.guestBannerText),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              AppStrings.guestBanner.tr,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.guestBannerText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: controller.goToRegister,
            child: Text(
              AppStrings.register.tr,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          AppConfig.appName,
          style: AppTextStyles.heading.copyWith(fontSize: 22.sp),
        ),
        const Spacer(),
        _MonthPill(label: controller.monthLabel),
        const Spacer(),
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            size: 22.w,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _MonthPill extends StatelessWidget {
  const _MonthPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.calendar_today_rounded,
              size: 14.w, color: AppColors.primary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
          Icon(Icons.keyboard_arrow_down_rounded,
              size: 18.w, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final String plate = controller.vehicle?.plate.isNotEmpty ?? false
        ? controller.vehicle!.plate
        : (controller.vehicle?.name ?? "");

    return GestureDetector(
      onTap: controller.goToVehicleDetail,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[AppColors.primaryLight, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(Icons.two_wheeler_rounded,
                  size: 30.w, color: AppColors.white),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        AppStrings.myVehicle.tr,
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (controller.isGuest) const _GuestBadge(),
                    ],
                  ),
                  if (plate.isNotEmpty) ...<Widget>[
                    SizedBox(height: 8.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        plate,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Row(
                    children: <Widget>[
                      Icon(Icons.check_circle_rounded,
                          size: 14.w, color: AppColors.white),
                      SizedBox(width: 4.w),
                      Text(
                        AppStrings.vehicleActive.tr,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 24.w, color: AppColors.white70),
          ],
        ),
      ),
    );
  }
}

class _GuestBadge extends StatelessWidget {
  const _GuestBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.guestBanner,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        AppStrings.guestBadge.tr,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.guestBannerText,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TotalCostCard extends StatelessWidget {
  const _TotalCostCard();

  @override
  Widget build(BuildContext context) {
    final String unit = AppStrings.currencyUnit.tr;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(
              color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppStrings.totalCostMonth.tr,
                style:
                    AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.info_outline_rounded,
                  size: 15.w, color: AppColors.textHint),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "0 $unit",
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: <Widget>[
              _CategoryCard(
                icon: Icons.local_gas_station_rounded,
                label: AppStrings.catFuel.tr,
                amount: "0$unit",
              ),
              SizedBox(width: 10.w),
              _CategoryCard(
                icon: Icons.build_rounded,
                label: AppStrings.catRepair.tr,
                amount: "0$unit",
              ),
              SizedBox(width: 10.w),
              _CategoryCard(
                icon: Icons.water_drop_rounded,
                label: AppStrings.catOil.tr,
                amount: "0$unit",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.amount,
  });

  final IconData icon;
  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 22.w, color: AppColors.primary),
            SizedBox(height: 8.h),
            Text(label, style: AppTextStyles.caption),
            SizedBox(height: 4.h),
            Text(
              amount,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 2.h),
            Text(
              "0%",
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRecord});

  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 8.h),
        Container(
          width: 150.w,
          height: 150.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.06),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Icon(Icons.two_wheeler_rounded,
              size: 64.w, color: AppColors.primary),
        ),
        SizedBox(height: 20.h),
        Text(AppStrings.noDataTitle.tr, style: AppTextStyles.title),
        SizedBox(height: 6.h),
        Text(
          AppStrings.noDataSubtitle.tr,
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 20.h),
        PrimaryButton(label: AppStrings.recordNow.tr, onPressed: onRecord),
      ],
    );
  }
}
