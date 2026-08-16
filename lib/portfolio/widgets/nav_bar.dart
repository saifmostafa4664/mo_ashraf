import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mo_ashraf/config/app_theme.dart';

class NavBar extends StatefulWidget {
  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;
  final List<String> sectionLabels;

  const NavBar({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
    required this.sectionLabels,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _activeIndex = 0;
  bool _isScrolled = false;
  bool _mobileMenuOpen = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = widget.scrollController.offset;
    setState(() {
      _isScrolled = offset > 50;
    });

    for (int i = widget.sectionKeys.length - 1; i >= 0; i--) {
      final key = widget.sectionKeys[i];
      if (key.currentContext != null) {
        final box = key.currentContext!.findRenderObject() as RenderBox;
        final pos = box.localToGlobal(Offset.zero);
        if (pos.dy <= 150) {
          if (_activeIndex != i) {
            setState(() => _activeIndex = i);
          }
          break;
        }
      }
    }
  }

  void _scrollToSection(int index) {
    final key = widget.sectionKeys[index];
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
    setState(() {
      _mobileMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: isWide ? 60 : 20, vertical: 16),
      decoration: BoxDecoration(
        color: _isScrolled
            ? AppColors.bgPrimary.withValues(alpha: 0.92)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: _isScrolled ? AppColors.divider : Colors.transparent,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildLogo(),
              const Spacer(),
              if (isWide) ...[
                ..._buildDesktopLinks(),
                const SizedBox(width: 18),
                _buildAdminButton(),
              ] else
                _buildMobileMenuButton(),
            ],
          ),
          if (_mobileMenuOpen && !isWide) _buildMobileMenu(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.champagne, width: 1.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              'MA',
              style: AppTextStyles.label.copyWith(
                fontSize: 14,
                color: AppColors.champagne,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'TEAM',
          style: AppTextStyles.cardTitle.copyWith(
            fontSize: 18,
            color: AppColors.textPrimary,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDesktopLinks() {
    return widget.sectionLabels.asMap().entries.map((entry) {
      final isActive = _activeIndex == entry.key;
      return Padding(
        padding: const EdgeInsets.only(left: 32),
        child: InkWell(
          onTap: () => _scrollToSection(entry.key),
          hoverColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isActive ? AppColors.champagne : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              entry.value.toUpperCase(),
              style: AppTextStyles.navLink.copyWith(
                color: isActive ? AppColors.champagne : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildMobileMenuButton() {
    return IconButton(
      onPressed: () => setState(() => _mobileMenuOpen = !_mobileMenuOpen),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          _mobileMenuOpen ? Icons.close : Icons.menu,
          key: ValueKey(_mobileMenuOpen),
          color: AppColors.textPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildAdminButton() {
    return Tooltip(
      message: 'Admin panel',
      child: IconButton(
        onPressed: () => context.go('/admin'),
        icon: const Icon(Icons.admin_panel_settings_outlined),
        color: AppColors.textSecondary,
        hoverColor: AppColors.champagne.withValues(alpha: 0.12),
      ),
    );
  }

  Widget _buildMobileMenu() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          ...widget.sectionLabels.asMap().entries.map((entry) {
            final isActive = _activeIndex == entry.key;
            return InkWell(
              onTap: () => _scrollToSection(entry.key),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Text(
                  entry.value.toUpperCase(),
                  style: AppTextStyles.navLink.copyWith(
                    color: isActive
                        ? AppColors.champagne
                        : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    letterSpacing: 2,
                  ),
                ),
              ),
            );
          }),
          InkWell(
            onTap: () {
              setState(() => _mobileMenuOpen = false);
              context.go('/admin');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: AppColors.champagne,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'ADMIN PANEL',
                    style: AppTextStyles.navLink.copyWith(
                      color: AppColors.champagne,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
