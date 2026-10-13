import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/project_model.dart';
import 'package:mo_ashraf/services/firestore_service.dart';
import 'package:mo_ashraf/services/storage_service.dart';

class ProjectsEditor extends StatefulWidget {
  const ProjectsEditor({super.key});

  @override
  State<ProjectsEditor> createState() => _ProjectsEditorState();
}

class _ProjectsEditorState extends State<ProjectsEditor> {
  final _firestore = FirestoreService();
  final _storage = StorageService();

  void _showForm({ProjectModel? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final categoryCtrl = TextEditingController(text: existing?.category ?? '');
    final clientCtrl = TextEditingController(text: existing?.client ?? '');
    final dateCtrl = TextEditingController(text: existing?.date ?? '');
    final projectUrlCtrl =
        TextEditingController(text: existing?.projectUrl ?? '');
    final orderCtrl = TextEditingController(
      text: existing?.order.toString() ?? '0',
    );
    bool isFeatured = existing?.isFeatured ?? false;
    List<String> imageUrls = List.from(existing?.imageUrls ?? []);
    String beforeUrl = existing?.beforeImageUrl ?? '';
    String afterUrl = existing?.afterImageUrl ?? '';
    bool isUploading = false;
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    existing != null ? 'EDIT PROJECT' : 'ADD PROJECT',
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: 24),
                  _field('Title', titleCtrl),
                  _field('Description', descCtrl, maxLines: 3),
                  Row(
                    children: [
                      Expanded(child: _field('Category', categoryCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _field('Client', clientCtrl)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _field('Date', dateCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _field('Order', orderCtrl)),
                    ],
                  ),
                  _field('Project link (https://...)', projectUrlCtrl),
                  Row(
                    children: [
                      Checkbox(
                        value: isFeatured,
                        onChanged: (v) => setDialogState(() => isFeatured = v!),
                        activeColor: AppColors.crimson,
                      ),
                      Text('Featured', style: AppTextStyles.body),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('IMAGES', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...imageUrls.asMap().entries.map(
                            (entry) => Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(entry.value),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () => setDialogState(
                                    () => imageUrls.removeAt(entry.key),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: AppColors.crimson,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 12,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      InkWell(
                        onTap: () async {
                          if (isUploading || isSaving) return;
                          setDialogState(() => isUploading = true);
                          try {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.image,
                              withData: true,
                            );
                            if (result == null || result.files.isEmpty) return;

                            final file = result.files.first;
                            final bytes = file.bytes;
                            if (bytes == null) return;

                            final ext = (file.name.split('.').last.isNotEmpty)
                                ? file.name.split('.').last.toLowerCase()
                                : 'jpg';

                            final id = existing?.id ??
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                            final url = await _storage.uploadProjectImage(
                              id,
                              bytes,
                              ext,
                              imageUrls.length,
                            );
                            setDialogState(() => imageUrls.add(url));
                          } catch (error) {
                            if (ctx.mounted && error is! TimeoutException) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text('Image upload failed: $error'),
                                  backgroundColor: AppColors.crimson,
                                ),
                              );
                            }
                          } finally {
                            if (ctx.mounted) {
                              setDialogState(() => isUploading = false);
                            }
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.bgSecondary,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: isUploading
                              ? const CircularProgressIndicator(
                                  color: AppColors.crimson)
                              : const Icon(Icons.add,
                                  color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            'CANCEL',
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (isUploading || isSaving) return;
                            setDialogState(() => isSaving = true);
                            final data = {
                              'title': titleCtrl.text,
                              'description': descCtrl.text,
                              'category': categoryCtrl.text,
                              'client': clientCtrl.text,
                              'date': dateCtrl.text,
                              'projectUrl': projectUrlCtrl.text.trim(),
                              'order': int.tryParse(orderCtrl.text) ?? 0,
                              'isFeatured': isFeatured,
                              'imageUrls': imageUrls,
                              'beforeImageUrl': beforeUrl,
                              'afterImageUrl': afterUrl,
                            };
                            try {
                              if (existing != null) {
                                await _firestore.updateProject(
                                    existing.id, data);
                              } else {
                                await _firestore.addProject(data);
                              }
                              if (ctx.mounted) Navigator.pop(ctx);
                            } catch (error) {
                              if (ctx.mounted) {
                                setDialogState(() => isSaving = false);
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(
                                      content: Text('Save failed: $error')),
                                );
                              }
                            }
                          },
                          child: isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text('SAVE', style: AppTextStyles.buttonText),
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
              Text('PROJECTS', style: AppTextStyles.cardTitle),
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
          child: StreamBuilder<List<ProjectModel>>(
            stream: _firestore.getProjects(),
            builder: (context, snap) {
              final items = snap.data ?? [];
              if (items.isEmpty) {
                return Center(
                  child: Text('No projects yet', style: AppTextStyles.body),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final proj = items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        if (proj.imageUrls.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              proj.imageUrls.first,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                proj.title,
                                style: AppTextStyles.cardTitle.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${proj.category}  |  ${proj.client}',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (proj.isFeatured)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppColors.crimson.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'FEATURED',
                              style: AppTextStyles.label.copyWith(fontSize: 9),
                            ),
                          ),
                        IconButton(
                          onPressed: () => _showForm(existing: proj),
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _confirmDelete(proj.id),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.crimson,
                            size: 20,
                          ),
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
        title: Text('Delete Project', style: AppTextStyles.cardTitle),
        content: Text('Are you sure?', style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTextStyles.body),
          ),
          ElevatedButton(
            onPressed: () {
              _firestore.deleteProject(id);
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
