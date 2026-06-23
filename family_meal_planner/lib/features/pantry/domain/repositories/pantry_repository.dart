import '../entities/pantry_item.dart';

abstract class PantryRepository {
  /// Stream of all pantry items for a family, ordered by category then name.
  Stream<List<PantryItem>> watchAll(String familyId);

  /// Stream of low-stock items (quantity ≤ minQuantity > 0).
  Stream<List<PantryItem>> watchLowStock(String familyId);

  /// Get all items once (for shopping list calculation).
  Future<List<PantryItem>> getAll(String familyId);

  /// Get a single item by id.
  Future<PantryItem?> getById(String id);

  /// Find an item by name (case-insensitive). Used when merging shopping list.
  Future<PantryItem?> getByName(String familyId, String name);

  /// Full-text search by name.
  Future<List<PantryItem>> search(String familyId, String query);

  /// Save (insert or update) a pantry item.
  Future<void> save(PantryItem item);

  /// Update only the quantity — used by inline editing and cooking deduction.
  Future<void> updateQuantity(String id, double quantity);

  /// Delete a pantry item.
  Future<void> delete(String id);

  /// Deduct [amount] from the item's current quantity (minimum 0).
  /// Returns the new quantity.
  Future<double> deduct(String id, double amount);
}
