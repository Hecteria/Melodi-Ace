class PlayerTrack {
  final String title;
  final String artist;
  final String genre;
  final String collection;
  final double totalSeconds;

  const PlayerTrack({
    required this.title,
    required this.artist,
    required this.genre,
    required this.collection,
    required this.totalSeconds,
  });
}

class PlayerData {
  static const currentTrack = PlayerTrack(
    title: 'Liquid Ambience',
    artist: 'Lux AI',
    genre: 'Neural Jazz',
    collection: 'Chill AI Collection',
    totalSeconds: 238,
  );

  static String formatTime(double seconds) {
    final mins = seconds ~/ 60;
    final secs = (seconds % 60).toInt();
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }
}
