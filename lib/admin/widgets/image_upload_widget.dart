import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';

class ImageUploadWidget extends StatefulWidget {
  final String label;
  final String currentUrl;
  final Future<String> Function(Uint8List data, String extension) onUpload;
  final ValueChanged<String> onUploaded;

  const ImageUploadWidget({
    super.key,
    required this.label,
    this.currentUrl = '',
    required this.onUpload,
    required this.onUploaded,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  bool _isUploading = false;
  Uint8List? _previewData;

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;

    final ext = (file.name.split('.').last.isNotEmpty)
        ? file.name.split('.').last
        : 'jpg';

    setState(() {
      _isUploading = true;
      _previewData = bytes;
    });

    try {
      final url = await widget.onUpload(bytes, ext);
      widget.onUploaded(url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: AppColors.crimson,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: AppTextStyles.label.copyWith(fontSize: 11),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _isUploading ? null : _pickAndUpload,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.divider,
                style: BorderStyle.solid,
              ),
            ),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isUploading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.crimson,
          strokeWidth: 2,
        ),
      );
    }

    if (_previewData != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(_previewData!, fit: BoxFit.cover),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.bgPrimary.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit,
                  color: AppColors.crimson,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (widget.currentUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            widget.currentUrl.startsWith('assets/')
                ? Image.asset(widget.currentUrl, fit: BoxFit.cover)
                : Image.network(widget.currentUrl, fit: BoxFit.cover),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.bgPrimary.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit,
                  color: AppColors.crimson,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          size: 36,
        ),
        const SizedBox(height: 8),
        Text(
          'Click to upload',
          style: AppTextStyles.body.copyWith(fontSize: 13),
        ),
      ],
    );
  }
}
