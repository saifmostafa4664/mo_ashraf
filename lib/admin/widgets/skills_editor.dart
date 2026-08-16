import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/skill_model.dart';
import 'package:mo_ashraf/services/firestore_service.dart';

class SkillsEditor extends StatefulWidget {
  const SkillsEditor({super.key});

  @override
  State<SkillsEditor> createState() => _SkillsEditorState();
}

class _SkillsEditorState extends State<SkillsEditor> {
  final _firestore = FirestoreService();

  void _showForm({SkillModel? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final levelCtrl = TextEditingController(text: existing?.level.toString() ?? '80');
    final categoryCtrl = TextEditingController(text: existing?.category ?? '');
    final iconCtrl = TextEditingController(text: existing?.icon ?? '');
    final orderCtrl = TextEditingController(text: existing?.order.toString() ?? '0');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(existing != null ? 'EDIT SKILL' : 'ADD SKILL', style: AppTextStyles.cardTitle),
                const SizedBox(height: 24),
                _field('Skill Name', nameCtrl),
                _field('Level (0-100)', levelCtrl),
                _field('Category', categoryCtrl),
                _field('Icon Name', iconCtrl),
                _field('Order', orderCtrl),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('CANCEL', style: AppTextStyles.buttonText),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final data = {
                            'name': nameCtrl.text,
                            'level': int.tryParse(levelCtrl.text) ?? 80,
                            'category': categoryCtrl.text,
                            'icon': iconCtrl.text,
                            'order': int.tryParse(orderCtrl.text) ?? 0,
                          };
                          if (existing != null) {
                            await _firestore.updateSkill(existing.id, data);
                          } else {
                            await _firestore.addSkill(data);
                          }
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                        child: Text('SAVE', style: AppTextStyles.buttonText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              Text('SKILLS', style: AppTextStyles.cardTitle),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showForm(),
                icon: const Icon(Icons.add, size: 18),
                label: Text('ADD', style: AppTextStyles.buttonText),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<SkillModel>>(
            stream: _firestore.getSkills(),
            builder: (context, snap) {
              final items = snap.data ?? [];
              if (items.isEmpty) return Center(child: Text('No skills yet', style: AppTextStyles.body));
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final skill = items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(skill.name, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(skill.category, style: AppTextStyles.label.copyWith(fontSize: 10)),
                                  const SizedBox(width: 12),
                                  Text('${skill.level}%', style: AppTextStyles.body.copyWith(fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showForm(existing: skill),
                          icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 20),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.surface,
                                title: Text('Delete Skill', style: AppTextStyles.cardTitle),
                                content: Text('Are you sure?', style: AppTextStyles.body),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: AppTextStyles.body)),
                                  ElevatedButton(
                                    onPressed: () { _firestore.deleteSkill(skill.id); Navigator.pop(ctx); },
                                    child: Text('Delete', style: AppTextStyles.buttonText),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_outline, color: AppColors.crimson, size: 20),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
