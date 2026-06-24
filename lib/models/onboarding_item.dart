import "package:flutter/material.dart";

/// Data for a single onboarding page.
class OnboardingItem {
  const OnboardingItem({
    required this.image,
    required this.titleKey,
    required this.descKey,
    required this.icon,
  });

  final String image;
  final String titleKey;
  final String descKey;
  final IconData icon;
}
