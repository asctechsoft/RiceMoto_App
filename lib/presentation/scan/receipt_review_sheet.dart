import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/models/fuel_receipt_data.dart";
import "package:ricemoto/presentation/widgets/primary_button.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

/// Editable review of the details extracted from a scanned receipt.
class ReceiptReviewSheet extends StatefulWidget {
  const ReceiptReviewSheet({
    required this.data,
    required this.onSave,
    required this.onRescan,
    super.key,
  });

  final FuelReceiptData data;
  final ValueChanged<FuelReceiptData> onSave;
  final VoidCallback onRescan;

  @override
  State<ReceiptReviewSheet> createState() => _ReceiptReviewSheetState();
}

class _ReceiptReviewSheetState extends State<ReceiptReviewSheet> {
  late final TextEditingController _station;
  late final TextEditingController _fuelType;
  late final TextEditingController _liters;
  late final TextEditingController _unitPrice;
  late final TextEditingController _total;

  @override
  void initState() {
    super.initState();
    _station = TextEditingController(text: widget.data.stationName);
    _fuelType = TextEditingController(text: widget.data.fuelType);
    _liters = TextEditingController(text: widget.data.liters);
    _unitPrice = TextEditingController(text: widget.data.unitPrice);
    _total = TextEditingController(text: widget.data.totalAmount);
  }

  @override
  void dispose() {
    _station.dispose();
    _fuelType.dispose();
    _liters.dispose();
    _unitPrice.dispose();
    _total.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(
      FuelReceiptData(
        stationName: _station.text,
        fuelType: _fuelType.text,
        liters: _liters.text,
        unitPrice: _unitPrice.text,
        totalAmount: _total.text,
        dateLabel: widget.data.dateLabel,
        timeLabel: widget.data.timeLabel,
        imagePath: widget.data.imagePath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.9.sh),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              _AiBadge(),
              SizedBox(height: 14.h),
              Text(
                AppStrings.reviewTitle.tr,
                style: AppTextStyles.heading.copyWith(fontSize: 22.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                AppStrings.reviewSubtitle.tr,
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 18.h),
              _Field(
                icon: Icons.local_gas_station_rounded,
                label: AppStrings.fieldStationName.tr,
                controller: _station,
              ),
              _Field(
                icon: Icons.water_drop_rounded,
                label: AppStrings.fieldFuelType.tr,
                controller: _fuelType,
              ),
              _Field(
                icon: Icons.local_drink_rounded,
                label: AppStrings.fieldLiters.tr,
                controller: _liters,
              ),
              _Field(
                icon: Icons.sell_rounded,
                label: AppStrings.fieldUnitPrice.tr,
                controller: _unitPrice,
              ),
              _Field(
                icon: Icons.payments_rounded,
                label: AppStrings.fieldTotalAmount.tr,
                controller: _total,
              ),
              SizedBox(height: 8.h),
              Row(
                children: <Widget>[
                  Icon(Icons.check_circle_rounded,
                      size: 16.w, color: AppColors.success),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      AppStrings.scannedAt.trParams(<String, String>{
                        "date": widget.data.dateLabel,
                        "time": widget.data.timeLabel,
                      }),
                      style: AppTextStyles.caption,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onRescan,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.refresh_rounded,
                            size: 16.w, color: AppColors.primary),
                        SizedBox(width: 4.w),
                        Text(
                          AppStrings.rescan.tr,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              PrimaryButton(label: AppStrings.save.tr, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.auto_awesome_rounded, size: 15.w, color: AppColors.primary),
          SizedBox(width: 6.w),
          Text(
            AppStrings.aiScanResult.tr,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatefulWidget {
  const _Field({
    required this.icon,
    required this.label,
    required this.controller,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  final FocusNode _node = FocusNode();

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(widget.icon, size: 20.w, color: AppColors.primary),
          ),
          SizedBox(width: 12.w),
          Text(widget.label, style: AppTextStyles.caption),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _node,
              textAlign: TextAlign.right,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => _node.requestFocus(),
            child: Icon(Icons.edit_outlined,
                size: 16.w, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
