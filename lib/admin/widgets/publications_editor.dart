import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/publication_model.dart';
import 'package:mo_ashraf/services/firestore_service.dart';

class PublicationsEditor extends StatefulWidget {
  const PublicationsEditor({super.key});

  @override
  State<PublicationsEditor> createState() => _PublicationsEditorState();
}

class _PublicationsEditorState extends State<PublicationsEditor> {
  final _firestore = FirestoreService();

  void _showForm({PublicationModel? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final publisherCtrl = TextEditingController(text: existing?.publisher ?? '');
    final dateCtrl = TextEditingController(text: existing?.date ?? '');
    final linkCtrl = TextEditingController(text: existing?.link ?? '');
    final imageUrlCtrl = TextEditingController(text: existing?.imageUrl ?? '');
    final orderCtrl = TextEditingController(text: existing?.order.toString() ?? '0');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
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
                Text(existing != null ? 'EDIT PUBLICATION' : 'ADD PUBLICATION', style: AppTextStyles.cardTitle),
                const SizedBox(height: 24),
                _field('Title', titleCtrl),
                _field('Publisher', publisherCtrl),
                Row(
                  children: [
                    Expanded(child: _field('Date', dateCtrl)),
                    const SizedBox(width: 12),
                    Expanded(child: _field('Order', orderCtrl)),
                  ],
                ),
                _field('Link URL', linkCtrl),
                _field('Image URL', imageUrlCtrl),
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
                            'title': titleCtrl.text,
                            'publisher': publisherCtrl.text,
                            'date': dateCtrl.text,
                            'link': linkCtrl.text,
                            'imageUrl': imageUrlCtrl.text,
                            'order': int.tryParse(orderCtrl.text) ?? 0,
                          };
                          if (existing != null) {
                            await _firestore.updatePublication(existing.id, data);
                          } else {
                            await _firestore.addPublication(data);
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
              Text('PUBLICATIONS', style: AppTextStyles.cardTitle),
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
          child: StreamBuilder<List<PublicationModel>>(
            stream: _firestore.getPublications(),
            builder: (context, snap) {
              final items = snap.data ?? [];
              if (items.isEmpty) return Center(child: Text('No publications yet', style: AppTextStyles.body));
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final pub = items[index];
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
                              Text(pub.title, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Text('${pub.publisher}  |  ${pub.date}', style: AppTextStyles.label.copyWith(fontSize: 10)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showForm(existing: pub),
                          icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 20),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.surface,
                                title: Text('Delete Publication', style: AppTextStyles.cardTitle),
                                content: Text('Are you sure?', style: AppTextStyles.body),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: AppTextStyles.body)),
                                  ElevatedButton(
                                    onPressed: () { _firestore.deletePublication(pub.id); Navigator.pop(ctx); },
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
