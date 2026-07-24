 import 'dart:async';
 import 'package:drift/drift.dart';
 import '../tables/price_records.dart';
 import '../app_database.dart';
 import '../../models/product_unit.dart';
import '../../models/price_record.dart';

part 'price_record_dao.g.dart';

/// 物价记录 DAO
 @DriftAccessor(tables: [PriceRecords])
 class PriceRecordDao extends DatabaseAccessor<AppDatabase>
     with _$PriceRecordDaoMixin {
   PriceRecordDao(super.db);
 
   /// 新增记录，返回自增 id
   Future<int> insertRecord(Insertable<PriceRecordData> record) {
     return into(priceRecords).insert(record);
   }
 
   /// 按 id 删除
   Future<void> deleteRecord(int id) {
     return (delete(priceRecords)..where((t) => t.id.equals(id))).go();
   }
 
   /// 按 id 更新
  Future<void> updateRecord(PriceRecord record) {
    if (record.id == null) return Future.value();
    return (update(priceRecords)..where((t) => t.id.equals(record.id!)))
        .write(PriceRecordsCompanion(
      store: Value(record.store ?? ''),
      product: Value(record.product),
      price: Value(record.price),
      quantity: Value(record.quantity),
      unit: Value(record.unit.symbol),
      createdAt: Value(record.createdAt),
    ));
   }
 
   /// 流：全部记录按创建时间倒序
   Stream<List<PriceRecordData>> watchAllRecords() {
     return (select(priceRecords)
           ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
         .watch();
   }
 
   /// 流：按物品查询（不限超市）
   Stream<List<PriceRecordData>> watchByProduct(String product) {
     return (select(priceRecords)
           ..where((t) => t.product.equals(product))
           ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
         .watch();
   }
 
   /// 流：按物品+超市查询
   Stream<List<PriceRecordData>> watchByProductAndStore(
       String product, String store) {
     return (select(priceRecords)
           ..where((t) =>
               t.product.equals(product) & t.store.equals(store))
           ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
         .watch();
   }
 
   /// 去重升序物品列表（ComboBox 用）—— select + Dart 层 toSet 兜底
   Future<List<String>> distinctProducts() {
     return (select(priceRecords, distinct: true)
           ..orderBy([(t) => OrderingTerm(expression: t.product, mode: OrderingMode.asc)]))
         .map((r) => r.product)
         .get()
         .then((list) => list.where((e) => e.isNotEmpty).toSet().toList()..sort());
   }

   /// 去重升序超市列表（ComboBox 用）
   Future<List<String>> distinctStores() {
     return (select(priceRecords, distinct: true)
           ..orderBy([(t) => OrderingTerm(expression: t.store, mode: OrderingMode.asc)]))
         .map((r) => r.store)
         .get()
         .then((list) => list.where((e) => e.isNotEmpty).toSet().toList()..sort());
   }

  /// 流：去重物品列表（ComboBox 用，实时监听数据库变化）
  Stream<List<String>> watchDistinctProducts() {
    return (select(priceRecords)
          ..orderBy([(t) => OrderingTerm(expression: t.product, mode: OrderingMode.asc)]))
        .map((r) => r.product)
        .watch()
        .map((list) => list.where((e) => e.isNotEmpty).toSet().toList()..sort());
  }

  /// 流：去重超市列表（ComboBox 用，实时监听数据库变化）
  Stream<List<String>> watchDistinctStores() {
    return (select(priceRecords)
          ..orderBy([(t) => OrderingTerm(expression: t.store, mode: OrderingMode.asc)]))
        .map((r) => r.store)
        .watch()
        .map((list) => list.where((e) => e.isNotEmpty).toSet().toList()..sort());
  }
 }
