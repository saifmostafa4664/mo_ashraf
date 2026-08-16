class ProfileModel {
  final String name;
  final String brandName;
  final String title;
  final String subtitle;
  final String tagline;
  final String summary;
  final String photoUrl;
  final String studioPhotoUrl;
  final String logoUrl;
  final String cvUrl;
  final String email;
  final String phone;
  final String location;
  final Map<String, String> socialLinks;
  final Map<String, String> stats;

  ProfileModel({
    this.name = '',
    this.brandName = '',
    this.title = '',
    this.subtitle = '',
    this.tagline = '',
    this.summary = '',
    this.photoUrl = '',
    this.studioPhotoUrl = '',
    this.logoUrl = '',
    this.cvUrl = '',
    this.email = '',
    this.phone = '',
    this.location = '',
    this.socialLinks = const {},
    this.stats = const {},
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? '',
      brandName: map['brandName'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      tagline: map['tagline'] ?? '',
      summary: map['summary'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      studioPhotoUrl: map['studioPhotoUrl'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      cvUrl: map['cvUrl'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      socialLinks: Map<String, String>.from(map['socialLinks'] ?? {}),
      stats: Map<String, String>.from(map['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brandName': brandName,
      'title': title,
      'subtitle': subtitle,
      'tagline': tagline,
      'summary': summary,
      'photoUrl': photoUrl,
      'studioPhotoUrl': studioPhotoUrl,
      'logoUrl': logoUrl,
      'cvUrl': cvUrl,
      'email': email,
      'phone': phone,
      'location': location,
      'socialLinks': socialLinks,
      'stats': stats,
    };
  }
}
