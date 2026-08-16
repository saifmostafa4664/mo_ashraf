import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/services/auth_service.dart';
import 'package:mo_ashraf/services/firestore_service.dart';
import 'package:mo_ashraf/admin/widgets/admin_sidebar.dart';
import 'package:mo_ashraf/admin/widgets/profile_editor.dart';
import 'package:mo_ashraf/admin/widgets/experience_editor.dart';
import 'package:mo_ashraf/admin/widgets/projects_editor.dart';
import 'package:mo_ashraf/admin/widgets/skills_editor.dart';
import 'package:mo_ashraf/admin/widgets/reels_editor.dart';
import 'package:mo_ashraf/admin/widgets/publications_editor.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _authService = AuthService();
  final _firestore = FirestoreService();
  int _selectedIndex = 0;
  bool _isSeeding = false;

  final List<Widget> _pages = const [
    ProfileEditor(),
    ExperienceEditor(),
    ProjectsEditor(),
    SkillsEditor(),
    ReelsEditor(),
    PublicationsEditor(),
  ];

  @override
  void initState() {
    super.initState();
    if (_authService.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/admin/login');
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _seedData());
    }
  }

  void _handleLogout() async {
    await _authService.signOut();
    if (mounted) {
      context.go('/admin/login');
    }
  }

  Future<void> _seedData({bool overwrite = false}) async {
    if (_isSeeding) return;
    setState(() => _isSeeding = true);
    try {
      await _firestore.seedPortfolioData(overwrite: overwrite);
      if (mounted && overwrite) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Firebase data refreshed'),
            backgroundColor: AppColors.crimson,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seed failed: $e'),
            backgroundColor: AppColors.crimson,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSeeding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Row(
        children: [
          AdminSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() => _selectedIndex = index),
            onLogout: _handleLogout,
            onSeedData: () => _seedData(overwrite: true),
            isSeeding: _isSeeding,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
