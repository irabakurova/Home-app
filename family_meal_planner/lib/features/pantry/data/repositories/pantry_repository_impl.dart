import '../../../../core/database/daos/pantry_dao.dart';
import '../../domain/entities/pantry_item.dart';
import '../../domain/repositories/pantry_repository.dart';
import '../models/pantry_mapper.dart';

class PantryRepositoryImpl implements PantryRepository {
  PantryRepositoryImpl(this._dao);

  final PantryDao _dao;

  @override
  Stream<List<PantryItem>> watchAll(String familyId) {
    return _dao
        .watchAll(familyId)
        .map((rows) => rows.map(PantryMapper.fromDb).toList());
  }

  @override
  Stream<List<PantryItem>> watchLowStock(String familyId) {
    return _dao
        .watchLowStock(familyId)
        .map((rows) => rows.map(PantryMapper.fromDb).toList());
  }

  @override
  Future<List<PantryItem>> getAll(String familyId) async {
    final rows = await _dao.getAll(familyId);
    return rows.map(PantryMapper.fromDb).toList();
  }

  @override
  Future<PantryItem?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : PantryMapper.fromDb(row);
  }

  @override
  Future<PantryItem?> getByName(String familyId, String name) async {
    final row = await _dao.getByName(familyId, name);
    return row == null ? null : PantryMapper.fromDb(row);
  }

  @override
  Future<List<PantryItem>> search(String familyId, String query) async {
    final rows = await _dao.search(familyId, query);
    return rows.map(PantryMapper.fromDb).toList();
  }

  @override
  Future<void> save(PantryItem item) async {
    await _dao.upsert(PantryMapper.toDb(item));
  }

  @override
  Future<void> updateQuantity(String id, double quantity) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _dao.updateQuantity(id, quantity < 0 ? 0 : quantity, now);
  }

  @override
  Future<void> delete(String id) => _dao.deleteById(id);

  @override
  Future<double> deduct(String id, double amount) async {
    final item = await _dao.getById(id);
    if (item == null) return 0;
    final newQty = (item.quantity - amount).clamp(0.0, double.infinity);
    final now = DateTime.now().millisecondsSinceEpoch;
    await _dao.updateQuantity(id, newQty, now);
    return newQty;
  }
}
