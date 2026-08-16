class PublicationModel {
  final String id;
  final String title;
  final String publisher;
  final String date;
  final String link;
  final String imageUrl;
  final int order;

  PublicationModel({
    this.id = '',
    this.title = '',
    this.publisher = '',
    this.date = '',
    this.link = '',
    this.imageUrl = '',
    this.order = 0,
  });

  factory PublicationModel.fromMap(Map<String, dynamic> map, String id) {
    return PublicationModel(
      id: id,
      title: map['title'] ?? '',
      publisher: map['publisher'] ?? '',
      date: map['date'] ?? '',
      link: map['link'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'publisher': publisher,
      'date': date,
      'link': link,
      'imageUrl': imageUrl,
      'order': order,
    };
  }
}
