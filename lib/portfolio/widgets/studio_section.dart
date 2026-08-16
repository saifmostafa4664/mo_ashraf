import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/profile_model.dart';
import 'package:mo_ashraf/portfolio/widgets/portfolio_image.dart';
import 'package:mo_ashraf/portfolio/widgets/scroll_animator.dart';

class StudioSection extends StatefulWidget {
  final ProfileModel profile;

  const StudioSection({super.key, required this.profile});

  @override
  State<StudioSection> createState() => _StudioSectionState();
}

class _StudioSectionState extends State<StudioSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return ScrollAnimator(
      child: SizedBox(
        height: isWide ? 500 : 400,
        width: double.infinity,
        child: Stack(
          children: [
            _buildStudioImage(),
            _buildOverlay(),
            _buildContent(isWide),
            _buildGlowBorders(),
          ],
        ),
      ),
    );
  }

  Widget _buildStudioImage() {
    if (widget.profile.studioPhotoUrl.isNotEmpty) {
      return Positioned.fill(
        child: PortfolioImage(
          path: widget.profile.studioPhotoUrl,
          fit: BoxFit.cover,
          fallback: _buildFallback(),
        ),
      );
    }
    return Positioned.fill(child: _buildFallback());
  }

  Widget _buildFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2A2026), AppColors.bgPrimary, Color(0xFF1D2E31)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.bgPrimary.withValues(alpha: 0.68),
              AppColors.bgPrimary.withValues(alpha: 0.28),
              AppColors.bgPrimary.withValues(alpha: 0.72),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isWide) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'THE WORKSPACE',
            style: AppTextStyles.label.copyWith(letterSpacing: 6),
          ),
          const SizedBox(height: 20),
          Text(
            'WHERE DETAILS\nCOME ALIVE',
            style: AppTextStyles.heroTitle.copyWith(
              fontSize: isWide ? 64 : 40,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            widget.profile.tagline.isNotEmpty
                ? widget.profile.tagline.toUpperCase()
                : 'CREATIVE FLOW',
            style: AppTextStyles.subtitle.copyWith(
              color: AppColors.champagne,
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowBorders() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final opacity = _pulseController.value * 0.3 + 0.1;
        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.champagne.withValues(alpha: opacity),
                  width: 1,
                ),
                bottom: BorderSide(
                  color: AppColors.teal.withValues(alpha: opacity),
                  width: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
