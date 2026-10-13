import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/project_model.dart';
import 'package:mo_ashraf/portfolio/widgets/portfolio_image.dart';
import 'package:mo_ashraf/portfolio/widgets/scroll_animator.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatefulWidget {
  final List<ProjectModel> projects;

  const ProjectsSection({super.key, required this.projects});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _selectedCategory = 'All';

  List<String> get _categories {
    final cats = widget.projects.map((p) => p.category).toSet().toList();
    return ['All', ...cats];
  }

  List<ProjectModel> get _filteredProjects {
    if (_selectedCategory == 'All') return widget.projects;
    return widget.projects
        .where((p) => p.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 72 : 24,
        vertical: 90,
      ),
      color: AppColors.bgPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollAnimator(child: _buildHeader()),
          const SizedBox(height: 30),
          ScrollAnimator(child: _buildFilterTabs()),
          const SizedBox(height: 38),
          _buildGrid(isWide),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SELECTED WORK', style: AppTextStyles.label),
        const SizedBox(height: 16),
        Text('Projects', style: AppTextStyles.sectionTitle),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _categories.map((cat) {
        final isActive = _selectedCategory == cat;
        return InkWell(
          onTap: () => setState(() => _selectedCategory = cat),
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? AppColors.crimson : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isActive ? AppColors.crimson : AppColors.divider,
              ),
            ),
            child: Text(
              cat.toUpperCase(),
              style: AppTextStyles.label.copyWith(
                color:
                    isActive ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 10,
                letterSpacing: 1.6,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGrid(bool isWide) {
    final crossAxisCount =
        isWide ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: GridView.builder(
        key: ValueKey(_selectedCategory),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: isWide ? 0.94 : 0.8,
        ),
        itemCount: _filteredProjects.length,
        itemBuilder: (context, index) {
          return ScrollAnimator(
            offset: Offset(0, 20.0 + (index % 3) * 10),
            child: _buildProjectCard(_filteredProjects[index]),
          );
        },
      ),
    );
  }

  Widget _buildProjectCard(ProjectModel project) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final url = Uri.tryParse(project.projectUrl.trim());
          if (url != null && (url.isScheme('http') || url.isScheme('https'))) {
            await launchUrl(url, webOnlyWindowName: '_blank');
          } else {
            _showProjectDetail(project);
          }
        },
        child: _HoverCard(project: project),
      ),
    );
  }

  void _showProjectDetail(ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) {
        final isWide = MediaQuery.of(context).size.width > 900;
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isWide ? 920 : double.infinity,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      if (project.imageUrls.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          child: PortfolioImage(
                            path: project.imageUrls.first,
                            width: double.infinity,
                            height: 420,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.bgPrimary.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.textPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.title,
                          style:
                              AppTextStyles.sectionTitle.copyWith(fontSize: 32),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.crimson.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                project.category,
                                style:
                                    AppTextStyles.label.copyWith(fontSize: 10),
                              ),
                            ),
                            if (project.client.isNotEmpty) ...[
                              const SizedBox(width: 12),
                              Text(
                                project.client,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(project.description, style: AppTextStyles.body),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HoverCard extends StatefulWidget {
  final ProjectModel project;

  const _HoverCard({required this.project});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (widget.project.imageUrls.isNotEmpty)
                AnimatedScale(
                  scale: _isHovered ? 1.04 : 1,
                  duration: const Duration(milliseconds: 450),
                  child: PortfolioImage(
                    path: widget.project.imageUrls.first,
                    fit: BoxFit.cover,
                    fallback: Container(color: AppColors.surface),
                  ),
                )
              else
                Container(
                  color: AppColors.surface,
                  child: const Icon(
                    Icons.image_outlined,
                    color: AppColors.textSecondary,
                    size: 48,
                  ),
                ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      _isHovered
                          ? AppColors.bgPrimary.withValues(alpha: 0.92)
                          : AppColors.bgPrimary.withValues(alpha: 0.72),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.35, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: 18,
                left: 18,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.champagne.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    widget.project.category.toUpperCase(),
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.champagne,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.project.title,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.project.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
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
