import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';

class RecipeMapper {
  RecipeMapper._();

  // ── Recipe ────────────────────────────────────────────────────────────────

  static Recipe fromDb(RecipesTableData data) {
    return Recipe(
      id: data.id,
      familyId: data.familyId,
      title: data.title,
      description: data.description,
      photoUrl: data.photoUrl,
      category: data.category,  // String slug, no enum conversion needed
      cuisine: data.cuisine,    // String slug
      cookTimeMinutes: data.cookTimeMinutes,
      defaultServings: data.defaultServings,
      instructions: _decodeInstructions(data.instructions),
      isFavorite: data.isFavorite,
      createdBy: data.createdBy,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data.updatedAt),
    );
  }

  static RecipesTableCompanion toDb(Recipe recipe) {
    return RecipesTableCompanion(
      id: Value(recipe.id),
      familyId: Value(recipe.familyId),
      title: Value(recipe.title),
      description: Value(recipe.description),
      photoUrl: Value(recipe.photoUrl),
      category: Value(recipe.category),  // already a String slug
      cuisine: Value(recipe.cuisine),    // already a String slug
      cookTimeMinutes: Value(recipe.cookTimeMinutes),
      defaultServings: Value(recipe.defaultServings),
      instructions: Value(jsonEncode(recipe.instructions)),
      isFavorite: Value(recipe.isFavorite),
      createdBy: Value(recipe.createdBy),
      createdAt: Value(recipe.createdAt.millisecondsSinceEpoch),
      updatedAt: Value(recipe.updatedAt.millisecondsSinceEpoch),
    );
  }

  // ── Ingredient ────────────────────────────────────────────────────────────

  static Ingredient ingredientFromDb(IngredientsTableData data) {
    return Ingredient(
      id: data.id,
      recipeId: data.recipeId,
      name: data.name,
      quantity: data.quantity,
      unit: MeasurementUnit.fromValue(data.unit),
      category:
          data.category != null ? PantryCategory.fromValue(data.category!) : null,
      sortOrder: data.sortOrder,
    );
  }

  static IngredientsTableCompanion ingredientToDb(Ingredient ingredient) {
    return IngredientsTableCompanion(
      id: Value(ingredient.id),
      recipeId: Value(ingredient.recipeId),
      name: Value(ingredient.name),
      quantity: Value(ingredient.quantity),
      unit: Value(ingredient.unit.value),
      category: Value(ingredient.category?.value),
      sortOrder: Value(ingredient.sortOrder),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static List<String> _decodeInstructions(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is List) return decoded.cast<String>();
    } catch (_) {}
    return [];
  }
}
