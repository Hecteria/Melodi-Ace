import 'package:flutter/material.dart';
import '../../../core/locale/locale_scope.dart';
import '../../../core/theme/app_theme.dart';
import '../../playlist_detail/data/playlist_detail_data.dart';
import '../../playlist_detail/presentation/playlist_detail_screen.dart';
import '../controllers/discover_controller.dart';
import '../data/discover_data.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _controller = DiscoverController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.explore,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                      ),
                      _buildIconButton(Icons.tune_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded,
                            color: Colors.white.withValues(alpha: 0.4),
                            size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            context.l10n.searchPlaceholder,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.mic_none_rounded,
                                  color: AppColors.primary, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                context.l10n.voice,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Trending Now
                _sectionTitle(context, context.l10n.trendingNow),
                const SizedBox(height: 14),
                SizedBox(
                  height: 72,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: DiscoverData.trendingNow.length,
                    itemBuilder: (context, index) {
                      final item = DiscoverData.trendingNow[index];
                      return _buildTrendingCard(context, index, item);
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Browse by Mood
                _sectionTitle(context, context.l10n.browseByMood),
                const SizedBox(height: 14),
                // Mood filter chips
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: DiscoverData.moodFilters.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = DiscoverData.moodFilters[index];
                      final selected =
                          _controller.selectedMoodFilter == filter;
                      return GestureDetector(
                        onTap: () => _controller.selectMoodFilter(filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            filter,
                            style: TextStyle(
                              color:
                                  selected ? Colors.white : Colors.white70,
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
                // Mood grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.65,
                    ),
                    itemCount: DiscoverData.moods.length,
                    itemBuilder: (context, index) {
                      final mood = DiscoverData.moods[index];
                      return _MoodCard(
                        label: mood.label,
                        icon: mood.icon,
                        colors: mood.colors,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // AI Sound Engines
                _sectionTitle(context, context.l10n.aiSoundEngines),
                const SizedBox(height: 14),
                SizedBox(
                  height: 155,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: DiscoverData.engines.length,
                    itemBuilder: (context, index) {
                      final engine = DiscoverData.engines[index];
                      return _EngineCard(
                        name: engine.name,
                        desc: engine.desc,
                        icon: engine.icon,
                        accentColor: engine.accentColor,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Genre Worlds
                _sectionTitle(context, context.l10n.genreWorlds),
                const SizedBox(height: 14),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: DiscoverData.genres.length,
                    itemBuilder: (context, index) {
                      final genre = DiscoverData.genres[index];
                      return _GenreChip(
                        label: genre.label,
                        icon: genre.icon,
                        color: genre.color,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Top Community Creations
                _sectionTitle(context, context.l10n.topCommunityCreations),
                const SizedBox(height: 14),
                _buildCommunityList(context),
                const SizedBox(height: 32),

                // Curated Collections
                _sectionTitle(context, context.l10n.curatedCollections),
                const SizedBox(height: 14),
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: DiscoverData.collections.length,
                    itemBuilder: (context, index) {
                      final col = DiscoverData.collections[index];
                      return _buildCollectionCard(
                        context,
                        title: col.title,
                        trackCount: col.trackCount,
                        gradient: col.gradient,
                        icon: col.icon,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPlaylist(PlaylistInfo info) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlaylistDetailScreen(playlist: info),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Icon(icon, color: Colors.white70, size: 22),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
          ),
          Text(
            context.l10n.seeAll,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCard(
      BuildContext context, int index, TrendingItem item) {
    return GestureDetector(
      onTap: () => _openPlaylist(PlaylistInfo(
        id: 'trending_${item.title}',
        title: item.title,
        description: '${item.artist} \u2022 ${item.plays} plays',
        icon: Icons.trending_up_rounded,
        gradientColors: const [AppColors.chocolate, AppColors.primary],
        trackCount: 8,
        totalDuration: '28 min',
        creator: item.artist,
      )),
      child: Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${index + 1}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: index == 0 ? AppColors.primary : AppColors.white54,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.chocolate, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.artist} \u2022 ${item.plays} plays',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white54,
                      ),
                ),
              ],
            ),
          ),
          Icon(item.icon, color: AppColors.primary, size: 18),
        ],
      ),
      ),
    );
  }

  Widget _buildCommunityList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: DiscoverData.communityTracks.asMap().entries.map((entry) {
          final i = entry.key;
          final track = entry.value;
          return GestureDetector(
            onTap: () => _openPlaylist(PlaylistInfo(
              id: 'community_${track.title}',
              title: track.title,
              description: '${track.artist} \u2022 ${track.plays}',
              icon: track.trendIcon,
              gradientColors: const [Color(0xFF2d1e12), AppColors.primary],
              trackCount: 8,
              totalDuration: '32 min',
              creator: track.artist,
            )),
            child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '#${i + 1}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color:
                              i == 0 ? AppColors.primary : AppColors.white54,
                        ),
                  ),
                ),
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.chocolate,
                        AppColors.primary.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${track.artist} \u2022 ${track.plays}',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.white54,
                                ),
                      ),
                    ],
                  ),
                ),
                Icon(track.trendIcon, color: AppColors.primary, size: 18),
              ],
            ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCollectionCard(
    BuildContext context, {
    required String title,
    required int trackCount,
    required List<Color> gradient,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => _openPlaylist(PlaylistInfo(
        id: 'collection_$title',
        title: title.replaceAll('\n', ' '),
        description: '$trackCount curated tracks',
        icon: icon,
        gradientColors: gradient,
        trackCount: trackCount,
        totalDuration: '${trackCount * 3} min',
        creator: 'Melodi Curators',
      )),
      child: Container(
      width: 155,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white70, size: 22),
            ),
            const Spacer(),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.25,
                  ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.queue_music_rounded,
                    size: 14, color: AppColors.white54),
                const SizedBox(width: 4),
                Text(
                  context.l10n.tracksCount(trackCount),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white54,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}

// ---------- Sub-widgets ----------

class _MoodCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> colors;

  const _MoodCard({
    required this.label,
    required this.icon,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PlaylistDetailScreen(
                  playlist: PlaylistInfo(
                    id: 'mood_$label',
                    title: '$label Vibes',
                    description: 'AI-curated $label music',
                    icon: icon,
                    gradientColors: colors,
                    trackCount: 16,
                    totalDuration: '55 min',
                    creator: 'Melodi AI',
                  ),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(icon, color: Colors.white70, size: 26),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EngineCard extends StatelessWidget {
  final String name;
  final String desc;
  final IconData icon;
  final Color accentColor;

  const _EngineCard({
    required this.name,
    required this.desc,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PlaylistDetailScreen(
              playlist: PlaylistInfo(
                id: 'engine_$name',
                title: name,
                description: desc,
                icon: icon,
                gradientColors: [
                  accentColor.withValues(alpha: 0.3),
                  accentColor,
                ],
                trackCount: 20,
                totalDuration: '1h 10min',
                creator: 'AI Engine',
              ),
            ),
          ),
        );
      },
      child: Container(
      width: 200,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'AI',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.white54,
                  height: 1.3,
                ),
          ),
        ],
      ),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _GenreChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PlaylistDetailScreen(
                  playlist: PlaylistInfo(
                    id: 'genre_$label',
                    title: label,
                    description: 'Best of $label',
                    icon: icon,
                    gradientColors: [color, color.withValues(alpha: 0.6)],
                    trackCount: 24,
                    totalDuration: '1h 20min',
                    creator: 'Melodi Curators',
                  ),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
