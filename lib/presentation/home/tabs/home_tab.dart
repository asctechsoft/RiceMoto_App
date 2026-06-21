import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/values/app_colors.dart";
import "package:ricemoto/values/app_strings.dart";
import "package:ricemoto/values/app_text_styles.dart";

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = <_Tx>[
      const _Tx("Parking", "Jun 3, 2026 • 12:10", "30.000đ", Icons.local_parking),
      const _Tx("Coffee House", "Jun 3, 2026 • 09:24", "55.000đ", Icons.local_cafe),
      const _Tx("Grocery Mart", "Jun 2, 2026 • 18:40", "320.000đ", Icons.shopping_bag),
      const _Tx("Fuel Station", "Jun 2, 2026 • 08:05", "120.000đ", Icons.local_gas_station),
    ];

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
        children: <Widget>[
          Text(
            AppStrings.greeting.trArgs(<String>["Duc"]),
            style: AppTextStyles.title,
          ),
          SizedBox(height: 16.h),
          _BalanceCard(),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(AppStrings.recentTransactions.tr, style: AppTextStyles.title),
              Text(
                AppStrings.seeAll.tr,
                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ...transactions.map((tx) => _TxTile(tx: tx)),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.totalSpending.tr,
            style: AppTextStyles.body.copyWith(color: AppColors.white70),
          ),
          SizedBox(height: 8.h),
          Text(
            "1.250.000đ",
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "June 2026",
            style: AppTextStyles.caption.copyWith(color: AppColors.white70),
          ),
        ],
      ),
    );
  }
}

class _Tx {
  const _Tx(this.title, this.subtitle, this.amount, this.icon);
  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
}

class _TxTile extends StatelessWidget {
  const _TxTile({required this.tx});
  final _Tx tx;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(tx.icon, color: AppColors.primary, size: 22.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(tx.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: 2.h),
                Text(tx.subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(
            tx.amount,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
