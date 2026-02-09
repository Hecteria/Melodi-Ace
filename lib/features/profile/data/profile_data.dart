import 'package:flutter/material.dart';

class UserProfile {
  final String displayName;
  final String username;
  final int tracksCreated;
  final String hoursListened;
  final String followers;
  final String planName;

  const UserProfile({
    required this.displayName,
    required this.username,
    required this.tracksCreated,
    required this.hoursListened,
    required this.followers,
    required this.planName,
  });
}

class MenuItem {
  final IconData icon;
  final String label;
  final String? trailing;

  const MenuItem({required this.icon, required this.label, this.trailing});
}

class ProfileData {
  static const currentUser = UserProfile(
    displayName: 'Alex Morgan',
    username: '@alexmorgan',
    tracksCreated: 24,
    hoursListened: '148h',
    followers: '1.2K',
    planName: 'Starter',
  );

  static const accountMenu = [
    MenuItem(icon: Icons.person_outline, label: 'Edit Profile'),
    MenuItem(icon: Icons.workspace_premium_outlined, label: 'Subscription', trailing: 'Starter'),
    MenuItem(icon: Icons.notifications_none_rounded, label: 'Notifications'),
    MenuItem(icon: Icons.lock_outline, label: 'Privacy & Security'),
  ];

  static const preferencesMenu = [
    MenuItem(icon: Icons.graphic_eq_rounded, label: 'Audio Quality', trailing: 'Standard'),
    MenuItem(icon: Icons.psychology_outlined, label: 'AI Model', trailing: 'Auto'),
    MenuItem(icon: Icons.download_outlined, label: 'Storage & Downloads'),
    MenuItem(icon: Icons.language, label: 'Language', trailing: 'English'),
  ];

  static const supportMenu = [
    MenuItem(icon: Icons.help_outline_rounded, label: 'Help Center'),
    MenuItem(icon: Icons.info_outline_rounded, label: 'About Melodi'),
    MenuItem(icon: Icons.star_outline_rounded, label: 'Rate Us'),
    MenuItem(icon: Icons.share_outlined, label: 'Share with Friends'),
  ];
}
