import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../player/presentation/now_playing_screen.dart';
import '../controllers/library_controller.dart';
import '../data/library_data.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _controller = LibraryController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => Column(
            children: [
              const SizedBox(height: 16),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Library',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                    ),
                    Row(
                      children: [
                        _buildIconBtn(Icons.search),
                        const SizedBox(width: 8),
                        _buildIconBtn(Icons.add_circle_outline),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.white54,
                  labelStyle:
                      const TextStyle(fontWeight: FontWeight.w600),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Creations'),
                    Tab(text: 'Saved'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Filter chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: LibraryData.filters.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = LibraryData.filters[index];
                    final selected =
                        _controller.selectedFilter == filter;
                    return GestureDetector(
                      onTap: () =>
                          _controller.selectFilter(filter),
                      child: AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : Colors.white
                                    .withValues(alpha: 0.12),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : Colors.white70,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Track list
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTrackList(),
                    _buildTrackList(), // same for demo
                  ],
                ),
              ),
              // Now Playing mini bar
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NowPlayingScreen(),
                  ),
                ),
                child: Container(
                  margin:
                      const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.chocolate,
                              AppColors.primary
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.music_note,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Golden Horizon',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'Playing Now',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.skip_previous_rounded,
                          color: Colors.white70, size: 24),
                      const SizedBox(width: 12),
                      const Icon(Icons.pause_rounded,
                          color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      const Icon(Icons.skip_next_rounded,
                          color: Colors.white70, size: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBtn(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Icon(icon, color: Colors.white70, size: 20),
    );
  }

  Widget _buildTrackList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: LibraryData.tracks.length,
      itemBuilder: (context, index) {
        final track = LibraryData.tracks[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: track.isPlaying
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: track.isPlaying
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: track.isPlaying
                        ? [AppColors.primary, AppColors.tuscanSun]
                        : [AppColors.chocolate, AppColors.saddleBrown],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  track.isPlaying
                      ? Icons.equalizer_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: track.isPlaying
                                ? AppColors.primary
                                : Colors.white,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.psychology,
                            size: 14, color: AppColors.white54),
                        const SizedBox(width: 4),
                        Text(
                          '${track.model} \u2022 ${track.duration}',
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
              const Icon(Icons.more_vert,
                  color: AppColors.white54, size: 20),
            ],
          ),
        );
      },
    );
  }
}
