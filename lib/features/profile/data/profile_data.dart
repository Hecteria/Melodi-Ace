import 'package:flutter/material.dart';

enum MenuItemKey {
  editProfile,
  subscription,
  notifications,
  privacyAndSecurity,
  audioQuality,
  aiModel,
  storageDownloads,
  language,
  helpCenter,
  aboutMelodi,
  rateUs,
  shareWithFriends,
}

class MenuItem {
  final IconData icon;
  final MenuItemKey key;
  final String? trailing;

  const MenuItem({required this.icon, required this.key, this.trailing});
}

class ProfileData {
  static const accountMenu = [
    MenuItem(icon: Icons.person_outline, key: MenuItemKey.editProfile),
    MenuItem(icon: Icons.workspace_premium_outlined, key: MenuItemKey.subscription, trailing: 'Starter'),
    MenuItem(icon: Icons.notifications_none_rounded, key: MenuItemKey.notifications),
    MenuItem(icon: Icons.lock_outline, key: MenuItemKey.privacyAndSecurity),
  ];

  static const preferencesMenu = [
    MenuItem(icon: Icons.graphic_eq_rounded, key: MenuItemKey.audioQuality, trailing: 'Standard'),
    MenuItem(icon: Icons.psychology_outlined, key: MenuItemKey.aiModel, trailing: 'Auto'),
    MenuItem(icon: Icons.download_outlined, key: MenuItemKey.storageDownloads),
    MenuItem(icon: Icons.language, key: MenuItemKey.language),
  ];

  static const supportMenu = [
    MenuItem(icon: Icons.help_outline_rounded, key: MenuItemKey.helpCenter),
    MenuItem(icon: Icons.info_outline_rounded, key: MenuItemKey.aboutMelodi),
    MenuItem(icon: Icons.star_outline_rounded, key: MenuItemKey.rateUs),
    MenuItem(icon: Icons.share_outlined, key: MenuItemKey.shareWithFriends),
  ];
}
