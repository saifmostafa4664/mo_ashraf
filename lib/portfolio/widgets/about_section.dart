import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/profile_model.dart';
import 'package:mo_ashraf/portfolio/widgets/portfolio_image.dart';
import 'package:mo_ashraf/portfolio/widgets/scroll_animator.dart';

class AboutSection extends StatelessWidget {
  final ProfileModel profile;

  const AboutSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 100,
      ),
      child: ScrollAnimator(
        child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2, child: _buildPhoto()),
        const SizedBox(width: 80),
        Expanded(flex: 3, child: _buildContent()),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [_buildPhoto(), const SizedBox(height: 48), _buildContent()],
    );
  }

  Widget _buildPhoto() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        child: AspectRatio(
          aspectRatio: 0.75,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.champagne.withValues(alpha: 0.35),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.champagne.withValues(alpha: 0.12),
                  blurRadius: 48,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: PortfolioImage(
                path: profile.photoUrl.isNotEmpty
                    ? profile.photoUrl
                    : 'assets/me.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ABOUT ME', style: AppTextStyles.label),
        const SizedBox(height: 16),
        Text('WHO I AM', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 8),
        Container(width: 60, height: 3, color: AppColors.champagne),
        const SizedBox(height: 32),
        Text(
          profile.summary.isNotEmpty
              ? profile.summary
              : 'Professional High-End Retoucher specializing in Beauty, Fashion, Commercial, and Editorial retouching. Transforming raw captures into stunning visual masterpieces while maintaining natural aesthetics.',
          style: AppTextStyles.body.copyWith(height: 2.0),
        ),
        const SizedBox(height: 48),
        _buildStats(),
      ],
    );
  }

  Widget _buildStats() {
    final stats = [
      {'value': profile.stats['projectsCount'] ?? '150+', 'label': 'PROJECTS'},
      {'value': profile.stats['yearsExperience'] ?? '5+', 'label': 'YEARS'},
      {'value': profile.stats['clientsCount'] ?? '80+', 'label': 'CLIENTS'},
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                Text(stat['value']!, style: AppTextStyles.statNumber),
                const SizedBox(height: 4),
                Text(stat['label']!, style: AppTextStyles.statLabel),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
