import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/skill_model.dart';
import 'package:mo_ashraf/portfolio/widgets/scroll_animator.dart';

class SkillsSection extends StatelessWidget {
  final List<SkillModel> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final groupedSkills = _groupByCategory();

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
          ...groupedSkills.entries.map((entry) {
            return ScrollAnimator(
              child: _buildCategoryGroup(entry.key, entry.value, isWide),
            );
          }),
        ],
      ),
    );
  }

  Map<String, List<SkillModel>> _groupByCategory() {
    final map = <String, List<SkillModel>>{};
    for (final skill in skills) {
      final cat = skill.category.isNotEmpty ? skill.category : 'General';
      map.putIfAbsent(cat, () => []).add(skill);
    }
    return map;
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text('EXPERTISE', style: AppTextStyles.label),
        const SizedBox(height: 16),
        Text('SKILLS & TOOLS', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 8),
        Container(width: 60, height: 3, color: AppColors.crimson),
      ],
    );
  }

  Widget _buildCategoryGroup(String category, List<SkillModel> skills, bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(
          category.toUpperCase(),
          style: AppTextStyles.label.copyWith(fontSize: 13, letterSpacing: 4),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isWide ? 2.2 : 1.8,
          ),
          itemCount: skills.length,
          itemBuilder: (context, index) {
            return _SkillCard(skill: skills[index]);
          },
        ),
      ],
    );
  }
}

class _SkillCard extends StatefulWidget {
  final SkillModel skill;

  const _SkillCard({required this.skill});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.skill.level / 100.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasAnimated) {
        _hasAnimated = true;
        _progressController.forward();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.surfaceElevated : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? AppColors.crimson.withValues(alpha: 0.4) : AppColors.divider,
          ),
          boxShadow: _isHovered
              ? [BoxShadow(color: AppColors.crimson.withValues(alpha: 0.1), blurRadius: 20)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.skill.name,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${widget.skill.level}%',
                  style: AppTextStyles.label.copyWith(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.bgPrimary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progressAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.bloodRed, AppColors.crimson, AppColors.neonRed],
                        ),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.crimson.withValues(alpha: 0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
