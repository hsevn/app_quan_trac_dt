class Area {
  final String id;
  final String name;
  final int level;
  final String? parentId;

  Area({
    required this.id,
    required this.name,
    required this.level,
    this.parentId,
  });

  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      id: map['id'],
      name: map['name'],
      level: map['level'],
      parentId: map['parent_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'parent_id': parentId,
    };
  }
}
