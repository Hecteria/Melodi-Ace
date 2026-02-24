import 'package:flutter/material.dart';
import '../../../core/locale/locale_scope.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/upgrade_controller.dart';
import '../data/upgrade_data.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  final _controller = UpgradeController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.chocolate, AppColors.backgroundDark],
          ),
        ),
        child: SafeArea(
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 24),
                        ),
                        Text(
                          context.l10n.upgradeToPro,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            context.l10n.restore,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Title
                    Text(
                      context.l10n.chooseSoundExperience,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.unlockPremium,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.white54,
                              ),
                    ),
                    const SizedBox(height: 28),
                    // Toggle
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _buildToggle(context.l10n.monthly, !_controller.isYearly, false),
                          _buildToggle(context.l10n.yearlyWithDiscount, _controller.isYearly, true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Starter Plan
                    _buildPlanCard(
                      context,
                      plan: UpgradeData.starterPlan,
                      price: UpgradeData.starterPlan.monthlyPrice,
                      featureIcon: Icons.check_circle,
                      featureIconColor: AppColors.white54,
                      isHighlighted: false,
                    ),
                    const SizedBox(height: 16),
                    // Pro Plan
                    _buildPlanCard(
                      context,
                      plan: UpgradeData.proPlan,
                      price: _controller.proPrice,
                      featureIcon: Icons.verified,
                      featureIconColor: AppColors.primary,
                      isHighlighted: true,
                    ),
                    const SizedBox(height: 20),
                    // Terms
                    Text(
                      context.l10n.subscriptionRenewsNote,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.white30,
                                height: 1.5,
                              ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.terms,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppColors.white54,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          context.l10n.privacyPolicy,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppColors.white54,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.chocolate,
                              AppColors.primary
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary
                                  .withValues(alpha: 0.25),
                              blurRadius: 25,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.l10n.startFreeTrial,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.thenCancelAnytime(_controller.proPrice),
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.white54,
                              ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggle(String label, bool active, bool isYearly) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _controller.toggleBillingPeriod(isYearly),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : AppColors.white54,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required SubscriptionPlan plan,
    required String price,
    required IconData featureIcon,
    required Color featureIconColor,
    required bool isHighlighted,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.surfaceDark
            : AppColors.surfaceDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: isHighlighted
            ? Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
                width: 1.5)
            : Border.all(
                color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 25,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? AppColors.primary
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  plan.badge,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style:
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  context.l10n.perMonth,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white54,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...plan.features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(featureIcon,
                        color: featureIconColor, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      f.text,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
