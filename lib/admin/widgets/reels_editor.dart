import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/reel_model.dart';
import 'package:mo_ashraf/services/firestore_service.dart';

class ReelsEditor extends StatefulWidget {
  const ReelsEditor({super.key});

  @override
  State<ReelsEditor> createState() => _ReelsEditorState();
}

class _ReelsEditorState extends State<ReelsEditor> {
  final _firestore = FirestoreService();

  String _detectPlatform(String url) {
    if (url.contains('instagram.com')) return 'instagram';
    if (url.contains('youtube.com') || url.contains('youtu.be')) return 'youtube';
    if (url.contains('tiktok.com')) return 'tiktok';
    return 'instagram';
  }

  void _showForm({ReelModel? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final urlCtrl = TextEditingController(text: existing?.reelUrl ?? '');
    final categoryCtrl = TextEditingController(text: existing?.category ?? '');
    final dateCtrl = TextEditingController(text: existing?.date ?? '');
    final orderCtrl = TextEditingController(text: existing?.order.toString() ?? '0');
    String platform = existing?.platform ?? 'instagram';

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
                  Text(existing != null ? 'EDIT REEL' : 'ADD REEL', style: AppTextStyles.cardTitle),
                  const SizedBox(height: 24),
                  _field('Title', titleCtrl),
                  _field('Description', descCtrl, maxLines: 2),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: urlCtrl,
                      style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'Reel URL'),
                      onChanged: (val) {
                        final detected = _detectPlatform(val);
                        if (detected != platform) {
                          setDialogState(() => platform = detected);
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.bgSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text('Platform: ', style: AppTextStyles.body),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.crimson.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            platform.toUpperCase(),
                            style: AppTextStyles.label.copyWith(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _field('Category', categoryCtrl),
                  Row(
                    children: [
                      Expanded(child: _field('Date', dateCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _field('Order', orderCtrl)),
                    ],
                  ),
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
                              'description': descCtrl.text,
                              'reelUrl': urlCtrl.text,
                              'platform': platform,
                              'category': categoryCtrl.text,
                              'thumbnailUrl': existing?.thumbnailUrl ?? '',
                              'date': dateCtrl.text,
                              'order': int.tryParse(orderCtrl.text) ?? 0,
                            };
                            if (existing != null) {
                              await _firestore.updateReel(existing.id, data);
                            } else {
                              await _firestore.addReel(data);
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
              Text('REELS & TUTORIALS', style: AppTextStyles.cardTitle),
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
          child: StreamBuilder<List<ReelModel>>(
            stream: _firestore.getReels(),
            builder: (context, snap) {
              final items = snap.data ?? [];
              if (items.isEmpty) return Center(child: Text('No reels yet', style: AppTextStyles.body));
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final reel = items[index];
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
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.crimson.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            reel.platform == 'youtube' ? Icons.play_circle_outline :
                            reel.platform == 'tiktok' ? Icons.music_note_outlined :
                            Icons.camera_alt_outlined,
                            color: AppColors.crimson,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reel.title, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Text(
                                '${reel.platform.toUpperCase()}  |  ${reel.category}',
                                style: AppTextStyles.label.copyWith(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showForm(existing: reel),
                          icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 20),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.surface,
                                title: Text('Delete Reel', style: AppTextStyles.cardTitle),
                                content: Text('Are you sure?', style: AppTextStyles.body),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: AppTextStyles.body)),
                                  ElevatedButton(
                                    onPressed: () { _firestore.deleteReel(reel.id); Navigator.pop(ctx); },
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
