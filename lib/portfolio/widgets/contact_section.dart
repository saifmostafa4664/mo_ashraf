import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/profile_model.dart';
import 'package:mo_ashraf/portfolio/widgets/scroll_animator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactSection extends StatelessWidget {
  final ProfileModel profile;

  const ContactSection({super.key, required this.profile});

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
          ScrollAnimator(
            child: isWide ? _buildWideLayout(context) : _buildNarrowLayout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text('GET IN TOUCH', style: AppTextStyles.label),
        const SizedBox(height: 16),
        Text('CONTACT', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 8),
        Container(width: 60, height: 3, color: AppColors.crimson),
      ],
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildContactInfo()),
        const SizedBox(width: 60),
        Expanded(child: _buildSocialAndCV(context)),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      children: [
        _buildContactInfo(),
        const SizedBox(height: 48),
        _buildSocialAndCV(context),
      ],
    );
  }

  Widget _buildContactInfo() {
    final items = [
      {'icon': Icons.email_outlined, 'label': 'EMAIL', 'value': profile.email},
      {'icon': Icons.phone_outlined, 'label': 'PHONE', 'value': profile.phone},
      {'icon': Icons.location_on_outlined, 'label': 'LOCATION', 'value': profile.location},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .where((item) => (item['value'] as String).isNotEmpty)
          .map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.crimson.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item['icon'] as IconData, color: AppColors.crimson, size: 22),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['label'] as String, style: AppTextStyles.label.copyWith(fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(
                    item['value'] as String,
                    style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSocialAndCV(BuildContext context) {
    return Column(
      children: [
        _buildSocialLinks(),
        const SizedBox(height: 32),
        _buildCVButton(),
      ],
    );
  }

  Widget _buildSocialLinks() {
    final socialData = <String, FaIconData>{
      'instagram': FontAwesomeIcons.instagram,
      'behance': FontAwesomeIcons.behance,
      'linkedin': FontAwesomeIcons.linkedinIn,
      'whatsapp': FontAwesomeIcons.whatsapp,
      'youtube': FontAwesomeIcons.youtube,
    };

    final activeSocials = socialData.entries.where(
      (entry) => profile.socialLinks.containsKey(entry.key) && profile.socialLinks[entry.key]!.isNotEmpty,
    );

    if (activeSocials.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Text('FOLLOW ME', style: AppTextStyles.label),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: activeSocials.map((entry) {
              return _SocialIcon(
                icon: entry.value,
                url: profile.socialLinks[entry.key]!,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCVButton() {
    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (profile.cvUrl.isNotEmpty) {
              launchUrl(Uri.parse(profile.cvUrl));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.bloodRed, AppColors.crimson],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.crimson.withValues(alpha: 0.3),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.download_rounded, color: AppColors.textPrimary, size: 22),
                const SizedBox(width: 12),
                Text(
                  'DOWNLOAD CV',
                  style: AppTextStyles.buttonText.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final FaIconData icon;
  final String url;

  const _SocialIcon({required this.icon, required this.url});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.crimson : AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? AppColors.crimson : AppColors.divider,
            ),
            boxShadow: _isHovered
                ? [BoxShadow(color: AppColors.crimson.withValues(alpha: 0.3), blurRadius: 16)]
                : [],
          ),
          child: Center(
            child: FaIcon(
              widget.icon,
              color: _isHovered ? AppColors.textPrimary : AppColors.textSecondary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
