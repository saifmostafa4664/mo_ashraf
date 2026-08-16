class ExperienceModel {
  final String id;
  final String company;
  final String role;
  final String startDate;
  final String endDate;
  final bool isCurrent;
  final String description;
  final int order;

  ExperienceModel({
    this.id = '',
    this.company = '',
    this.role = '',
    this.startDate = '',
    this.endDate = '',
    this.isCurrent = false,
    this.description = '',
    this.order = 0,
  });

  factory ExperienceModel.fromMap(Map<String, dynamic> map, String id) {
    return ExperienceModel(
      id: id,
      company: map['company'] ?? '',
      role: map['role'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      isCurrent: map['isCurrent'] ?? false,
      description: map['description'] ?? '',
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'role': role,
      'startDate': startDate,
      'endDate': endDate,
      'isCurrent': isCurrent,
      'description': description,
      'order': order,
    };
  }
}
