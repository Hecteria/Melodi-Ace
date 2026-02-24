import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/locale/locale_scope.dart';
import '../../../core/services/auth_scope.dart';
import '../../../core/theme/app_theme.dart';
import '../../playlist_detail/data/playlist_detail_data.dart';
import '../../playlist_detail/presentation/playlist_detail_screen.dart';
import '../controllers/home_controller.dart';
import '../data/home_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = HomeController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _greetingLabel(BuildContext context) {
    switch (_controller.greetingType) {
      case GreetingType.morning:
        return context.l10n.greetingMorning;
      case GreetingType.afternoon:
        return context.l10n.greetingAfternoon;
      case GreetingType.evening:
        return context.l10n.greetingEvening;
    }
  }

  String _userName(BuildContext context) {
    final user = AuthScope.of(context).userModel;
    if (user?.displayName.isNotEmpty == true) return user!.displayName;
    return context.l10n.guestName;
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
                // Dynamic Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greetingLabel(context),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.white54),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _userName(context),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildIconButton(Icons.notifications_none_rounded),
                          const SizedBox(width: 8),
                          _buildIconButton(Icons.settings_outlined),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Access Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3.0,
                    ),
                    itemCount: HomeData.quickAccessItems.length,
                    itemBuilder: (context, index) {
                      final item = HomeData.quickAccessItems[index];
                      return _buildQuickAccessCard(context, item);
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Continue Listening
                _sectionTitle(context, context.l10n.continueListening),
                const SizedBox(height: 16),
                SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: HomeData.continueListening.length,
                    itemBuilder: (context, index) {
                      final track = HomeData.continueListening[index];
                      return _buildContinueListeningCard(context, track);
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Made for You
                _sectionTitle(context, context.l10n.madeForYou),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: HomeData.madeForYou.length,
                    itemBuilder: (context, index) {
                      final playlist = HomeData.madeForYou[index];
                      return _buildMadeForYouCard(context, playlist);
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Your Recent Creations
                _sectionTitle(context, context.l10n.yourRecentCreations),
                const SizedBox(height: 16),
                _buildRecentCreationsSection(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
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

  void _openPlaylist(PlaylistInfo info) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlaylistDetailScreen(playlist: info),
      ),
    );
  }

  // ---- Quick Access Grid ----
  Widget _buildQuickAccessCard(BuildContext context, QuickAccessItem item) {
    return GestureDetector(
      onTap: () => _openPlaylist(PlaylistInfo(
        id: item.id,
        title: item.title,
        description: item.subtitle,
        icon: Icons.music_note_rounded,
        gradientColors: const [AppColors.chocolate, AppColors.primary],
        trackCount: 8,
        totalDuration: '32 min',
        creator: 'Melodi AI',
      )),
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.chocolate, AppColors.primary],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Icon(Icons.music_note_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: AppColors.white54,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      ),
    );
  }

  // ---- Continue Listening ----
  Widget _buildContinueListeningCard(
      BuildContext context, ContinueListeningTrack track) {
    final minutesLeft = track.secondsLeft ~/ 60;
    final secsLeft = track.secondsLeft % 60;
    final timeStr = '$minutesLeft:${secsLeft.toString().padLeft(2, '0')}';
    final timeLeft = context.l10n.timeLeft(timeStr);

    return GestureDetector(
      onTap: () => _openPlaylist(PlaylistInfo(
        id: 'continue_${track.title}',
        title: track.title,
        description: '${track.model} \u2022 ${track.duration}',
        icon: Icons.play_circle_outline_rounded,
        gradientColors: const [AppColors.saddleBrown, AppColors.primary],
        trackCount: 8,
        totalDuration: track.duration,
        creator: track.model,
      )),
      child: Container(
      width: 170,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),
          // Progress ring with play button
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: CustomPaint(
                    painter: _ProgressRingPainter(
                      progress: track.progress,
                      color: AppColors.primary,
                      bgColor: Colors.white.withValues(alpha: 0.08),
                      strokeWidth: 3,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: AppColors.primary, size: 22),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            track.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            track.model,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.white54,
                  fontSize: 11,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            timeLeft,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
          ),
        ],
      ),
      ),
    );
  }

  // ---- Made for You ----
  Widget _buildMadeForYouCard(
      BuildContext context, MadeForYouPlaylist playlist) {
    return GestureDetector(
      onTap: () => _openPlaylist(PlaylistInfo(
        id: 'made_${playlist.title}',
        title: playlist.title,
        description: playlist.description,
        icon: playlist.icon,
        gradientColors: playlist.gradientColors,
        trackCount: 12,
        totalDuration: '45 min',
        creator: 'Melodi AI',
      )),
      child: Container(
      width: 160,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: playlist.gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(playlist.icon, color: Colors.white, size: 24),
            ),
            const Spacer(),
            Text(
              playlist.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              playlist.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  // ---- Recent Creations ----
  Widget _buildRecentCreationsSection(BuildContext context) {
    if (HomeData.recentCreations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(Icons.auto_awesome_rounded,
                  color: AppColors.primary, size: 36),
              const SizedBox(height: 12),
              Text(
                context.l10n.createFirstTrack,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.createFirstTrackDesc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.white54,
                    ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  context.l10n.startCreating,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: HomeData.recentCreations.length,
        itemBuilder: (context, index) {
          final creation = HomeData.recentCreations[index];
          return _buildRecentCreationCard(context, creation);
        },
      ),
    );
  }

  Widget _buildRecentCreationCard(
      BuildContext context, RecentCreation creation) {
    final daysText = creation.daysAgo == 1
        ? context.l10n.dayAgo
        : context.l10n.daysAgo(creation.daysAgo);

    return GestureDetector(
      onTap: () => _openPlaylist(PlaylistInfo(
        id: 'creation_${creation.title}',
        title: creation.title,
        description: creation.prompt,
        icon: creation.icon,
        gradientColors: const [Color(0xFF2d1e12), AppColors.primary],
        trackCount: 1,
        totalDuration: '3:42',
        creator: 'You',
      )),
      child: Container(
      width: 150,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(creation.icon, color: AppColors.primary, size: 22),
          ),
          const Spacer(),
          Text(
            creation.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            daysText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.white54,
                  fontSize: 11,
                ),
          ),
        ],
      ),
      ),
    );
  }
}

// ---- Progress Ring Painter ----
class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color bgColor;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.bgColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background ring
    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
