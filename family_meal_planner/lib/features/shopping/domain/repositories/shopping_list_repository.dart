import '../../../../core/constants/enums.dart';
import '../entities/shopping_list.dart';

abstract class ShoppingListRepository {
  /// Reactive stream of all lists for [familyId], most recent first.
  /// Each list includes its items already loaded.
  Stream<List<ShoppingList>> watchLists(String familyId);

  /// Reactive stream of a single list with all its items.
  /// Emits null if the list has been deleted.
  Stream<ShoppingList?> watchList(String id);

  /// Generates a shopping list from the meal plan in [dateFrom]..[dateTo].
  ///
  /// Algorithm:
  ///  1. Load all meal plan entries in the date range.
  ///  2. For each recipe, scale ingredients by entry.servings / recipe.defaultServings.
  ///  3. Aggregate identical ingredients (same name + unit).
  ///  4. Compare with pantry stock (exact name + unit match).
  ///  5. Compute quantityToBuy = max(0, needed − inPantry).
  ///  6. Persist and return the new list.
  Future<ShoppingList> generateFromMealPlan({
    required String familyId,
    required DateTime dateFrom,
    required DateTime dateTo,
    String? name,
  });

  /// Toggles the [isChecked] flag on a single item.
  Future<void> toggleItem(String itemId, {required bool isChecked});

  /// Deletes an entire shopping list (cascade-deletes its items).
  Future<void> deleteList(String id);

  /// Removes one item from a list.
  Future<void> deleteItem(String id);

  /// Adds a user-supplied item to an existing list.
  Future<void> addManualItem({
    required String listId,
    required String name,
    required double quantity,
    required MeasurementUnit unit,
    PantryCategory? category,
  });
}
