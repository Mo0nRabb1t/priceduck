import 'package:drift/drift.dart';

/// 物价记录表
 @DataClassName('PriceRecordData')
 class PriceRecords extends Table {
   IntColumn get id => integer().autoIncrement()();
   TextColumn get store => text()();
   TextColumn get product => text()();
   RealColumn get price => real()();
   RealColumn get quantity => real()();
   TextColumn get unit => text()(); // 存枚举 symbol（g/kg/ml/L/个）
   DateTimeColumn get createdAt => dateTime()();
 
   @override
   Set<Index> get indexes => {
         Index('idx_product', 'product'),
         Index('idx_store', 'store'),
         Index('idx_created_at', 'createdAt'),
       };
 }
