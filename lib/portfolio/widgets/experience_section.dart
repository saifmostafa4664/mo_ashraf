import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/experience_model.dart';
import 'package:mo_ashraf/portfolio/widgets/scroll_animator.dart';

class ExperienceSection extends StatelessWidget {
  final List<ExperienceModel> experiences;

  const ExperienceSection({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 100,
      ),
      color: AppColors.bgSecondary,
      child: Column(
        children: [
          ScrollAnimator(child: _buildHeader()),
          const SizedBox(height: 60),
          ...experiences.asMap().entries.map((entry) {
            return ScrollAnimator(
              offset: const Offset(0, 30),
              child: _buildTimelineItem(entry.value, entry.key, isWide),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text('EXPERIENCE', style: AppTextStyles.label),
        const SizedBox(height: 16),
        Text('WHERE I WORKED', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 8),
        Container(width: 60, height: 3, color: AppColors.crimson),
      ],
    );
  }

  Widget _buildTimelineItem(ExperienceModel exp, int index, bool isWide) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTimelineLine(index),
            const SizedBox(width: 32),
            Expanded(child: _buildExperienceCard(exp)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineLine(int index) {
    return SizedBox(
      width: 24,
      child: Column(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.crimson,
              boxShadow: [
                BoxShadow(
                  color: AppColors.crimson.withValues(alpha: 0.4),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.crimson.withValues(alpha: 0.6),
                    AppColors.crimson.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(ExperienceModel exp) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(exp.role, style: AppTextStyles.cardTitle),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: exp.isCurrent ? AppColors.crimson.withValues(alpha: 0.15) : AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: exp.isCurrent ? AppColors.crimson.withValues(alpha: 0.4) : AppColors.divider,
                  ),
                ),
                child: Text(
                  exp.isCurrent ? 'CURRENT' : '${exp.startDate} - ${exp.endDate}',
                  style: AppTextStyles.label.copyWith(
                    fontSize: 10,
                    color: exp.isCurrent ? AppColors.crimson : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            exp.company,
            style: AppTextStyles.body.copyWith(color: AppColors.crimson.withValues(alpha: 0.8)),
          ),
          if (exp.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(exp.description, style: AppTextStyles.body),
          ],
        ],
      ),
    );
  }
}
