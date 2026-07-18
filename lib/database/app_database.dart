 import 'dart:io';
 import 'package:drift/drift.dart';
 import 'package:drift/native.dart';
 import 'package:path/path.dart' as p;
 import 'package:path_provider/path_provider.dart';
 import 'tables/price_records.dart';
import 'daos/price_record_dao.dart';

part 'app_database.g.dart';

/// 应用数据库（单例，离线 SQLite）
 @DriftDatabase(tables: [PriceRecords], daos: [PriceRecordDao])
 class AppDatabase extends _$AppDatabase {
   AppDatabase() : super(_openConnection());
 
   @override
   int get schemaVersion => 1;
 
   static LazyDatabase _openConnection() {
     return LazyDatabase(() async {
       final dir = await getApplicationDocumentsDirectory();
       final file = File(p.join(dir.path, 'price_record.sqlite'));
       return NativeDatabase(file);
     });
   }
 
   /// 全局单例
   static AppDatabase? _instance;
   static AppDatabase get instance {
     _instance ??= AppDatabase();
     return _instance!;
   }
 }
