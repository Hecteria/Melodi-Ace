import 'package:flutter/material.dart';

class MoodItem {
  final String label;
  final IconData icon;
  final List<Color> colors;

  const MoodItem({required this.label, required this.icon, required this.colors});
}

class EngineItem {
  final String name;
  final String desc;
  final IconData icon;
  final Color accentColor;

  const EngineItem({
    required this.name,
    required this.desc,
    required this.icon,
    required this.accentColor,
  });
}

class GenreItem {
  final String label;
  final IconData icon;
  final Color color;

  const GenreItem({required this.label, required this.icon, required this.color});
}

class CommunityTrack {
  final String title;
  final String artist;
  final String plays;
  final IconData trendIcon;

  const CommunityTrack({
    required this.title,
    required this.artist,
    required this.plays,
    required this.trendIcon,
  });
}

class CollectionItem {
  final String title;
  final int trackCount;
  final List<Color> gradient;
  final IconData icon;

  const CollectionItem({
    required this.title,
    required this.trackCount,
    required this.gradient,
    required this.icon,
  });
}

class TrendingItem {
  final String title;
  final String artist;
  final String plays;
  final IconData icon;

  const TrendingItem({
    required this.title,
    required this.artist,
    required this.plays,
    required this.icon,
  });
}

class DiscoverData {
  static const moodFilters = ['All', 'Chill', 'Energy', 'Focus', 'Sleep'];

  static const moods = [
    MoodItem(label: 'Relaxed', icon: Icons.spa_outlined, colors: [Color(0xFF1a2a2a), Color(0xFF2d5a4a)]),
    MoodItem(label: 'Energetic', icon: Icons.local_fire_department_outlined, colors: [Color(0xFF2d1e12), Color(0xFFc4652a)]),
    MoodItem(label: 'Melancholic', icon: Icons.water_drop_outlined, colors: [Color(0xFF1a1a2e), Color(0xFF3a3a6a)]),
    MoodItem(label: 'Focused', icon: Icons.center_focus_strong_outlined, colors: [Color(0xFF1e2a1e), Color(0xFF3a5a3a)]),
    MoodItem(label: 'Dreamy', icon: Icons.cloud_outlined, colors: [Color(0xFF2a1a2e), Color(0xFF5a3a6a)]),
    MoodItem(label: 'Euphoric', icon: Icons.auto_awesome_outlined, colors: [Color(0xFF2d2412), Color(0xFFc49a2a)]),
  ];

  static const engines = [
    EngineItem(name: 'Neural Jazz', desc: 'Smooth improvisation with deep harmonic layers', icon: Icons.piano, accentColor: Color(0xFFE5C185)),
    EngineItem(name: 'Ambient Wave', desc: 'Atmospheric textures and evolving soundscapes', icon: Icons.waves_rounded, accentColor: Color(0xFF6AAFCF)),
    EngineItem(name: 'Copper Beat', desc: 'Punchy rhythms and electronic grooves', icon: Icons.graphic_eq_rounded, accentColor: Color(0xFFF48C25)),
    EngineItem(name: 'Silk Strings', desc: 'Orchestral richness and cinematic depth', icon: Icons.music_note_rounded, accentColor: Color(0xFFC47A7A)),
  ];

  static const genres = [
    GenreItem(label: 'Lo-Fi', icon: Icons.headphones_rounded, color: Color(0xFF4a3a5a)),
    GenreItem(label: 'Jazz', icon: Icons.piano, color: Color(0xFF3D1F05)),
    GenreItem(label: 'Electronic', icon: Icons.bolt_rounded, color: Color(0xFF1a3a4a)),
    GenreItem(label: 'Cinematic', icon: Icons.movie_outlined, color: Color(0xFF3a1a1a)),
    GenreItem(label: 'Ambient', icon: Icons.cloud_outlined, color: Color(0xFF1a2a3a)),
    GenreItem(label: 'Soul', icon: Icons.favorite_outline_rounded, color: Color(0xFF2d2a12)),
  ];

  static const communityTracks = [
    CommunityTrack(title: 'Neon Dusk', artist: '@synthwave_kai', plays: '2.4K plays', trendIcon: Icons.trending_up_rounded),
    CommunityTrack(title: 'Velvet Storm', artist: '@luna.beats', plays: '1.8K plays', trendIcon: Icons.whatshot_rounded),
    CommunityTrack(title: 'Astral Drift', artist: '@cosmic_sound', plays: '1.2K plays', trendIcon: Icons.star_outline_rounded),
  ];

  static const trendingNow = [
    TrendingItem(title: 'Astral Drift', artist: '@cosmic_sound', plays: '12.4K', icon: Icons.trending_up_rounded),
    TrendingItem(title: 'Velvet Storm', artist: '@luna.beats', plays: '9.8K', icon: Icons.whatshot_rounded),
    TrendingItem(title: 'Neon Dusk', artist: '@synthwave_kai', plays: '7.2K', icon: Icons.trending_up_rounded),
  ];

  static const collections = [
    CollectionItem(title: 'Late Night\nCoding', trackCount: 32, gradient: [Color(0xFF0d0d1a), Color(0xFF1a0a2e)], icon: Icons.code_rounded),
    CollectionItem(title: 'Morning\nRituals', trackCount: 24, gradient: [Color(0xFF2d1e12), Color(0xFF4a3018)], icon: Icons.wb_twilight_rounded),
    CollectionItem(title: 'Deep\nFocus', trackCount: 48, gradient: [Color(0xFF0d1a1a), Color(0xFF1a3a3a)], icon: Icons.psychology_outlined),
  ];
}
