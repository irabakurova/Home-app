import 'package:flutter/foundation.dart';

/// Domain entity for a user-manageable category.
/// Mirrors the [CategoriesTable] row but is decoupled from Drift.
@immutable
class AppCategory {
  const AppCategory({
    required this.id,
    required this.familyId,
    required this.type,
    required this.name,
    required this.value,
    required this.isSystem,
    required this.sortOrder,
    required this.createdAt,
  });

  final String id;
  final String familyId;

  /// 'recipe' | 'cuisine' | 'pantry'
  final String type;

  /// Human-readable label shown in UI
  final String name;

  /// Slug stored in recipes.category / pantry_items.category columns
  final String value;

  final bool isSystem;
  final int sortOrder;
  final DateTime createdAt;

  AppCategory copyWith({
    String? name,
    int? sortOrder,
  }) {
    return AppCategory(
      id: id,
      familyId: familyId,
      type: type,
      name: name ?? this.name,
      value: value,
      isSystem: isSystem,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AppCategory(id: $id, type: $type, name: $name)';
}
