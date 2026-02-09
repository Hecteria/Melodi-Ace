class CreationData {
  static const genres = ['Jazz', 'Lo-fi', 'Cinematic', 'Electronic', 'Soul', 'Ambient'];
  static const moods = ['Energetic', 'Melancholic', 'Uplifting', 'Dark'];

  static const double defaultDuration = 3.75;
  static const double minDuration = 0.5;
  static const double maxDuration = 10.0;

  static const double defaultBpm = 92;
  static const double minBpm = 40;
  static const double maxBpm = 200;

  static const int maxDescriptionLength = 500;

  static String bpmLabel(double bpm) {
    if (bpm < 70) return 'Slow';
    if (bpm < 110) return 'Slow-Mid';
    if (bpm < 140) return 'Mid';
    if (bpm < 170) return 'Fast';
    return 'Very Fast';
  }

  static String formatDuration(double duration) {
    final mins = duration.toInt();
    final secs = ((duration % 1) * 60).toInt().toString().padLeft(2, '0');
    return '$mins:$secs minutes';
  }
}
