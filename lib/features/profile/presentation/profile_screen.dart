import 'package:flutter/material.dart';
import '../../../core/locale/locale_controller.dart';
import '../../../core/locale/locale_scope.dart';
import '../../../core/services/auth_scope.dart';
import '../../../core/theme/app_theme.dart';
import '../../upgrade/presentation/upgrade_screen.dart';
import '../data/profile_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final userModel = auth.userModel;
    final deviceModel = auth.deviceModel;
    final l = context.l10n;

    final displayName = userModel?.displayName.isNotEmpty == true
        ? userModel!.displayName
        : l.guestName;
    final subtitle = userModel?.isAnonymous == false && userModel?.email.isNotEmpty == true
        ? userModel!.email
        : l.guestAccount;
    final planName = _formatPlan(userModel?.plan ?? 'starter');
    final isPro = (userModel?.plan ?? 'starter') != 'starter';
    final credits = deviceModel?.generationCredits ?? 0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l.profile,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                    ),
                    _IconBtn(
                      icon: Icons.edit_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Avatar + Info
              _buildAvatarSection(context, displayName, subtitle),
              const SizedBox(height: 28),

              // Stats row
              _buildStatsRow(context, credits),
              const SizedBox(height: 28),

              // Connect account (only for guest users)
              if (userModel?.isAnonymous != false) ...[
                _buildConnectAccountCard(context, auth.busy, auth.error),
                const SizedBox(height: 28),
              ],

              // Subscription card
              _buildSubscriptionCard(context, planName, isPro),
              const SizedBox(height: 28),

              // Account section
              _buildSectionTitle(context, l.accountSection),
              const SizedBox(height: 12),
              _buildMenuGroup(context, ProfileData.accountMenu),
              const SizedBox(height: 24),

              // Preferences section
              _buildSectionTitle(context, l.preferencesSection),
              const SizedBox(height: 12),
              _buildMenuGroup(context, ProfileData.preferencesMenu),
              const SizedBox(height: 24),

              // Support section
              _buildSectionTitle(context, l.supportSection),
              const SizedBox(height: 12),
              _buildMenuGroup(context, ProfileData.supportMenu),
              const SizedBox(height: 28),

              // Sign out (only for authenticated, non-anonymous users)
              if (userModel?.isAnonymous == false) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: auth.busy
                          ? null
                          : () => AuthScope.of(context).signOut(),
                      icon: const Icon(Icons.logout_rounded, size: 20),
                      label: Text(l.signOut),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent.shade100,
                        side: BorderSide(
                          color: Colors.redAccent.shade100
                              .withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Version
              Text(
                l.appVersion,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.white30,
                    ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(
      BuildContext context, String displayName, String subtitle) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.chocolate,
                  AppColors.primary,
                  AppColors.tuscanSun
                ],
              ),
            ),
            child: const Icon(Icons.person_rounded,
                color: Colors.white, size: 48),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          displayName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white54,
              ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, int credits) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            _buildStat(context, '0', l.tracksCreated),
            _buildDivider(),
            _buildStat(context, '0h', l.hoursListened),
            _buildDivider(),
            _buildStat(context, '$credits', l.aiCredits),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.white54,
                  height: 1.3,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }

  Widget _buildSubscriptionCard(
      BuildContext context, String planName, bool isPro) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: isPro
            ? null
            : () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UpgradeScreen()),
                ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.chocolate, Color(0xFF2A1508)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.12),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          l.planLabel(planName),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                        ),
                        if (!isPro) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              l.freeBadge,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.white70,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPro ? l.unlimitedActiveDesc : l.upgradeForUnlimited,
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.white54,
                              ),
                    ),
                  ],
                ),
              ),
              if (!isPro)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectAccountCard(
      BuildContext context, bool busy, String? error) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_circle_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.browsingAsGuest,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.signInToSave,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.white54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  error,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.redAccent.shade100,
                      ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: busy ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: busy ? 0.1 : 0.0),
                  ),
                ),
                child: ElevatedButton(
                  onPressed:
                      busy ? null : () => AuthScope.of(context).linkWithGoogle(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4285F4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              l.continueWithGoogle,
                              style: const TextStyle(
                                color: Color(0xFF1F1F1F),
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPlan(String plan) {
    if (plan.isEmpty) return 'Starter';
    return plan[0].toUpperCase() + plan.substring(1);
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
        ),
      ),
    );
  }

  Widget _buildMenuGroup(BuildContext context, List<MenuItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              _buildMenuItem(context, items[i]),
              if (i < items.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  void _onMenuItemTap(BuildContext context, MenuItemKey key) {
    if (key == MenuItemKey.language) {
      _showLanguagePicker(context);
    }
  }

  void _showLanguagePicker(BuildContext context) {
    final localeCtrl = LocaleScope.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ListenableBuilder(
        listenable: localeCtrl,
        builder: (ctx, _) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.menuLanguage,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 16),
              _buildLanguageOption(
                ctx,
                localeCtrl,
                code: 'en',
                label: 'English',
                flag: '🇺🇸',
              ),
              const SizedBox(height: 8),
              _buildLanguageOption(
                ctx,
                localeCtrl,
                code: 'tr',
                label: 'Türkçe',
                flag: '🇹🇷',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LocaleController ctrl, {
    required String code,
    required String label,
    required String flag,
  }) {
    final isSelected = ctrl.locale.languageCode == code;
    return GestureDetector(
      onTap: () {
        ctrl.setLocale(Locale(code));
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onMenuItemTap(context, item.key),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Icon(item.icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  _menuLabel(context, item.key),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              if (_menuTrailing(context, item) != null) ...[
                Text(
                  _menuTrailing(context, item)!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white54,
                      ),
                ),
                const SizedBox(width: 4),
              ],
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.2),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _menuLabel(BuildContext context, MenuItemKey key) {
    final l = context.l10n;
    switch (key) {
      case MenuItemKey.editProfile:
        return l.menuEditProfile;
      case MenuItemKey.subscription:
        return l.menuSubscription;
      case MenuItemKey.notifications:
        return l.menuNotifications;
      case MenuItemKey.privacyAndSecurity:
        return l.menuPrivacyAndSecurity;
      case MenuItemKey.audioQuality:
        return l.menuAudioQuality;
      case MenuItemKey.aiModel:
        return l.menuAiModel;
      case MenuItemKey.storageDownloads:
        return l.menuStorageDownloads;
      case MenuItemKey.language:
        return l.menuLanguage;
      case MenuItemKey.helpCenter:
        return l.menuHelpCenter;
      case MenuItemKey.aboutMelodi:
        return l.menuAboutMelodi;
      case MenuItemKey.rateUs:
        return l.menuRateUs;
      case MenuItemKey.shareWithFriends:
        return l.menuShareWithFriends;
    }
  }

  String? _menuTrailing(BuildContext context, MenuItem item) {
    if (item.key == MenuItemKey.language) {
      final code = LocaleScope.of(context).locale.languageCode;
      return code == 'tr' ? 'Türkçe' : 'English';
    }
    return item.trailing;
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Icon(icon, color: Colors.white70, size: 22),
      ),
    );
  }
}
