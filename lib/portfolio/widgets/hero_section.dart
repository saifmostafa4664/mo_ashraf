import 'dart:math' as math;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/profile_model.dart';
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
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF171219),
              AppColors.bgPrimary,
              Color(0xFF1A1D22),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 9,
          child: FadeInLeft(
            duration: const Duration(milliseconds: 850),
            child: _buildCopy(isWide: true),
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 7,
          child: FadeInRight(
            duration: const Duration(milliseconds: 900),
            delay: const Duration(milliseconds: 150),
            child: _buildConstellationStage(),
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
          child: _buildConstellationStage(),
        ),
        const SizedBox(height: 28),
        FadeInUp(
          duration: const Duration(milliseconds: 850),
          child: _buildCopy(isWide: false),
        ),
      ],
    );
  }

  Widget _buildCopy({required bool isWide}) {
    final name =
        widget.profile.name.isNotEmpty ? widget.profile.name : 'Mohamed Ashraf';
    final title =
        widget.profile.title.isNotEmpty ? widget.profile.title : 'Retoucher';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAvailability(),
        const SizedBox(height: 24),
        Text(
          title.toUpperCase(),
          style: AppTextStyles.label.copyWith(
            color: AppColors.champagne,
            fontSize: isWide ? 13 : 11,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 14),
        _ShimmerTitle(
          text: name,
          fontSize: isWide ? 88 : 52,
          animation: _motionController,
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'High-end retouching for product, food, cosmetics, fashion, and commercial work with a precise, premium finish.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.92),
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 30),
        _buildActions(isWide),
      ],
    );
  }

  Widget _buildAvailability() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_fix_high, color: AppColors.champagne, size: 16),
          const SizedBox(width: 9),
          Text(
            'REMOTE RETOUCHER / TEAM LEAD',
            style: AppTextStyles.label.copyWith(
              color: AppColors.textPrimary,
              fontSize: 10,
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

  Widget _buildConstellationStage() {
    return AnimatedBuilder(
      animation: _motionController,
      builder: (context, child) {
        final value = Curves.easeInOut.transform(_motionController.value);
        return Transform.translate(
          offset: Offset(0, (value * 16) - 8),
          child: const SizedBox(
            height: 520,
            child: CustomPaint(
              painter: _ConstellationPainter(
                glow: AppColors.champagne,
                primary: AppColors.crimson,
                secondary: AppColors.teal,
              ),
            ),
          ),
        );
      },
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
                ? AppColors.crimson
                : AppColors.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: widget.isPrimary
                  ? AppColors.crimson
                  : AppColors.divider.withValues(alpha: 0.9),
            ),
            boxShadow: _hovered && widget.isPrimary
                ? const [
                    BoxShadow(
                      color: Color(0x3D8B5CF6),
                      blurRadius: 24,
                    ),
                  ]
                : const [],
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

class _ConstellationPainter extends CustomPainter {
  final Color glow;
  final Color primary;
  final Color secondary;

  const _ConstellationPainter({
    required this.glow,
    required this.primary,
    required this.secondary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.52, size.height * 0.52);

    final colors = <Color>[
      primary,
      glow,
      secondary,
      const Color(0xFFB777FF),
      const Color(0xFF6CC4FF)
    ];

    for (var i = 0; i < 70; i++) {
      final angle = (i / 70) * math.pi * 2 + (i % 3) * 0.6;
      final radius = 80 + (i % 10) * 14 + (i % 5) * 4;
      final x = center.dx + math.cos(angle) * radius * 0.75;
      final y = center.dy + math.sin(angle) * radius * 0.9;
      final triangleSize = 4.0 + (i % 4);
      final trianglePaint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: 0.9)
        ..style = PaintingStyle.fill;
      final path = Path();
      final p1 = Offset(x - triangleSize, y + triangleSize);
      final p2 = Offset(x + triangleSize, y + triangleSize);
      final p3 = Offset(x, y - triangleSize * 1.3);
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(p3.dx, p3.dy);
      path.close();
      canvas.drawPath(path, trianglePaint);
    }

    final clusterPaint = Paint()
      ..color = primary.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final brainPath = Path();
    brainPath.moveTo(center.dx - 120, center.dy + 40);
    brainPath.quadraticBezierTo(
      center.dx - 180,
      center.dy - 80,
      center.dx - 70,
      center.dy - 130,
    );
    brainPath.quadraticBezierTo(
      center.dx + 30,
      center.dy - 180,
      center.dx + 150,
      center.dy - 100,
    );
    brainPath.quadraticBezierTo(
      center.dx + 210,
      center.dy - 20,
      center.dx + 110,
      center.dy + 120,
    );
    brainPath.quadraticBezierTo(
      center.dx + 20,
      center.dy + 190,
      center.dx - 80,
      center.dy + 160,
    );
    brainPath.quadraticBezierTo(
      center.dx - 170,
      center.dy + 130,
      center.dx - 120,
      center.dy + 40,
    );
    canvas.drawPath(brainPath, clusterPaint);

    for (var i = 0; i < 24; i++) {
      final dx = center.dx + (i - 12) * 15;
      final dy = center.dy + math.sin(i * 0.8) * 52;
      final dot = Paint()
        ..color = colors[i % colors.length].withValues(alpha: 0.9);
      canvas.drawCircle(Offset(dx, dy), 2.2, dot);
    }

    final aura = Paint()
      ..color = primary.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 140, aura);
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) {
    return oldDelegate.glow != glow ||
        oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary;
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
