import '../../../../core/constants/enums.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/cooking_history_entry.dart';

class HistoryMapper {
  HistoryMapper._();

  static CookingHistoryEntry fromDb(
    CookingHistoryTableData row,
    List<CookingHistoryIngredientsTableData> ingredientRows,
  ) {
    return CookingHistoryEntry(
      id: row.id,
      familyId: row.familyId,
      recipeId: row.recipeId,
      recipeTitle: row.recipeTitle,
      servingsCooked: row.servingsCooked,
      cookedBy: row.cookedBy,
      cookedAt: DateTime.fromMillisecondsSinceEpoch(row.cookedAt),
      notes: row.notes,
      ingredients: ingredientRows.map(_ingredientFromDb).toList(),
    );
  }

  static CookingHistoryIngredient _ingredientFromDb(
      CookingHistoryIngredientsTableData row) {
    return CookingHistoryIngredient(
      id: row.id,
      historyId: row.historyId,
      ingredientName: row.ingredientName,
      quantityUsed: row.quantityUsed,
      unit: MeasurementUnit.fromValue(row.unit),
      pantryItemId: row.pantryItemId,
    );
  }

  /// Builds a lightweight entry without ingredient details (for list views).
  static CookingHistoryEntry fromDbNoIngredients(
      CookingHistoryTableData row) {
    return CookingHistoryEntry(
      id: row.id,
      familyId: row.familyId,
      recipeId: row.recipeId,
      recipeTitle: row.recipeTitle,
      servingsCooked: row.servingsCooked,
      cookedBy: row.cookedBy,
      cookedAt: DateTime.fromMillisecondsSinceEpoch(row.cookedAt),
      notes: row.notes,
    );
  }
}
