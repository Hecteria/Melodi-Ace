import 'package:flutter/material.dart';
import '../../../core/locale/locale_scope.dart';
import '../../../core/theme/app_theme.dart';
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
// SIMPLE TAB
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
          Row(
            children: [
              Icon(Icons.library_music, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                context.l10n.createMasterpiece,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.describeAtmosphere,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.white54),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: TextField(
              controller: controller.descriptionController,
              maxLines: 4,
              maxLength: CreationData.maxDescriptionLength,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: context.l10n.trackDescriptionHint,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                counterStyle: const TextStyle(color: AppColors.white54),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            context.l10n.selectGenre,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: CreationData.genres.map((genre) {
              return _ChipButton(
                label: genre,
                selected: controller.selectedGenre == genre,
                onTap: () => controller.selectGenre(genre),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          Text(
            context.l10n.musicalMood,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: CreationData.moods.map((mood) {
              return _ChipButton(
                label: mood,
                selected: controller.selectedMood == mood,
                onTap: () => controller.selectMood(mood),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          _GenerateButton(controller: controller),
          const SizedBox(height: 100),
        ],
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
          _UploadAudioCard(),
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
          Icon(Icons.edit_note_rounded,
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
// SHARED: TEXT AREA CARD
// ══════════════════════════════════════════════════════════════════

class _TextAreaCard extends StatelessWidget {
  const _TextAreaCard({
    required this.label,
    required this.hint,
    required this.textController,
  });

  final String label;
  final String hint;
  final TextEditingController textController;

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
          // Header: label + AI icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
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
          // Textarea with orange hint overlay + resize handle
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: textController,
            builder: (context, value, _) => Stack(
              alignment: Alignment.bottomRight,
              children: [
                TextField(
                  controller: textController,
                  minLines: 4,
                  maxLines: 8,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isCollapsed: true,
                  ),
                ),
                // Orange hint text — visible only when field is empty
                if (value.text.isEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 20,
                    child: IgnorePointer(
                      child: Text(
                        hint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary.withValues(alpha: 0.7),
                              fontSize: 13,
                            ),
                      ),
                    ),
                  ),
                // Resize handle icon (decorative)
                Icon(
                  Icons.open_in_full,
                  color: AppColors.white30,
                  size: 13,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// SHARED: UPLOAD AUDIO CARD (Remix tab)
// ══════════════════════════════════════════════════════════════════

class _UploadAudioCard extends StatelessWidget {
  const _UploadAudioCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // TODO: open file picker
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
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
              child: const Icon(
                Icons.upload_rounded,
                color: Colors.white,
                size: 22,
              ),
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
        ),
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
                    canDecrement: true, // wraps around
                    canIncrement: true, // wraps around
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

// ── Section label (orange) ────────────────────────────────────────

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

// ── Stepper row: icon | label (range) | [−] value [+] Clear ──────

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
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13),
                  ),
                  TextSpan(
                    text: ' $rangeHint',
                    style: TextStyle(
                        color: AppColors.white54,
                        fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          // [−]
          GestureDetector(
            onTap: canDecrement ? onDecrement : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '−',
                style: TextStyle(
                  color:
                      canDecrement ? Colors.white : AppColors.white30,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          // value
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
          // [+]
          GestureDetector(
            onTap: canIncrement ? onIncrement : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '+',
                style: TextStyle(
                  color:
                      canIncrement ? Colors.white : AppColors.white30,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          // Clear
          GestureDetector(
            onTap: onClear,
            child: Text(
              context.l10n.clearLabel,
              style: TextStyle(
                color: isModified
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

// ── Key row: icon | Key | [<] value [>] | Clear ───────────────────

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
              child: Icon(Icons.chevron_left,
                  color: Colors.white, size: 22),
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
              child: Icon(Icons.chevron_right,
                  color: Colors.white, size: 22),
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
                hintStyle: const TextStyle(
                    color: AppColors.white30, fontSize: 13),
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
      onTap: () {}, // TODO: open file picker
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
// SHARED: CHIP BUTTON
// ══════════════════════════════════════════════════════════════════

class _ChipButton extends StatelessWidget {
  const _ChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.12),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selected ? Colors.white : Colors.white70,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
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
