import 'package:flutter/material.dart';
import '../../../core/locale/locale_scope.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/player_controller.dart';
import '../data/player_data.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final _controller = PlayerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final track = PlayerData.currentTrack;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.2,
            colors: [
              Color(0xFFf48c25),
              Color(0xFF4a341e),
              Color(0xFF120d08),
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
          ),
          child: SafeArea(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => Column(
                children: [
                  const SizedBox(height: 8),
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.white, size: 28),
                        ),
                        Column(
                          children: [
                            Text(
                              context.l10n.nowPlaying,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.white54),
                            ),
                            Text(
                              track.collection,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const Icon(Icons.more_horiz,
                            color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Album art
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF3D1F05),
                          Color(0xFFF48C25),
                          Color(0xFFE5C185),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.15),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          const Icon(Icons.music_note_rounded,
                              size: 80, color: Colors.white24),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Song info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${track.artist} \u2022 ${track.genre}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.white54),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _controller.toggleFavorite,
                          child: Icon(
                            _controller.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _controller.isFavorite
                                ? AppColors.primary
                                : Colors.white70,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor:
                                Colors.white.withValues(alpha: 0.15),
                            thumbColor: AppColors.primary,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                            overlayShape:
                                const RoundSliderOverlayShape(
                                    overlayRadius: 14),
                            trackHeight: 3,
                          ),
                          child: Slider(
                            value: _controller.progress,
                            onChanged: _controller.seekTo,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _controller.currentTimeLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.white54),
                              ),
                              Text(
                                _controller.totalTimeLabel,
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
                  ),
                  const SizedBox(height: 16),
                  // Controls
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: _controller.toggleShuffle,
                          child: Icon(
                            Icons.shuffle,
                            color: _controller.isShuffle
                                ? AppColors.primary
                                : Colors.white70,
                            size: 24,
                          ),
                        ),
                        const Icon(Icons.skip_previous_rounded,
                            color: Colors.white, size: 36),
                        // Play/Pause
                        GestureDetector(
                          onTap: _controller.togglePlay,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              _controller.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        const Icon(Icons.skip_next_rounded,
                            color: Colors.white, size: 36),
                        GestureDetector(
                          onTap: _controller.toggleRepeat,
                          child: Icon(
                            Icons.repeat,
                            color: _controller.isRepeat
                                ? AppColors.primary
                                : Colors.white70,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Bottom row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.devices,
                                color: AppColors.white54, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Studio 1',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.white54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.share,
                                color: AppColors.white54, size: 20),
                            const SizedBox(width: 20),
                            const Icon(Icons.playlist_play,
                                color: AppColors.white54, size: 24),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
