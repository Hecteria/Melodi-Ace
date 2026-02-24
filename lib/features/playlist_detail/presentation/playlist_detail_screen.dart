import 'package:flutter/material.dart';
import '../../../core/locale/locale_scope.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/playlist_detail_controller.dart';
import '../data/playlist_detail_data.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final PlaylistInfo playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final _controller = PlaylistDetailController();
  late final List<PlaylistTrackItem> _tracks;

  @override
  void initState() {
    super.initState();
    _tracks = PlaylistDetailData.playlistTracks[widget.playlist.id] ??
        PlaylistDetailData.playlistTracks['default']!;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playlist = widget.playlist;

    return Scaffold(
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => CustomScrollView(
          slivers: [
            // Collapsing header
            SliverAppBar(
              expandedHeight: 340,
              pinned: true,
              backgroundColor: AppColors.backgroundDark,
              leading: GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 38,
                    height: 38,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.more_vert,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeader(context, playlist),
              ),
            ),

            // Action bar
            SliverToBoxAdapter(
              child: _buildActionBar(context, playlist),
            ),

            // Track list
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList.builder(
                itemCount: _tracks.length,
                itemBuilder: (context, index) {
                  final track = _tracks[index];
                  final isPlaying = _controller.playingIndex == index;
                  return _buildTrackRow(context, index, track, isPlaying);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Header ----
  Widget _buildHeader(BuildContext context, PlaylistInfo playlist) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            playlist.gradientColors.first,
            playlist.gradientColors.last,
            AppColors.backgroundDark,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Playlist artwork
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: playlist.gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: playlist.gradientColors.last
                          .withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Icon(playlist.icon, size: 56, color: Colors.white70),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text(
                playlist.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 6),
              // Description
              Text(
                playlist.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white54,
                    ),
              ),
              const SizedBox(height: 10),
              // Meta info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    playlist.creator,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '\u2022',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.white30),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    context.l10n.tracksCount(playlist.trackCount),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.white54),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '\u2022',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.white30),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    playlist.totalDuration,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.white54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Action Bar ----
  Widget _buildActionBar(BuildContext context, PlaylistInfo playlist) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          // Shuffle
          GestureDetector(
            onTap: _controller.toggleShuffle,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _controller.isShuffled
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _controller.isShuffled
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Icon(
                Icons.shuffle_rounded,
                color: _controller.isShuffled
                    ? AppColors.primary
                    : Colors.white70,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Save / Heart
          GestureDetector(
            onTap: _controller.toggleSaved,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _controller.isSaved
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Icon(
                _controller.isSaved
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: _controller.isSaved
                    ? AppColors.primary
                    : Colors.white70,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Download
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: const Icon(Icons.download_rounded,
                color: Colors.white70, size: 20),
          ),
          const Spacer(),
          // Play button
          GestureDetector(
            onTap: () => _controller.playTrack(0),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Track Row ----
  Widget _buildTrackRow(
    BuildContext context,
    int index,
    PlaylistTrackItem track,
    bool isPlaying,
  ) {
    return GestureDetector(
      onTap: () => _controller.playTrack(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isPlaying
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isPlaying
              ? Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2))
              : null,
        ),
        child: Row(
          children: [
            // Track number / playing indicator
            SizedBox(
              width: 28,
              child: isPlaying
                  ? const Icon(Icons.equalizer_rounded,
                      color: AppColors.primary, size: 18)
                  : Text(
                      '${index + 1}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.white54),
                    ),
            ),
            const SizedBox(width: 12),
            // Artwork thumbnail
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isPlaying
                      ? [AppColors.primary, AppColors.tuscanSun]
                      : [AppColors.chocolate, AppColors.saddleBrown],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isPlaying
                    ? Icons.music_note_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            // Track info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              isPlaying ? AppColors.primary : Colors.white,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${track.artist} \u2022 ${track.model}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.white54,
                        ),
                  ),
                ],
              ),
            ),
            // Duration
            Text(
              track.duration,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.white54,
                  ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.more_vert, color: AppColors.white54, size: 18),
          ],
        ),
      ),
    );
  }
}
