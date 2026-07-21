import 'dart:async';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables/price_records.dart';
 import '../models/price_record.dart';
 import '../models/product_unit.dart';
 
 /// 记录仓库 - 封装 DAO，供 Provider 层调用
 /// store 可选：空值存为空字符串
 class RecordRepository {
   final AppDatabase _db;
 
   RecordRepository(this._db);
 
   /// 新增记录（store 为空时存空字符串）
   Future<int> insertRecord(PriceRecord r) {
    return _db.priceRecordDao.insertRecord(PriceRecordsCompanion.insert(
      store: r.store ?? '',
      product: r.product,
      price: r.price,
      quantity: r.quantity,
      unit: r.unit.symbol,
      createdAt: r.createdAt,
    ));
   }
 
   Future<void> deleteRecord(int id) {
     return _db.priceRecordDao.deleteRecord(id);
   }
 
   Future<void> updateRecord(PriceRecord r) {
     return _db.priceRecordDao.updateRecord(r);
   }
 
   Stream<List<PriceRecordData>> watchAllRecords() {
     return _db.priceRecordDao.watchAllRecords();
   }
 
   Stream<List<PriceRecordData>> watchByProduct(String product) {
     return _db.priceRecordDao.watchByProduct(product);
   }
 
   Stream<List<PriceRecordData>> watchByProductAndStore(
       String product, String store) {
     return _db.priceRecordDao.watchByProductAndStore(product, store);
   }
 
   /// 将 PriceRecordData 转换为 PriceRecord（store为空→null）
   static PriceRecord toPriceRecord(PriceRecordData d) {
     return PriceRecord(
       id: d.id,
       store: d.store.isEmpty ? null : d.store,
       product: d.product,
       price: d.price,
       quantity: d.quantity,
       unit: parseProductUnit(d.unit) ?? ProductUnit.piece,
       createdAt: d.createdAt,
     );
   }
 
   static List<PriceRecord> toPriceRecordList(List<PriceRecordData> list) {
     return list.map(toPriceRecord).toList();
   }
 }
