import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:ricemoto/values/app_colors.dart";

/// Rounded, lightly-bordered container that groups the auth options
/// (phone field, divider, Google button) on the login / register screens.
class AuthCard extends StatelessWidget {
  const AuthCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(children: children),
    );
  }
}
