import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/data/dummy_data.dart';
import 'package:mo_ashraf/models/profile_model.dart';
import 'package:mo_ashraf/models/experience_model.dart';
import 'package:mo_ashraf/models/project_model.dart';
import 'package:mo_ashraf/models/skill_model.dart';
import 'package:mo_ashraf/models/publication_model.dart';
import 'package:mo_ashraf/models/reel_model.dart';
import 'package:mo_ashraf/services/firestore_service.dart';
import 'package:mo_ashraf/portfolio/widgets/hero_section.dart';
import 'package:mo_ashraf/portfolio/widgets/about_section.dart';
import 'package:mo_ashraf/portfolio/widgets/experience_section.dart';
import 'package:mo_ashraf/portfolio/widgets/projects_section.dart';
import 'package:mo_ashraf/portfolio/widgets/skills_section.dart';
import 'package:mo_ashraf/portfolio/widgets/reels_section.dart';
import 'package:mo_ashraf/portfolio/widgets/studio_section.dart';
import 'package:mo_ashraf/portfolio/widgets/publications_section.dart';
import 'package:mo_ashraf/portfolio/widgets/contact_section.dart';
import 'package:mo_ashraf/portfolio/widgets/nav_bar.dart';
import 'package:mo_ashraf/portfolio/widgets/footer.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  final FirestoreService _firestoreService = FirestoreService();

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _reelsKey = GlobalKey();
  final GlobalKey _studioKey = GlobalKey();
  final GlobalKey _publicationsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  List<GlobalKey> get _sectionKeys => [
        _heroKey,
        _projectsKey,
        _aboutKey,
        _experienceKey,
        _skillsKey,
        _reelsKey,
        _studioKey,
        _publicationsKey,
        _contactKey,
      ];

  List<String> get _sectionLabels => [
        'Home',
        'Portfolio',
        'About',
        'Experience',
        'Skills',
        'Reels',
        'Studio',
        'Publications',
        'Contact',
      ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: StreamBuilder<ProfileModel>(
        stream: _firestoreService.getProfile(),
        builder: (context, profileSnap) {
          final loadedProfile = profileSnap.data ?? ProfileModel();
          final profile =
              loadedProfile.name.isEmpty ? DummyData.profile : loadedProfile;

          return Stack(
            children: [
              const Positioned.fill(child: _PortfolioBackdrop()),
              _buildScrollContent(profile),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: NavBar(
                  scrollController: _scrollController,
                  sectionKeys: _sectionKeys,
                  sectionLabels: _sectionLabels,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScrollContent(ProfileModel profile) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Container(
            key: _heroKey,
            child: HeroSection(
              profile: profile,
              onViewPortfolio: () => _scrollToSection(_projectsKey),
            ),
          ),
          StreamBuilder<List<ProjectModel>>(
            stream: _firestoreService.getProjects(),
            builder: (context, snap) {
              final projects =
                  (snap.data ?? []).isEmpty ? DummyData.projects : snap.data!;
              return Container(
                key: _projectsKey,
                child: ProjectsSection(projects: projects),
              );
            },
          ),
          Container(
            key: _aboutKey,
            child: AboutSection(profile: profile),
          ),
          StreamBuilder<List<ExperienceModel>>(
            stream: _firestoreService.getExperiences(),
            builder: (context, snap) {
              final experiences = (snap.data ?? []).isEmpty
                  ? DummyData.experiences
                  : snap.data!;
              return Container(
                key: _experienceKey,
                child: ExperienceSection(experiences: experiences),
              );
            },
          ),
          StreamBuilder<List<SkillModel>>(
            stream: _firestoreService.getSkills(),
            builder: (context, snap) {
              final skills =
                  (snap.data ?? []).isEmpty ? DummyData.skills : snap.data!;
              return Container(
                key: _skillsKey,
                child: SkillsSection(skills: skills),
              );
            },
          ),
          StreamBuilder<List<ReelModel>>(
            stream: _firestoreService.getReels(),
            builder: (context, snap) {
              final reels = snap.data ?? [];
              if (reels.isEmpty) return const SizedBox.shrink();
              return Container(
                key: _reelsKey,
                child: ReelsSection(reels: reels),
              );
            },
          ),
          Container(
            key: _studioKey,
            child: StudioSection(profile: profile),
          ),
          StreamBuilder<List<PublicationModel>>(
            stream: _firestoreService.getPublications(),
            builder: (context, snap) {
              final publications = snap.data ?? [];
              if (publications.isEmpty) return const SizedBox.shrink();
              return Container(
                key: _publicationsKey,
                child: PublicationsSection(publications: publications),
              );
            },
          ),
          Container(
            key: _contactKey,
            child: ContactSection(profile: profile),
          ),
          Footer(profile: profile),
        ],
      ),
    );
  }

  void _scrollToSection(GlobalKey key) {
    if (key.currentContext == null) return;
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeInOutCubic,
    );
  }
}

class _PortfolioBackdrop extends StatelessWidget {
  const _PortfolioBackdrop();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.9),
            radius: 1.2,
            colors: [Color(0x553A1E8A), AppColors.bgPrimary],
          ),
        ),
        child: CustomPaint(painter: _NoiseLinesPainter()),
      ),
    );
  }
}

class _NoiseLinesPainter extends CustomPainter {
  const _NoiseLinesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary.withValues(alpha: 0.025)
      ..strokeWidth = 1;

    const gap = 92.0;
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoiseLinesPainter oldDelegate) => false;
}
