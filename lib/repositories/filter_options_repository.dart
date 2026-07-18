 import '../database/app_database.dart';
 
 /// 过滤选项仓库 - 聚合去重物品/超市列表供 ComboBox 使用
 class FilterOptionsRepository {
   final AppDatabase _db;
 
   FilterOptionsRepository(this._db);
 
   /// 去重升序物品列表
   Future<List<String>> distinctProducts() {
     return _db.priceRecordDao.distinctProducts();
   }
 
   /// 去重升序超市列表
   Future<List<String>> distinctStores() {
     return _db.priceRecordDao.distinctStores();
   }
 }
