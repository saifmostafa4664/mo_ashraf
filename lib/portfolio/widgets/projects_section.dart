import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/project_model.dart';
import 'package:mo_ashraf/portfolio/widgets/portfolio_image.dart';
import 'package:mo_ashraf/portfolio/widgets/scroll_animator.dart';

class ProjectsSection extends StatefulWidget {
  final List<ProjectModel> projects;

  const ProjectsSection({super.key, required this.projects});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _selectedCategory = 'All';
  ProjectModel? _selectedProject;

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
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 100,
      ),
      child: Column(
        children: [
          ScrollAnimator(child: _buildHeader()),
          const SizedBox(height: 40),
          ScrollAnimator(child: _buildFilterTabs()),
          const SizedBox(height: 48),
          _buildGrid(isWide),
          if (_selectedProject != null) _buildProjectModal(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text('PORTFOLIO', style: AppTextStyles.label),
        const SizedBox(height: 16),
        Text('MY WORK', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 8),
        Container(width: 60, height: 3, color: AppColors.crimson),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: _categories.map((cat) {
        final isActive = _selectedCategory == cat;
        return InkWell(
          onTap: () => setState(() => _selectedCategory = cat),
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? AppColors.crimson : AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isActive ? AppColors.crimson : AppColors.divider,
              ),
            ),
            child: Text(
              cat.toUpperCase(),
              style: AppTextStyles.label.copyWith(
                color: isActive
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGrid(bool isWide) {
    final crossAxisCount = isWide
        ? 3
        : (MediaQuery.of(context).size.width > 600 ? 2 : 1);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: GridView.builder(
        key: ValueKey(_selectedCategory),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.85,
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
        onTap: () => _showProjectDetail(project),
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
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isWide ? 900 : double.infinity,
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
                            top: Radius.circular(16),
                          ),
                          child: PortfolioImage(
                            path: project.imageUrls.first,
                            width: double.infinity,
                            height: 400,
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
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.title,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.crimson.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                project.category,
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            if (project.client.isNotEmpty) ...[
                              const SizedBox(width: 12),
                              Text(
                                project.client,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(project.description, style: AppTextStyles.body),
                        if (project.beforeImageUrl.isNotEmpty &&
                            project.afterImageUrl.isNotEmpty) ...[
                          const SizedBox(height: 32),
                          Text('BEFORE & AFTER', style: AppTextStyles.label),
                          const SizedBox(height: 16),
                          _BeforeAfterSlider(
                            beforeUrl: project.beforeImageUrl,
                            afterUrl: project.afterImageUrl,
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
      },
    );
  }

  Widget _buildProjectModal(BuildContext context) {
    return const SizedBox.shrink();
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? AppColors.crimson.withValues(alpha: 0.5)
                : AppColors.divider,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.crimson.withValues(alpha: 0.15),
                    blurRadius: 30,
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (widget.project.imageUrls.isNotEmpty)
                AnimatedScale(
                  scale: _isHovered ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 400),
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
                    color: AppColors.divider,
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
                          ? AppColors.bgPrimary.withValues(alpha: 0.9)
                          : AppColors.bgPrimary.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.3, 1.0],
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgPrimary.withValues(alpha: 0.62),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.champagne.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        widget.project.category.toUpperCase(),
                        style: AppTextStyles.label.copyWith(fontSize: 9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.project.title, style: AppTextStyles.cardTitle),
                    if (widget.project.client.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.project.client,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (_isHovered)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.champagne,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_outward,
                      color: AppColors.bgPrimary,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BeforeAfterSlider extends StatefulWidget {
  final String beforeUrl;
  final String afterUrl;

  const _BeforeAfterSlider({required this.beforeUrl, required this.afterUrl});

  @override
  State<_BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<_BeforeAfterSlider> {
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 300,
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PortfolioImage(
                    path: widget.afterUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: ClipRect(
                  clipper: _SliderClipper(_sliderValue),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: PortfolioImage(
                      path: widget.beforeUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: constraints.maxWidth * _sliderValue - 1,
                top: 0,
                bottom: 0,
                child: Container(width: 2, color: AppColors.crimson),
              ),
              Positioned.fill(
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _sliderValue =
                          (details.localPosition.dx / constraints.maxWidth)
                              .clamp(0.0, 1.0);
                    });
                  },
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bgPrimary.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'BEFORE',
                    style: AppTextStyles.label.copyWith(fontSize: 9),
                  ),
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bgPrimary.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'AFTER',
                    style: AppTextStyles.label.copyWith(fontSize: 9),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SliderClipper extends CustomClipper<Rect> {
  final double value;

  _SliderClipper(this.value);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * value, size.height);
  }

  @override
  bool shouldReclip(covariant _SliderClipper oldClipper) {
    return oldClipper.value != value;
  }
}
