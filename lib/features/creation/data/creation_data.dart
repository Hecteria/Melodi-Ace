class CreationData {
  // ── Simple tab ────────────────────────────────────────────────
  static const List<String> genres = [
    'Jazz', 'Lo-fi', 'Cinematic', 'Electronic', 'Soul', 'Ambient',
  ];
  static const List<String> moods = [
    'Energetic', 'Melancholic', 'Uplifting', 'Dark',
  ];
  static const int maxDescriptionLength = 500;

  // ── Advanced options — Duration (seconds) ─────────────────────
  static const int defaultDurationSeconds = 240;
  static const int minDurationSeconds = 10;
  static const int maxDurationSeconds = 240;
  static const int durationStep = 10;

  // ── Advanced options — Tempo (BPM) ────────────────────────────
  static const int defaultTempoBpm = 92;
  static const int minTempoBpm = 30;
  static const int maxTempoBpm = 200;

  // ── Advanced options — Time Signature ─────────────────────────
  // Cycles through [2, 3, 4, 6]; default index 2 → value 4
  static const List<int> timeSignatureValues = [2, 3, 4, 6];
  static const int defaultTimeSignatureIndex = 2;

  // ── Advanced options — Musical Key ───────────────────────────
  // 12 major + 12 minor keys in chromatic order; default → A minor (index 21)
  static const List<String> musicalKeys = [
    'C major', 'C# major', 'D major', 'D# major', 'E major', 'F major',
    'F# major', 'G major', 'G# major', 'A major', 'A# major', 'B major',
    'C minor', 'C# minor', 'D minor', 'D# minor', 'E minor', 'F minor',
    'F# minor', 'G minor', 'G# minor', 'A minor', 'A# minor', 'B minor',
  ];
  static const int defaultKeyIndex = 21; // A minor

  // ── Advanced options — Thinking slider ───────────────────────
  // 0.0 = Creative, 1.0 = Robust
  static const double defaultThinkingValue = 0.4;
}
