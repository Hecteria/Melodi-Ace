import 'package:flutter/material.dart';

class QuickAccessItem {
  final String id;
  final String title;
  final String subtitle;

  const QuickAccessItem({
    required this.id,
    required this.title,
    required this.subtitle,
  });
}

class ContinueListeningTrack {
  final String title;
  final String model;
  final String duration;
  final double progress;
  final int secondsLeft;

  const ContinueListeningTrack({
    required this.title,
    required this.model,
    required this.duration,
    required this.progress,
    required this.secondsLeft,
  });
}

class MadeForYouPlaylist {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  const MadeForYouPlaylist({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
  });
}

class RecentCreation {
  final String title;
  final String prompt;
  final int daysAgo;
  final IconData icon;

  const RecentCreation({
    required this.title,
    required this.prompt,
    required this.daysAgo,
    required this.icon,
  });
}

class HomeData {
  static const quickAccessItems = [
    QuickAccessItem(id: '1', title: 'Daily Mix 1', subtitle: 'Jazz, Lo-Fi, Chill'),
    QuickAccessItem(id: '2', title: 'Liked Songs', subtitle: '142 tracks'),
    QuickAccessItem(id: '3', title: 'Focus Flow', subtitle: 'Ambient, Focus'),
    QuickAccessItem(id: '4', title: 'Neural Jazz', subtitle: 'AI Playlist'),
    QuickAccessItem(id: '5', title: 'Evening Chill', subtitle: 'Relax, Sleep'),
    QuickAccessItem(id: '6', title: 'Workout Mix', subtitle: 'Energy, Beats'),
  ];

  static const continueListening = [
    ContinueListeningTrack(
      title: 'Golden Horizon',
      model: 'Sun-Vibe Model',
      duration: '3:42',
      progress: 0.65,
      secondsLeft: 78,
    ),
    ContinueListeningTrack(
      title: 'Midnight Jazz',
      model: 'Smooth-Flow',
      duration: '4:15',
      progress: 0.3,
      secondsLeft: 179,
    ),
    ContinueListeningTrack(
      title: 'Amber Rain',
      model: 'Liquid-Soul',
      duration: '5:20',
      progress: 0.82,
      secondsLeft: 58,
    ),
    ContinueListeningTrack(
      title: 'Copper Dreams',
      model: 'Neural-Beat',
      duration: '3:58',
      progress: 0.15,
      secondsLeft: 203,
    ),
  ];

  static const madeForYou = [
    MadeForYouPlaylist(
      title: 'Daily Mix 1',
      description: 'Jazz, Lo-Fi and Chill',
      icon: Icons.shuffle_rounded,
      gradientColors: [Color(0xFF1a0a2e), Color(0xFF4a1942)],
    ),
    MadeForYouPlaylist(
      title: 'Discover Weekly',
      description: 'New picks for you',
      icon: Icons.explore_outlined,
      gradientColors: [Color(0xFF0d1a1a), Color(0xFF1a4a3a)],
    ),
    MadeForYouPlaylist(
      title: 'Your Time Capsule',
      description: 'Throwback favorites',
      icon: Icons.history_rounded,
      gradientColors: [Color(0xFF2d1e12), Color(0xFFf48c25)],
    ),
    MadeForYouPlaylist(
      title: 'AI Mix for You',
      description: 'Based on your taste',
      icon: Icons.auto_awesome_rounded,
      gradientColors: [Color(0xFF1a1a2e), Color(0xFF3a3a6a)],
    ),
  ];

  static const recentCreations = [
    RecentCreation(
      title: 'Sunset Groove',
      prompt: 'Chill lo-fi with warm bass',
      daysAgo: 1,
      icon: Icons.music_note_rounded,
    ),
    RecentCreation(
      title: 'Neon Pulse',
      prompt: 'Energetic synthwave beat',
      daysAgo: 3,
      icon: Icons.electric_bolt_rounded,
    ),
  ];
}
