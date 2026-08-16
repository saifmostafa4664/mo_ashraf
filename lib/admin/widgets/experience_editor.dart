import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/experience_model.dart';
import 'package:mo_ashraf/services/firestore_service.dart';

class ExperienceEditor extends StatefulWidget {
  const ExperienceEditor({super.key});

  @override
  State<ExperienceEditor> createState() => _ExperienceEditorState();
}

class _ExperienceEditorState extends State<ExperienceEditor> {
  final _firestore = FirestoreService();

  void _showForm({ExperienceModel? existing}) {
    final companyCtrl = TextEditingController(text: existing?.company ?? '');
    final roleCtrl = TextEditingController(text: existing?.role ?? '');
    final startCtrl = TextEditingController(text: existing?.startDate ?? '');
    final endCtrl = TextEditingController(text: existing?.endDate ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final orderCtrl = TextEditingController(text: existing?.order.toString() ?? '0');
    bool isCurrent = existing?.isCurrent ?? false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    existing != null ? 'EDIT EXPERIENCE' : 'ADD EXPERIENCE',
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: 24),
                  _field('Company', companyCtrl),
                  _field('Role', roleCtrl),
                  Row(
                    children: [
                      Expanded(child: _field('Start Date', startCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _field('End Date', endCtrl)),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isCurrent,
                        onChanged: (v) => setDialogState(() => isCurrent = v!),
                        activeColor: AppColors.crimson,
                      ),
                      Text('Currently Working', style: AppTextStyles.body),
                    ],
                  ),
                  _field('Description', descCtrl, maxLines: 3),
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
                              'company': companyCtrl.text,
                              'role': roleCtrl.text,
                              'startDate': startCtrl.text,
                              'endDate': endCtrl.text,
                              'isCurrent': isCurrent,
                              'description': descCtrl.text,
                              'order': int.tryParse(orderCtrl.text) ?? 0,
                            };
                            if (existing != null) {
                              await _firestore.updateExperience(existing.id, data);
                            } else {
                              await _firestore.addExperience(data);
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
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
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
              Text('EXPERIENCES', style: AppTextStyles.cardTitle),
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
          child: StreamBuilder<List<ExperienceModel>>(
            stream: _firestore.getExperiences(),
            builder: (context, snap) {
              final items = snap.data ?? [];
              if (items.isEmpty) {
                return Center(
                  child: Text('No experiences yet', style: AppTextStyles.body),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final exp = items[index];
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
                              Text(exp.role, style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
                              const SizedBox(height: 4),
                              Text(
                                '${exp.company}  |  ${exp.startDate} - ${exp.isCurrent ? "Present" : exp.endDate}',
                                style: AppTextStyles.body.copyWith(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showForm(existing: exp),
                          icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 20),
                        ),
                        IconButton(
                          onPressed: () => _confirmDelete(exp.id),
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

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Delete Experience', style: AppTextStyles.cardTitle),
        content: Text('Are you sure?', style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTextStyles.body),
          ),
          ElevatedButton(
            onPressed: () {
              _firestore.deleteExperience(id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.crimson),
            child: Text('Delete', style: AppTextStyles.buttonText),
          ),
        ],
      ),
    );
  }
}
