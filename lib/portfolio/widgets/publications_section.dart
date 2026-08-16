import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/publication_model.dart';
import 'package:mo_ashraf/portfolio/widgets/scroll_animator.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicationsSection extends StatelessWidget {
  final List<PublicationModel> publications;

  const PublicationsSection({super.key, required this.publications});

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
          ...publications.asMap().entries.map((entry) {
            return ScrollAnimator(
              child: _PublicationCard(publication: entry.value),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text('FEATURED IN', style: AppTextStyles.label),
        const SizedBox(height: 16),
        Text('PUBLICATIONS', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 8),
        Container(width: 60, height: 3, color: AppColors.crimson),
      ],
    );
  }
}

class _PublicationCard extends StatefulWidget {
  final PublicationModel publication;

  const _PublicationCard({required this.publication});

  @override
  State<_PublicationCard> createState() => _PublicationCardState();
}

class _PublicationCardState extends State<_PublicationCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (widget.publication.link.isNotEmpty) {
            launchUrl(Uri.parse(widget.publication.link));
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.surfaceElevated : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? AppColors.crimson.withValues(alpha: 0.4) : AppColors.divider,
            ),
          ),
          child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
        ),
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        if (widget.publication.imageUrl.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.publication.imageUrl,
              width: 120,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 24),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.publication.title, style: AppTextStyles.cardTitle),
              const SizedBox(height: 4),
              Text(widget.publication.publisher, style: AppTextStyles.body),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(widget.publication.date, style: AppTextStyles.label.copyWith(fontSize: 11)),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.arrow_outward,
                color: _isHovered ? AppColors.crimson : AppColors.textSecondary,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.publication.imageUrl.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.publication.imageUrl,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(widget.publication.title, style: AppTextStyles.cardTitle),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.publication.publisher, style: AppTextStyles.body),
            Text(widget.publication.date, style: AppTextStyles.label.copyWith(fontSize: 11)),
          ],
        ),
      ],
    );
  }
}
