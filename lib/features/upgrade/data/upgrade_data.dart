class PlanFeature {
  final String text;
  const PlanFeature(this.text);
}

class SubscriptionPlan {
  final String title;
  final String monthlyPrice;
  final String yearlyPrice;
  final String badge;
  final List<PlanFeature> features;
  final bool isHighlighted;

  const SubscriptionPlan({
    required this.title,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.badge,
    required this.features,
    this.isHighlighted = false,
  });
}

class UpgradeData {
  static const starterPlan = SubscriptionPlan(
    title: 'Starter',
    monthlyPrice: '\$0',
    yearlyPrice: '\$0',
    badge: 'Current',
    features: [
      PlanFeature('Basic AI generation'),
      PlanFeature('Ad-supported streaming'),
      PlanFeature('Standard audio quality'),
    ],
  );

  static const proPlan = SubscriptionPlan(
    title: 'Pro Experience',
    monthlyPrice: '\$12.99',
    yearlyPrice: '\$9.99',
    badge: 'Best Value',
    isHighlighted: true,
    features: [
      PlanFeature('Unlimited AI generation'),
      PlanFeature('Lossless Spatial Audio'),
      PlanFeature('Offline Mode & Downloads'),
      PlanFeature('No Ads & Interruptions'),
      PlanFeature('Early access to new models'),
    ],
  );
}
