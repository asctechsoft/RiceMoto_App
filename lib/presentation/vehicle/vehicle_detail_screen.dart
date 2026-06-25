import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/models/vehicle_model.dart";
import "package:ricemoto/services/storage_service.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Detail view for the user's vehicle, reached from the Home "My vehicle" card.
///
/// The vehicle is read from [StorageService]; an optional [VehicleModel] can be
/// passed via `Get.arguments` to override it (e.g. for previews).
class VehicleDetailScreen extends StatefulWidget {
  const VehicleDetailScreen({super.key});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  late final VehicleModel _vehicle;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 5, vsync: this);
    final Object? arg = Get.arguments;
    _vehicle = arg is VehicleModel
        ? arg
        : (StorageService.vehicle ?? const VehicleModel(name: "", brand: ""));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _comingSoon() {
    Get.snackbar(
      AppStrings.myVehicle.tr,
      AppStrings.featureComingSoon.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: <Widget>[
          _Header(vehicle: _vehicle, onEdit: _comingSoon),
          _Tabs(controller: _tabs),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: <Widget>[
                _InfoTab(vehicle: _vehicle),
                const _ComingSoonTab(),
                const _ComingSoonTab(),
                const _ComingSoonTab(),
                const _ComingSoonTab(),
              ],
            ),
          ),
          _StatsBar(vehicle: _vehicle),
        ],
      ),
    );
  }
}

/// Green top bar + the white hero card with the vehicle photo and key facts.
class _Header extends StatelessWidget {
  const _Header({required this.vehicle, required this.onEdit});

  final VehicleModel vehicle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final String title = <String>[vehicle.brand, vehicle.name]
        .where((String s) => s.isNotEmpty)
        .join(" ");
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 16.h),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.white),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon:
                        const Icon(Icons.edit_outlined, color: AppColors.white),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              _HeroCard(vehicle: vehicle, onUpdateKm: onEdit),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.vehicle, required this.onUpdateKm});

  final VehicleModel vehicle;
  final VoidCallback onUpdateKm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(
              color: AppColors.shadow, blurRadius: 14, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 104.w,
            height: 92.h,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(Icons.two_wheeler_rounded,
                size: 52.w, color: AppColors.primary),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  vehicle.name.isNotEmpty
                      ? vehicle.name
                      : AppStrings.myVehicle.tr,
                  style: AppTextStyles.heading.copyWith(fontSize: 20.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (vehicle.plate.isNotEmpty) ...<Widget>[
                  SizedBox(height: 8.h),
                  _PlateChip(plate: vehicle.plate),
                ],
                SizedBox(height: 8.h),
                Row(
                  children: <Widget>[
                    Icon(Icons.check_circle_rounded,
                        size: 16.w, color: AppColors.success),
                    SizedBox(width: 4.w),
                    Text(
                      AppStrings.vehicleActive.tr,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: <Widget>[
                    Icon(Icons.speed_rounded,
                        size: 16.w, color: AppColors.textSecondary),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        "${_formatThousands(vehicle.currentKm)} ${AppStrings.kmUnit.tr}",
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _UpdateKmButton(onTap: onUpdateKm),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlateChip extends StatelessWidget {
  const _PlateChip({required this.plate});

  final String plate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.confirmation_number_outlined,
              size: 14.w, color: AppColors.textSecondary),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              plate,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateKmButton extends StatelessWidget {
  const _UpdateKmButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.edit_rounded, size: 13.w, color: AppColors.white),
            SizedBox(width: 5.w),
            Text(
              AppStrings.updateKm.tr,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        labelStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: AppTextStyles.body,
        tabs: <Widget>[
          Tab(text: AppStrings.vehicleTabInfo.tr),
          Tab(text: AppStrings.vehicleTabHistory.tr),
          Tab(text: AppStrings.vehicleTabSupplies.tr),
          Tab(text: AppStrings.vehicleTabReminders.tr),
          Tab(text: AppStrings.vehicleTabMembers.tr),
        ],
      ),
    );
  }
}

class _InfoTab extends StatelessWidget {
  const _InfoTab({required this.vehicle});

  final VehicleModel vehicle;

  @override
  Widget build(BuildContext context) {
    final List<_SpecRow> rows = <_SpecRow>[
      _SpecRow(AppStrings.vehicleFieldBrand.tr, _orDash(vehicle.brand)),
      _SpecRow(AppStrings.vehicleFieldModel.tr, _orDash(vehicle.name)),
      _SpecRow(AppStrings.vehicleFieldYear.tr, _orDash(vehicle.year)),
      _SpecRow(AppStrings.vehicleFieldColor.tr, _orDash(vehicle.color)),
      _SpecRow(
        AppStrings.vehicleFieldCurrentKm.tr,
        _formatThousands(vehicle.currentKm),
      ),
      _SpecRow(
        AppStrings.vehicleFieldPurchaseDate.tr,
        _orDash(vehicle.purchaseDate),
      ),
    ];
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      itemCount: rows.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: AppColors.divider,
      ),
      itemBuilder: (_, int i) => rows[i],
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Text(
              label,
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          SizedBox(width: 12.w),
          Flexible(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComingSoonTab extends StatelessWidget {
  const _ComingSoonTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.hourglass_empty_rounded,
              size: 40.w, color: AppColors.textHint),
          SizedBox(height: 10.h),
          Text(
            AppStrings.featureComingSoon.tr,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Pinned summary row at the bottom: total spending, refuel count, km/L.
class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.vehicle});

  final VehicleModel vehicle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
          child: Row(
            children: <Widget>[
              _Stat(
                icon: Icons.account_balance_wallet_rounded,
                label: AppStrings.vehicleStatTotalSpending.tr,
                value: _dash,
              ),
              _StatDivider(),
              _Stat(
                icon: Icons.local_gas_station_rounded,
                label: AppStrings.vehicleStatFuelCount.tr,
                value: _dash,
              ),
              _StatDivider(),
              _Stat(
                icon: Icons.speed_rounded,
                label: AppStrings.vehicleStatKmPerLiter.tr,
                value: _dash,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 20.w, color: AppColors.primary),
          SizedBox(height: 6.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 44.h, color: AppColors.divider);
  }
}

const String _dash = "—";

String _orDash(String value) => value.trim().isEmpty ? _dash : value;

/// Formats an integer with "." thousand separators (e.g. 12450 -> "12.450").
String _formatThousands(int value) {
  final String digits = value.toString();
  final StringBuffer out = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write(".");
    out.write(digits[i]);
  }
  return out.toString();
}
