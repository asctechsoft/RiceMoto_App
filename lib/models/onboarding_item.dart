/// Data for a single onboarding page.
class OnboardingItem {
  const OnboardingItem({
    required this.image,
    required this.titleKey,
    required this.descKey,
  });

  final String image;
  final String titleKey;
  final String descKey;
}
