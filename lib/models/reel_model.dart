class ReelModel {
  final String id;
  final String title;
  final String description;
  final String reelUrl;
  final String platform;
  final String category;
  final String thumbnailUrl;
  final String date;
  final int order;

  ReelModel({
    this.id = '',
    this.title = '',
    this.description = '',
    this.reelUrl = '',
    this.platform = 'instagram',
    this.category = '',
    this.thumbnailUrl = '',
    this.date = '',
    this.order = 0,
  });

  factory ReelModel.fromMap(Map<String, dynamic> map, String id) {
    return ReelModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      reelUrl: map['reelUrl'] ?? '',
      platform: map['platform'] ?? 'instagram',
      category: map['category'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      date: map['date'] ?? '',
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'reelUrl': reelUrl,
      'platform': platform,
      'category': category,
      'thumbnailUrl': thumbnailUrl,
      'date': date,
      'order': order,
    };
  }

  String get embedUrl {
    if (platform == 'instagram') {
      final uri = Uri.parse(reelUrl);
      return 'https://www.instagram.com${uri.path}embed/';
    } else if (platform == 'youtube') {
      final uri = Uri.parse(reelUrl);
      String? videoId;
      if (uri.host.contains('youtu.be')) {
        videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
      } else {
        videoId = uri.queryParameters['v'] ?? '';
        if (videoId.isEmpty && uri.pathSegments.contains('shorts')) {
          final idx = uri.pathSegments.indexOf('shorts');
          if (idx + 1 < uri.pathSegments.length) {
            videoId = uri.pathSegments[idx + 1];
          }
        }
      }
      return 'https://www.youtube.com/embed/$videoId';
    } else if (platform == 'tiktok') {
      return reelUrl;
    }
    return reelUrl;
  }
}
