import 'package:flutter/material.dart';

class PlaylistInfo {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final int trackCount;
  final String totalDuration;
  final String creator;

  const PlaylistInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.trackCount,
    required this.totalDuration,
    required this.creator,
  });
}

class PlaylistTrackItem {
  final String title;
  final String artist;
  final String duration;
  final String model;
  final bool isPlaying;

  const PlaylistTrackItem({
    required this.title,
    required this.artist,
    required this.duration,
    required this.model,
    this.isPlaying = false,
  });
}

class PlaylistDetailData {
  static const Map<String, List<PlaylistTrackItem>> playlistTracks = {
    'default': _defaultTracks,
  };

  static const _defaultTracks = [
    PlaylistTrackItem(
      title: 'Golden Horizon',
      artist: 'Lux AI',
      duration: '3:42',
      model: 'Sun-Vibe',
      isPlaying: true,
    ),
    PlaylistTrackItem(
      title: 'Midnight Jazz',
      artist: 'Neural Flow',
      duration: '4:15',
      model: 'Smooth-Flow',
    ),
    PlaylistTrackItem(
      title: 'Amber Rain',
      artist: 'Liquid Engine',
      duration: '5:20',
      model: 'Liquid-Soul',
    ),
    PlaylistTrackItem(
      title: 'Copper Dreams',
      artist: 'Beat Machine',
      duration: '3:58',
      model: 'Neural-Beat',
    ),
    PlaylistTrackItem(
      title: 'Velvet Storm',
      artist: 'Luna Beats',
      duration: '4:30',
      model: 'Ambient-Wave',
    ),
    PlaylistTrackItem(
      title: 'Neon Dusk',
      artist: 'Synthwave Kai',
      duration: '3:12',
      model: 'Copper-Beat',
    ),
    PlaylistTrackItem(
      title: 'Solar Chill',
      artist: 'Zen AI',
      duration: '6:05',
      model: 'Silk-Strings',
    ),
    PlaylistTrackItem(
      title: 'Astral Drift',
      artist: 'Cosmic Sound',
      duration: '4:48',
      model: 'Neural-Jazz',
    ),
  ];
}
