class SkillModel {
  final String id;
  final String name;
  final int level;
  final String category;
  final String icon;
  final int order;

  SkillModel({
    this.id = '',
    this.name = '',
    this.level = 0,
    this.category = '',
    this.icon = '',
    this.order = 0,
  });

  factory SkillModel.fromMap(Map<String, dynamic> map, String id) {
    return SkillModel(
      id: id,
      name: map['name'] ?? '',
      level: map['level'] ?? 0,
      category: map['category'] ?? '',
      icon: map['icon'] ?? '',
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'level': level,
      'category': category,
      'icon': icon,
      'order': order,
    };
  }
}
