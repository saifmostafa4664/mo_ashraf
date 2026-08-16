class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> imageUrls;
  final String beforeImageUrl;
  final String afterImageUrl;
  final String client;
  final String date;
  final bool isFeatured;
  final int order;

  ProjectModel({
    this.id = '',
    this.title = '',
    this.description = '',
    this.category = '',
    this.imageUrls = const [],
    this.beforeImageUrl = '',
    this.afterImageUrl = '',
    this.client = '',
    this.date = '',
    this.isFeatured = false,
    this.order = 0,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map, String id) {
    return ProjectModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      beforeImageUrl: map['beforeImageUrl'] ?? '',
      afterImageUrl: map['afterImageUrl'] ?? '',
      client: map['client'] ?? '',
      date: map['date'] ?? '',
      isFeatured: map['isFeatured'] ?? false,
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'imageUrls': imageUrls,
      'beforeImageUrl': beforeImageUrl,
      'afterImageUrl': afterImageUrl,
      'client': client,
      'date': date,
      'isFeatured': isFeatured,
      'order': order,
    };
  }
}
