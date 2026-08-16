import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/reel_model.dart';
import 'package:mo_ashraf/portfolio/widgets/scroll_animator.dart';

class ReelsSection extends StatelessWidget {
  final List<ReelModel> reels;

  const ReelsSection({super.key, required this.reels});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 100,
      ),
      child: Column(
        children: [
          ScrollAnimator(child: _buildHeader()),
          const SizedBox(height: 60),
          _buildReelsGrid(isWide),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text('TUTORIALS', style: AppTextStyles.label),
        const SizedBox(height: 16),
        Text('REELS & TIPS', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 8),
        Container(width: 60, height: 3, color: AppColors.crimson),
        const SizedBox(height: 16),
        Text(
          'Professional retouching tricks and techniques',
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReelsGrid(bool isWide) {
    final crossAxisCount = isWide ? 3 : 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: isWide ? 0.56 : 0.56,
      ),
      itemCount: reels.length,
      itemBuilder: (context, index) {
        return ScrollAnimator(
          offset: Offset(0, 20.0 + (index % 3) * 10),
          child: _ReelCard(reel: reels[index], index: index),
        );
      },
    );
  }
}

class _ReelCard extends StatefulWidget {
  final ReelModel reel;
  final int index;

  const _ReelCard({required this.reel, required this.index});

  @override
  State<_ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<_ReelCard> {
  bool _isHovered = false;
  late String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'reel-iframe-${widget.index}-${widget.reel.id}';
    _registerIframe();
  }

  void _registerIframe() {
    final embedUrl = widget.reel.embedUrl;
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = embedUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.borderRadius = '12px'
          ..allowFullscreen = true
          ..setAttribute('loading', 'lazy');
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppColors.crimson.withValues(alpha: 0.5) : AppColors.divider,
          ),
          boxShadow: _isHovered
              ? [BoxShadow(color: AppColors.crimson.withValues(alpha: 0.12), blurRadius: 24)]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: HtmlElementView(viewType: _viewId),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildPlatformIcon(),
                        const SizedBox(width: 8),
                        if (widget.reel.category.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.crimson.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.reel.category.toUpperCase(),
                              style: AppTextStyles.label.copyWith(fontSize: 9),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.reel.title,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.reel.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        widget.reel.description,
                        style: AppTextStyles.body.copyWith(fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformIcon() {
    IconData icon;
    switch (widget.reel.platform) {
      case 'youtube':
        icon = Icons.play_circle_outline;
        break;
      case 'tiktok':
        icon = Icons.music_note_outlined;
        break;
      default:
        icon = Icons.camera_alt_outlined;
    }
    return Icon(icon, color: AppColors.crimson, size: 18);
  }
}
