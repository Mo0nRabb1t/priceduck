import '../database/app_database.dart';

/// 过滤选项仓库 - 直接透传 DAO 结果（SQL 层已去重+排序）
class FilterOptionsRepository {
  final AppDatabase _db;

  FilterOptionsRepository(this._db);

  Future<List<String>> distinctProducts() {
    return _db.priceRecordDao.distinctProducts();
  }

  Future<List<String>> distinctStores() {
    return _db.priceRecordDao.distinctStores();
  }
}
