import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/discover/presentation/discover_screen.dart';
import '../features/creation/presentation/creation_screen.dart';
import '../features/library/presentation/library_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/upgrade/presentation/upgrade_screen.dart';
import 'shell_controller.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _controller = ShellController();

  final _screens = const <Widget>[
    HomeScreen(),
    DiscoverScreen(),
    CreationScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => Scaffold(
        body: IndexedStack(
          index: _controller.currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1C),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_rounded, 'Home', 0),
                  _buildNavItem(Icons.explore_outlined, 'Discover', 1),
                  _buildNavItem(Icons.bolt_rounded, 'Generate', 2),
                  _buildNavItem(
                      Icons.library_music_rounded, 'Library', 3),
                  _buildNavItem(Icons.settings_outlined, 'Profile', 4),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _controller.currentIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const UpgradeScreen(),
                    ),
                  );
                },
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.workspace_premium,
                    color: Colors.white),
              )
            : null,
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _controller.currentIndex == index;
    return GestureDetector(
      onTap: () => _controller.setTab(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.white54,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.white54,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
