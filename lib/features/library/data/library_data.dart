class TrackItem {
  final String title;
  final String model;
  final String duration;
  final bool isPlaying;

  const TrackItem({
    required this.title,
    required this.model,
    required this.duration,
    this.isPlaying = false,
  });
}

class LibraryData {
  static const filters = ['All Tracks', 'Lo-Fi', 'Cinematic', 'Jazz Fusion'];

  static const tracks = [
    TrackItem(title: 'Golden Horizon', model: 'Sun-Vibe Model', duration: '3:42', isPlaying: true),
    TrackItem(title: 'Midnight Jazz', model: 'Smooth-Flow', duration: '4:15'),
    TrackItem(title: 'Luxurious Echoes', model: 'Premium-Strings', duration: '2:58'),
    TrackItem(title: 'Amber Rain', model: 'Liquid-Soul', duration: '5:20'),
    TrackItem(title: 'Obsidian Pulse', model: 'Deep-Core', duration: '3:12'),
  ];
}
