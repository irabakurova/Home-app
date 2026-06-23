/// Recipe domain entity.
/// [category] and [cuisine] are stored as value slugs (e.g. 'hot_dish', 'russian')
/// that match the [CategoriesTable.value] column, supporting both system and
/// custom user-defined categories without schema changes.
class Recipe {
  const Recipe({
    required this.id,
    required this.familyId,
    required this.title,
    this.description,
    this.photoUrl,
    required this.category,
    required this.cuisine,
    required this.cookTimeMinutes,
    required this.defaultServings,
    required this.instructions,
    required this.isFavorite,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String familyId;
  final String title;
  final String? description;
  final String? photoUrl;

  /// Value slug — matches CategoriesTable.value for type='recipe'
  final String category;

  /// Value slug — matches CategoriesTable.value for type='cuisine'
  final String cuisine;

  final int cookTimeMinutes;
  final int defaultServings;
  final List<String> instructions;
  final bool isFavorite;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipe copyWith({
    String? id,
    String? familyId,
    String? title,
    Object? description = _sentinel,
    Object? photoUrl = _sentinel,
    String? category,
    String? cuisine,
    int? cookTimeMinutes,
    int? defaultServings,
    List<String>? instructions,
    bool? isFavorite,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      description:
          description == _sentinel ? this.description : description as String?,
      photoUrl: photoUrl == _sentinel ? this.photoUrl : photoUrl as String?,
      category: category ?? this.category,
      cuisine: cuisine ?? this.cuisine,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      defaultServings: defaultServings ?? this.defaultServings,
      instructions: instructions ?? this.instructions,
      isFavorite: isFavorite ?? this.isFavorite,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Recipe && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

// Sentinel object for nullable copyWith fields
const _sentinel = Object();
