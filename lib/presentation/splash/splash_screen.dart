import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:ricemoto/configs/app_config.dart";
import "package:ricemoto/controller/splash_controller.dart";
import "package:ricemoto/values/app_colors.dart";

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/logo/logo.png",
              width: 120.w,
              height: 120.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20.h),
            Text(
              AppConfig.appName,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: 26.w,
              height: 26.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2.6,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
