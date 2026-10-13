import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mo_ashraf/models/profile_model.dart';

class Footer extends StatelessWidget {
  final ProfileModel profile;

  const Footer({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 40),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: isWide ? _buildWideFooter() : _buildNarrowFooter(),
    );
  }

  Widget _buildWideFooter() {
    return Row(
      children: [
        _buildLogo(),
        const Spacer(),
        _buildSocialRow(),
        const Spacer(),
        _buildCopyright(),
      ],
    );
  }

  Widget _buildNarrowFooter() {
    return Column(
      children: [
        _buildLogo(),
        const SizedBox(height: 20),
        _buildSocialRow(),
        const SizedBox(height: 20),
        _buildCopyright(),
      ],
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.crimson, width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              'MA',
              style: AppTextStyles.label.copyWith(
                fontSize: 10,
                color: AppColors.crimson,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'TEAM',
          style: AppTextStyles.cardTitle.copyWith(
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialRow() {
    final links = profile.socialLinks;
    final items = <Widget>[];

    void addIcon(String key, IconData iconData) {
      if (links.containsKey(key) && links[key]!.isNotEmpty) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () => launchUrl(Uri.parse(links[key]!)),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: FaIcon(iconData, color: AppColors.textSecondary, size: 16),
              ),
            ),
          ),
        );
      }
    }

    addIcon('instagram', FontAwesomeIcons.instagram);
    addIcon('behance', FontAwesomeIcons.behance);
    addIcon('linkedin', FontAwesomeIcons.linkedinIn);
    addIcon('whatsapp', FontAwesomeIcons.whatsapp);

    return Row(mainAxisSize: MainAxisSize.min, children: items);
  }

  Widget _buildCopyright() {
    return Text(
      '${DateTime.now().year}  MA TEAM. All rights reserved.',
      style: AppTextStyles.body.copyWith(
        fontSize: 12,
        color: AppColors.textSecondary.withValues(alpha: 0.6),
      ),
    );
  }
}
