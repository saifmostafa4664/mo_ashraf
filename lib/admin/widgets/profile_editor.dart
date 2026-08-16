import 'package:flutter/material.dart';
import 'package:mo_ashraf/config/app_theme.dart';
import 'package:mo_ashraf/models/profile_model.dart';
import 'package:mo_ashraf/services/firestore_service.dart';
import 'package:mo_ashraf/services/storage_service.dart';
import 'package:mo_ashraf/admin/widgets/image_upload_widget.dart';

class ProfileEditor extends StatefulWidget {
  const ProfileEditor({super.key});

  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  final _firestore = FirestoreService();
  final _storage = StorageService();
  final _nameController = TextEditingController();
  final _brandNameController = TextEditingController();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _taglineController = TextEditingController();
  final _summaryController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _instagramController = TextEditingController();
  final _behanceController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _projectsCountController = TextEditingController();
  final _yearsController = TextEditingController();
  final _clientsCountController = TextEditingController();
  String _photoUrl = '';
  String _logoUrl = '';
  String _studioPhotoUrl = '';
  String _cvUrl = '';
  bool _isSaving = false;
  bool _loaded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _brandNameController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _taglineController.dispose();
    _summaryController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _instagramController.dispose();
    _behanceController.dispose();
    _linkedinController.dispose();
    _whatsappController.dispose();
    _youtubeController.dispose();
    _projectsCountController.dispose();
    _yearsController.dispose();
    _clientsCountController.dispose();
    super.dispose();
  }

  void _loadProfile(ProfileModel profile) {
    if (_loaded) return;
    _loaded = true;
    _nameController.text = profile.name;
    _brandNameController.text = profile.brandName;
    _titleController.text = profile.title;
    _subtitleController.text = profile.subtitle;
    _taglineController.text = profile.tagline;
    _summaryController.text = profile.summary;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _locationController.text = profile.location;
    _instagramController.text = profile.socialLinks['instagram'] ?? '';
    _behanceController.text = profile.socialLinks['behance'] ?? '';
    _linkedinController.text = profile.socialLinks['linkedin'] ?? '';
    _whatsappController.text = profile.socialLinks['whatsapp'] ?? '';
    _youtubeController.text = profile.socialLinks['youtube'] ?? '';
    _projectsCountController.text = profile.stats['projectsCount'] ?? '';
    _yearsController.text = profile.stats['yearsExperience'] ?? '';
    _clientsCountController.text = profile.stats['clientsCount'] ?? '';
    _photoUrl = profile.photoUrl;
    _logoUrl = profile.logoUrl;
    _studioPhotoUrl = profile.studioPhotoUrl;
    _cvUrl = profile.cvUrl;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await _firestore.updateProfile({
        'name': _nameController.text,
        'brandName': _brandNameController.text,
        'title': _titleController.text,
        'subtitle': _subtitleController.text,
        'tagline': _taglineController.text,
        'summary': _summaryController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'location': _locationController.text,
        'photoUrl': _photoUrl,
        'logoUrl': _logoUrl,
        'studioPhotoUrl': _studioPhotoUrl,
        'cvUrl': _cvUrl,
        'socialLinks': {
          'instagram': _instagramController.text,
          'behance': _behanceController.text,
          'linkedin': _linkedinController.text,
          'whatsapp': _whatsappController.text,
          'youtube': _youtubeController.text,
        },
        'stats': {
          'projectsCount': _projectsCountController.text,
          'yearsExperience': _yearsController.text,
          'clientsCount': _clientsCountController.text,
        },
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved'), backgroundColor: AppColors.crimson),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.crimson),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProfileModel>(
      stream: _firestore.getProfile(),
      builder: (context, snap) {
        if (snap.hasData) _loadProfile(snap.data!);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Profile Information'),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ImageUploadWidget(
                          label: 'Profile Photo',
                          currentUrl: _photoUrl,
                          onUpload: (data, ext) => _storage.uploadProfilePhoto(data, ext),
                          onUploaded: (url) => setState(() => _photoUrl = url),
                        ),
                        const SizedBox(height: 16),
                        ImageUploadWidget(
                          label: 'Logo',
                          currentUrl: _logoUrl,
                          onUpload: (data, ext) => _storage.uploadLogo(data, ext),
                          onUploaded: (url) => setState(() => _logoUrl = url),
                        ),
                        const SizedBox(height: 16),
                        ImageUploadWidget(
                          label: 'Studio Photo',
                          currentUrl: _studioPhotoUrl,
                          onUpload: (data, ext) => _storage.uploadStudioPhoto(data, ext),
                          onUploaded: (url) => setState(() => _studioPhotoUrl = url),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildField('Name', _nameController),
                        _buildField('Brand Name', _brandNameController),
                        _buildField('Title', _titleController),
                        _buildField('Subtitle', _subtitleController),
                        _buildField('Tagline', _taglineController),
                        _buildField('Summary', _summaryController, maxLines: 5),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildSectionHeader('Contact Information'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildField('Email', _emailController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildField('Phone', _phoneController)),
                ],
              ),
              _buildField('Location', _locationController),
              const SizedBox(height: 40),
              _buildSectionHeader('Social Links'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildField('Instagram', _instagramController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildField('Behance', _behanceController)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildField('LinkedIn', _linkedinController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildField('WhatsApp', _whatsappController)),
                ],
              ),
              _buildField('YouTube', _youtubeController),
              const SizedBox(height: 40),
              _buildSectionHeader('Stats'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildField('Projects Count', _projectsCountController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildField('Years Experience', _yearsController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildField('Clients Count', _clientsCountController)),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary),
                        )
                      : Text('SAVE PROFILE', style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: AppTextStyles.cardTitle),
        const SizedBox(height: 4),
        Container(width: 40, height: 2, color: AppColors.crimson),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
