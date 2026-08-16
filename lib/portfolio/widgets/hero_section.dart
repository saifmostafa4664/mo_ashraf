import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/profile_model.dart';
import 'package:mo_ashraf/portfolio/widgets/portfolio_image.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatefulWidget {
  final ProfileModel profile;
  final VoidCallback onViewPortfolio;

  const HeroSection({
    super.key,
    required this.profile,
    required this.onViewPortfolio,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motionController;

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _motionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 920;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: size.height),
      child: Stack(
        children: [
          _buildBackdrop(),
          Positioned.fill(child: _buildSoftGrid()),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isWide ? 72 : 24,
                isWide ? 92 : 88,
                isWide ? 72 : 24,
                48,
              ),
              child: isWide ? _buildWideHero() : _buildMobileHero(),
            ),
          ),
          _buildScrollCue(),
        ],
      ),
    );
  }

  Widget _buildBackdrop() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF171219),
              AppColors.bgPrimary,
              const Color(0xFF1A1D22),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildSoftGrid() {
    return IgnorePointer(
      child: CustomPaint(
        painter: _HeroGridPainter(
          color: AppColors.textPrimary.withValues(alpha: 0.035),
          accent: AppColors.champagne.withValues(alpha: 0.08),
        ),
      ),
    );
  }

  Widget _buildWideHero() {
    return Row(
      children: [
        Expanded(
          flex: 11,
          child: FadeInLeft(
            duration: const Duration(milliseconds: 850),
            child: _buildCopy(isWide: true),
          ),
        ),
        const SizedBox(width: 56),
        Expanded(
          flex: 9,
          child: FadeInRight(
            duration: const Duration(milliseconds: 900),
            delay: const Duration(milliseconds: 150),
            child: _buildPortraitStage(isWide: true),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 850),
          child: _buildPortraitStage(isWide: false),
        ),
        const SizedBox(height: 34),
        FadeInUp(
          duration: const Duration(milliseconds: 850),
          child: _buildCopy(isWide: false),
        ),
      ],
    );
  }

  Widget _buildCopy({required bool isWide}) {
    final name = widget.profile.name.isNotEmpty
        ? widget.profile.name
        : 'Mohamed Ashraf Mahmoud';
    final title = widget.profile.title.isNotEmpty
        ? widget.profile.title
        : 'Photo Retoucher';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAvailability(),
        const SizedBox(height: 26),
        Text(
          title.toUpperCase(),
          style: AppTextStyles.label.copyWith(
            color: AppColors.teal,
            fontSize: isWide ? 13 : 11,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 12),
        _ShimmerTitle(
          text: name,
          fontSize: isWide ? 74 : 44,
          animation: _motionController,
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            'High-end retouching for product, food, cosmetics, fashion, and commercial visuals with clean detail work and natural finishing.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.92),
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 34),
        _buildActions(isWide),
        const SizedBox(height: 34),
        _buildMetaStrip(isWide),
      ],
    );
  }

  Widget _buildAvailability() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_fix_high, color: AppColors.teal, size: 16),
          const SizedBox(width: 9),
          Text(
            'REMOTE RETOUCHER / TEAM LEAD',
            style: AppTextStyles.label.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(bool isWide) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        _HeroButton(
          icon: Icons.image_search_outlined,
          label: 'Portfolio',
          isPrimary: true,
          onTap: widget.onViewPortfolio,
        ),
        _HeroButton(
          icon: Icons.file_download_outlined,
          label: 'Download CV',
          onTap: () {
            if (widget.profile.cvUrl.isNotEmpty) {
              launchUrl(Uri.parse(widget.profile.cvUrl));
            }
          },
        ),
      ],
    );
  }

  Widget _buildMetaStrip(bool isWide) {
    final items = [('4+', 'Years'), ('150+', 'Images'), ('Remote', 'Workflow')];

    return Wrap(
      spacing: isWide ? 26 : 18,
      runSpacing: 14,
      children: items.map((item) {
        return SizedBox(
          width: isWide ? 118 : 96,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.$1,
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: isWide ? 24 : 20,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.$2.toUpperCase(),
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPortraitStage({required bool isWide}) {
    final imagePath = widget.profile.photoUrl.isNotEmpty
        ? widget.profile.photoUrl
        : 'assets/me.jpeg';

    return AnimatedBuilder(
      animation: _motionController,
      builder: (context, child) {
        final value = Curves.easeInOut.transform(_motionController.value);
        return Transform.translate(
          offset: Offset(0, isWide ? (value * 14) - 7 : 0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: isWide ? -28 : -14,
                top: isWide ? 34 : 24,
                right: isWide ? 34 : 16,
                bottom: isWide ? -24 : -14,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.teal.withValues(alpha: 0.28),
                    ),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: isWide ? 0.74 : 0.9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PortfolioImage(path: imagePath, fit: BoxFit.cover),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.bgPrimary.withValues(alpha: 0.14),
                              AppColors.bgPrimary.withValues(alpha: 0.55),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.35, 0.68, 1],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        right: 18,
                        bottom: 18,
                        child: _buildImageCaption(),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: isWide ? -22 : 12,
                top: isWide ? 54 : 12,
                child: _FloatingToolBadge(value: value),
              ),
              Positioned(
                left: isWide ? -34 : 14,
                bottom: isWide ? 42 : 18,
                child: _BeforeAfterChip(value: value),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageCaption() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.tune, color: AppColors.champagne, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Skin, product, texture, color and final polish',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollCue() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 24,
      child: IgnorePointer(
        child: FadeInUp(
          duration: const Duration(milliseconds: 900),
          delay: const Duration(milliseconds: 900),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary.withValues(alpha: 0.52),
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _HeroButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _HeroButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  State<_HeroButton> createState() => _HeroButtonState();
}

class _ShimmerTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final Animation<double> animation;

  const _ShimmerTitle({
    required this.text,
    required this.fontSize,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final slide = animation.value * 2 - 1;
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                AppColors.crimson,
                AppColors.teal,
                AppColors.champagne,
                AppColors.crimson,
              ],
              stops: [
                (0.0 + slide * 0.18).clamp(0.0, 1.0),
                (0.34 + slide * 0.18).clamp(0.0, 1.0),
                (0.68 + slide * 0.18).clamp(0.0, 1.0),
                1.0,
              ],
            ).createShader(bounds);
          },
          child: Text(
            text,
            style: AppTextStyles.heroTitle.copyWith(
              fontSize: fontSize,
              height: 0.98,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class _HeroButtonState extends State<_HeroButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? AppColors.teal
                : AppColors.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isPrimary
                  ? AppColors.champagne
                  : AppColors.divider.withValues(alpha: 0.9),
            ),
            boxShadow: _hovered && widget.isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.teal.withValues(alpha: 0.22),
                      blurRadius: 24,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: widget.isPrimary
                    ? AppColors.bgPrimary
                    : AppColors.textPrimary,
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: AppTextStyles.buttonText.copyWith(
                  color: widget.isPrimary
                      ? AppColors.bgPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingToolBadge extends StatelessWidget {
  final double value;

  const _FloatingToolBadge({required this.value});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, (value * -10) + 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 30,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.brush_outlined, color: AppColors.teal, size: 17),
            const SizedBox(width: 9),
            Text(
              'DETAIL WORK',
              style: AppTextStyles.label.copyWith(
                color: AppColors.textPrimary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BeforeAfterChip extends StatelessWidget {
  final double value;

  const _BeforeAfterChip({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'BEFORE / AFTER',
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: 0.38 + (value * 0.24),
              minHeight: 5,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation(AppColors.teal),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroGridPainter extends CustomPainter {
  final Color color;
  final Color accent;

  const _HeroGridPainter({required this.color, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const gap = 88.0;

    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final accentPaint = Paint()
      ..color = accent
      ..strokeWidth = 1.2;
    canvas.drawLine(
      Offset(size.width * 0.58, 0),
      Offset(size.width * 0.43, size.height),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HeroGridPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.accent != accent;
  }
}
