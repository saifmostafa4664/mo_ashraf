import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onLogout;
  final VoidCallback onSeedData;
  final bool isSeeding;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
    required this.onSeedData,
    required this.isSeeding,
  });

  static const List<_SidebarItem> _items = [
    _SidebarItem(Icons.person_outline, 'Profile'),
    _SidebarItem(Icons.work_outline, 'Experience'),
    _SidebarItem(Icons.photo_library_outlined, 'Projects'),
    _SidebarItem(Icons.bar_chart_outlined, 'Skills'),
    _SidebarItem(Icons.play_circle_outline, 'Reels'),
    _SidebarItem(Icons.article_outlined, 'Publications'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(color: AppColors.divider, height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isActive = selectedIndex == index;
                return _buildMenuItem(
                  item,
                  isActive,
                  () => onItemSelected(index),
                );
              },
            ),
          ),
          const Divider(color: AppColors.divider, height: 1),
          _buildSeedButton(),
          const Divider(color: AppColors.divider, height: 1),
          _buildLogout(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.crimson, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'MA',
                style: AppTextStyles.label.copyWith(
                  fontSize: 12,
                  color: AppColors.crimson,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MA TEAM',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
              ),
              Text(
                'ADMIN',
                style: AppTextStyles.label.copyWith(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(_SidebarItem item, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.crimson.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: isActive ? AppColors.crimson : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: isActive ? AppColors.crimson : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              item.label.toUpperCase(),
              style: AppTextStyles.navLink.copyWith(
                color: isActive ? AppColors.crimson : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 2,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogout() {
    return InkWell(
      onTap: onLogout,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            const Icon(Icons.logout, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Text(
              'LOGOUT',
              style: AppTextStyles.navLink.copyWith(
                letterSpacing: 2,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeedButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: isSeeding ? null : onSeedData,
          icon: isSeeding
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.cloud_upload_outlined, size: 18),
          label: Text(
            isSeeding ? 'SYNCING' : 'SEED FIREBASE',
            style: AppTextStyles.buttonText.copyWith(fontSize: 11),
          ),
        ),
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final String label;

  const _SidebarItem(this.icon, this.label);
}
