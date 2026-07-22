import '../database/app_database.dart';

/// 过滤选项仓库 - 返回去重物品/超市列表（内存去重兜底）
class FilterOptionsRepository {
  final AppDatabase _db;

  FilterOptionsRepository(this._db);

  Future<List<String>> distinctProducts() {
    return _db.priceRecordDao.distinctProducts()
        .then((list) => list.toSet().toList()..sort());
  }

  Future<List<String>> distinctStores() {
    return _db.priceRecordDao.distinctStores()
        .then((list) => list.toSet().toList()..sort());
  }
}
