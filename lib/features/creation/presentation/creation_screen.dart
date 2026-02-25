import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../core/locale/locale_scope.dart';
import '../../../core/theme/app_theme.dart';
import '../../library/data/library_data.dart';
import '../controllers/creation_controller.dart';
import '../data/creation_data.dart';

class CreationScreen extends StatefulWidget {
  const CreationScreen({super.key});

  @override
  State<CreationScreen> createState() => _CreationScreenState();
}

class _CreationScreenState extends State<CreationScreen> {
  final _controller = CreationController();

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
          builder: (context, _) => Column(
            children: [
              // ── Header ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: const Icon(Icons.chevron_left,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.l10n.aiCreationSuite,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // ── Mode tab bar ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ModeTabBar(
                  activeTab: _controller.activeTab,
                  onTabSelected: _controller.setTab,
                ),
              ),
              const SizedBox(height: 16),
              // ── Tab content (IndexedStack preserves state) ───
              Expanded(
                child: IndexedStack(
                  index: _controller.activeTab.index,
                  children: [
                    _SimpleTabContent(controller: _controller),
                    _CustomTabContent(controller: _controller),
                    _RemixTabContent(controller: _controller),
                    _EditTabContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// MODE TAB BAR
// ══════════════════════════════════════════════════════════════════

class _ModeTabBar extends StatelessWidget {
  const _ModeTabBar({
    required this.activeTab,
    required this.onTabSelected,
  });

  final CreationTab activeTab;
  final ValueChanged<CreationTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (CreationTab.simple, context.l10n.tabSimple),
      (CreationTab.custom, context.l10n.tabCustom),
      (CreationTab.remix, context.l10n.tabRemix),
      (CreationTab.edit, context.l10n.tabEdit),
    ];

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: tabs.map((entry) {
          final (tab, label) = entry;
          final isActive = activeTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isActive
                            ? AppColors.backgroundDark
                            : AppColors.white54,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w400,
                        fontSize: 13,
                      ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// SIMPLE TAB — Song Description + Instrumental toggle
// ══════════════════════════════════════════════════════════════════

class _SimpleTabContent extends StatelessWidget {
  const _SimpleTabContent({required this.controller});
  final CreationController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TextAreaCard(
            label: context.l10n.songDescription,
            hint: context.l10n.songDescriptionHint,
            textController: controller.descriptionController,
          ),
          const SizedBox(height: 16),
          // Instrumental toggle chip
          _InstrumentalChip(
            active: controller.instrumental,
            label: context.l10n.instrumental,
            onTap: controller.toggleInstrumental,
          ),
          const SizedBox(height: 32),
          _GenerateButton(controller: controller),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ── Instrumental chip ─────────────────────────────────────────────

class _InstrumentalChip extends StatelessWidget {
  const _InstrumentalChip({
    required this.active,
    required this.label,
    required this.onTap,
  });

  final bool active;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active
                ? AppColors.primary.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: active ? AppColors.primary : AppColors.white54,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: active ? AppColors.primary : Colors.white70,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// CUSTOM TAB
// ══════════════════════════════════════════════════════════════════

class _CustomTabContent extends StatelessWidget {
  const _CustomTabContent({required this.controller});
  final CreationController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _TextAreaCard(
            label: context.l10n.lyricsLabel,
            hint: context.l10n.lyricsHint,
            textController: controller.lyricsController,
          ),
          const SizedBox(height: 12),
          _TextAreaCard(
            label: context.l10n.promptLabel,
            hint: context.l10n.promptHint,
            textController: controller.promptController,
          ),
          const SizedBox(height: 12),
          _AdvanceOptionsCard(controller: controller),
          const SizedBox(height: 24),
          _GenerateButton(controller: controller),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// REMIX TAB
// ══════════════════════════════════════════════════════════════════

class _RemixTabContent extends StatelessWidget {
  const _RemixTabContent({required this.controller});
  final CreationController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _UploadAudioCard(controller: controller),
          const SizedBox(height: 12),
          _TextAreaCard(
            label: context.l10n.lyricsLabel,
            hint: context.l10n.lyricsHint,
            textController: controller.lyricsController,
          ),
          const SizedBox(height: 12),
          _TextAreaCard(
            label: context.l10n.promptLabel,
            hint: context.l10n.promptHint,
            textController: controller.promptController,
          ),
          const SizedBox(height: 12),
          _AdvanceOptionsCard(controller: controller),
          const SizedBox(height: 24),
          _GenerateButton(controller: controller),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// EDIT TAB — Placeholder
// ══════════════════════════════════════════════════════════════════

class _EditTabContent extends StatelessWidget {
  const _EditTabContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.edit_note_rounded,
              size: 56, color: AppColors.white30),
          const SizedBox(height: 16),
          Text(
            context.l10n.editTabPlaceholder,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.white54),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// SHARED: RESIZABLE TEXT AREA CARD
// ══════════════════════════════════════════════════════════════════

class _TextAreaCard extends StatefulWidget {
  const _TextAreaCard({
    required this.label,
    required this.hint,
    required this.textController,
  });

  final String label;
  final String hint;
  final TextEditingController textController;

  @override
  State<_TextAreaCard> createState() => _TextAreaCardState();
}

class _TextAreaCardState extends State<_TextAreaCard> {
  static const double _minHeight = 90.0;
  static const double _maxHeight = 340.0;

  double _height = 120.0;
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.textController.text.isEmpty;
    widget.textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final isEmpty = widget.textController.text.isEmpty;
    if (isEmpty != _isEmpty) setState(() => _isEmpty = isEmpty);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: label + AI sparkle icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Icon(
                Icons.auto_awesome,
                color: Colors.white.withValues(alpha: 0.6),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Resizable textarea
          Stack(
            children: [
              SizedBox(
                height: _height,
                child: TextField(
                  controller: widget.textController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 18),
                    isCollapsed: true,
                  ),
                ),
              ),
              // Orange hint overlay — visible only when field is empty
              if (_isEmpty)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 20,
                  child: IgnorePointer(
                    child: Text(
                      widget.hint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary.withValues(alpha: 0.75),
                            fontSize: 13,
                          ),
                    ),
                  ),
                ),
              // Drag-to-resize handle (bottom-right)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      _height = (_height + details.delta.dy)
                          .clamp(_minHeight, _maxHeight);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.open_in_full,
                      color: AppColors.white30,
                      size: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// SHARED: UPLOAD AUDIO CARD (Remix tab) — functional file picker
// ══════════════════════════════════════════════════════════════════

class _UploadAudioCard extends StatelessWidget {
  const _UploadAudioCard({required this.controller});
  final CreationController controller;

  @override
  Widget build(BuildContext context) {
    final hasFile = controller.remixFileName != null;

    return GestureDetector(
      onTap: () => _showUploadOptions(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasFile
                ? AppColors.primary.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: hasFile
            ? _buildSelectedContent(context)
            : _buildUploadPrompt(context),
      ),
    );
  }

  Widget _buildUploadPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: const Icon(Icons.upload_rounded,
              color: Colors.white, size: 22),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.uploadAudio,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 3),
            Text(
              context.l10n.uploadAudioSubtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.white54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.audio_file_rounded,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.remixFileName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap to change',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: controller.clearRemixFile,
            child: Icon(Icons.close_rounded,
                color: AppColors.white54, size: 20),
          ),
        ],
      ),
    );
  }

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _UploadOptionsSheet(controller: controller),
    );
  }
}

// ── Upload options bottom sheet ───────────────────────────────────

class _UploadOptionsSheet extends StatelessWidget {
  const _UploadOptionsSheet({required this.controller});
  final CreationController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.uploadOptions,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),
          // Pick from device
          _OptionTile(
            icon: Icons.folder_open_rounded,
            title: context.l10n.pickFromDevice,
            subtitle: 'MP3, WAV, M4A, FLAC...',
            onTap: () => _pickFromDevice(context),
          ),
          const SizedBox(height: 10),
          // Pick from library
          _OptionTile(
            icon: Icons.library_music_rounded,
            title: context.l10n.pickFromLibrary,
            subtitle: context.l10n.pickFromLibraryDesc,
            onTap: () => _pickFromLibrary(context),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromDevice(BuildContext context) async {
    Navigator.pop(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        controller.setRemixFile(result.files.first.name);
      }
    } catch (_) {
      // File picker cancelled or failed — no action needed
    }
  }

  void _pickFromLibrary(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _LibraryPickerSheet(controller: controller),
    );
  }
}

// ── Option tile ───────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.white54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.white54, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Library picker bottom sheet ───────────────────────────────────

class _LibraryPickerSheet extends StatelessWidget {
  const _LibraryPickerSheet({required this.controller});
  final CreationController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.pickFromLibrary,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),
          ...LibraryData.tracks.map((track) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    controller.setRemixFile(track.title);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08)),
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
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.music_note_rounded,
                              color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                '${track.model} • ${track.duration}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.white54),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.add_rounded,
                            color: AppColors.primary, size: 22),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// SHARED: ADVANCE OPTIONS CARD
// ══════════════════════════════════════════════════════════════════

class _AdvanceOptionsCard extends StatelessWidget {
  const _AdvanceOptionsCard({required this.controller});
  final CreationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          GestureDetector(
            onTap: controller.toggleAdvanced,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    context.l10n.advanceOptions,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: controller.resetAdvanced,
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      context.l10n.resetAll,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.white54),
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: controller.advancedExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.white54,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Collapsible content
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: controller.advancedExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(label: context.l10n.sectionGeneral),
                  const SizedBox(height: 10),
                  _StepperRow(
                    icon: Icons.timer_outlined,
                    label: context.l10n.durationLabel,
                    rangeHint: context.l10n.durationRange,
                    value: '${controller.durationSeconds}',
                    onDecrement: controller.decrementDuration,
                    onIncrement: controller.incrementDuration,
                    onClear: controller.clearDuration,
                    isModified: controller.isDurationModified,
                    canDecrement: controller.durationSeconds >
                        CreationData.minDurationSeconds,
                    canIncrement: controller.durationSeconds <
                        CreationData.maxDurationSeconds,
                  ),
                  const SizedBox(height: 8),
                  _StepperRow(
                    icon: Icons.music_note_outlined,
                    label: context.l10n.tempoLabel,
                    rangeHint: context.l10n.tempoRange,
                    value: '${controller.tempoBpm}',
                    onDecrement: controller.decrementTempo,
                    onIncrement: controller.incrementTempo,
                    onClear: controller.clearTempo,
                    isModified: controller.isTempoModified,
                    canDecrement:
                        controller.tempoBpm > CreationData.minTempoBpm,
                    canIncrement:
                        controller.tempoBpm < CreationData.maxTempoBpm,
                  ),
                  const SizedBox(height: 8),
                  _StepperRow(
                    icon: Icons.queue_music_outlined,
                    label: context.l10n.timeSignatureLabel,
                    rangeHint: context.l10n.timeSignatureRange,
                    value: '${controller.timeSignatureValue}',
                    onDecrement: controller.decrementTimeSignature,
                    onIncrement: controller.incrementTimeSignature,
                    onClear: controller.clearTimeSignature,
                    isModified: controller.isTimeSignatureModified,
                    canDecrement: true,
                    canIncrement: true,
                  ),
                  const SizedBox(height: 8),
                  _KeyRow(controller: controller),
                  const SizedBox(height: 8),
                  _NegativeTagsRow(controller: controller),
                  const SizedBox(height: 8),
                  _UploadReferenceButton(),
                  const SizedBox(height: 16),
                  _SectionLabel(label: context.l10n.sectionThinking),
                  const SizedBox(height: 10),
                  _ThinkingSlider(controller: controller),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
    );
  }
}

// ── Stepper row ───────────────────────────────────────────────────

class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.icon,
    required this.label,
    required this.rangeHint,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    required this.onClear,
    required this.isModified,
    required this.canDecrement,
    required this.canIncrement,
  });

  final IconData icon;
  final String label;
  final String rangeHint;
  final String value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onClear;
  final bool isModified;
  final bool canDecrement;
  final bool canIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.white54, size: 17),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  TextSpan(
                    text: ' $rangeHint',
                    style:
                        const TextStyle(color: AppColors.white54, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: canDecrement ? onDecrement : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '−',
                style: TextStyle(
                  color: canDecrement ? Colors.white : AppColors.white30,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          GestureDetector(
            onTap: canIncrement ? onIncrement : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '+',
                style: TextStyle(
                  color: canIncrement ? Colors.white : AppColors.white30,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: Text(
              context.l10n.clearLabel,
              style: TextStyle(
                color: isModified ? AppColors.white54 : AppColors.white30,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Key row ───────────────────────────────────────────────────────

class _KeyRow extends StatelessWidget {
  const _KeyRow({required this.controller});
  final CreationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          const Icon(Icons.music_note_rounded,
              color: AppColors.white54, size: 17),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.l10n.keyLabel,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          GestureDetector(
            onTap: controller.prevKey,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.chevron_left, color: Colors.white, size: 22),
            ),
          ),
          SizedBox(
            width: 84,
            child: Text(
              controller.keyValue,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          GestureDetector(
            onTap: controller.nextKey,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child:
                  Icon(Icons.chevron_right, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: controller.clearKey,
            child: Text(
              context.l10n.clearLabel,
              style: TextStyle(
                color: controller.isKeyModified
                    ? AppColors.white54
                    : AppColors.white30,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Negative tags row ─────────────────────────────────────────────

class _NegativeTagsRow extends StatelessWidget {
  const _NegativeTagsRow({required this.controller});
  final CreationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          const Icon(Icons.block_rounded,
              color: AppColors.white54, size: 17),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller.negativeTagsController,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: context.l10n.negativeTags,
                hintStyle:
                    const TextStyle(color: AppColors.white30, fontSize: 13),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.negativeTagsController,
            builder: (_, value, child) => GestureDetector(
              onTap: value.text.isNotEmpty
                  ? controller.negativeTagsController.clear
                  : null,
              child: Text(
                context.l10n.clearLabel,
                style: TextStyle(
                  color: value.text.isNotEmpty
                      ? AppColors.white54
                      : AppColors.white30,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Upload Reference Audio button ─────────────────────────────────

class _UploadReferenceButton extends StatelessWidget {
  const _UploadReferenceButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // TODO: wire to file picker when needed
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.upload_rounded,
                  color: Colors.white70, size: 14),
            ),
            const SizedBox(width: 10),
            Text(
              context.l10n.uploadReferenceAudio,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Creative / Robust slider ──────────────────────────────────────

class _ThinkingSlider extends StatelessWidget {
  const _ThinkingSlider({required this.controller});
  final CreationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Text(
            context.l10n.creativeLabel,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: Colors.white.withValues(alpha: 0.15),
                thumbColor: Colors.white,
                overlayColor: AppColors.primary.withValues(alpha: 0.15),
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 16),
                trackHeight: 3,
              ),
              child: Slider(
                value: controller.thinkingValue,
                onChanged: controller.setThinking,
              ),
            ),
          ),
          Text(
            context.l10n.robustLabel,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// SHARED: GENERATE BUTTON
// ══════════════════════════════════════════════════════════════════

class _GenerateButton extends StatelessWidget {
  const _GenerateButton({required this.controller});
  final CreationController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: controller.busy ? null : controller.generate,
          icon: controller.busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.auto_awesome, size: 22),
          label: Text(
            context.l10n.generateMusic,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
