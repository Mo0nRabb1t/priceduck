 import 'package:flutter_riverpod/flutter_riverpod.dart';
 import '../database/app_database.dart';
 import '../repositories/record_repository.dart';
 import '../utils/unit_price.dart';
 import '../models/product_unit.dart';
 
 /// 数据库实例 Provider
 final databaseProvider = Provider<AppDatabase>((ref) {
   return AppDatabase.instance;
 });
 
 /// 记录仓库 Provider
 final recordRepositoryProvider = Provider<RecordRepository>((ref) {
   final db = ref.watch(databaseProvider);
   return RecordRepository(db);
 });
 
 /// 全部记录流 Provider（倒序）
 final recordsProvider =
     StreamProvider<List<PriceRecordData>>((ref) {
   final repo = ref.watch(recordRepositoryProvider);
   return repo.watchAllRecords();
 });
 
 /// 单价预览 Provider（表单实时计算用）
 final unitPricePreviewProvider =
     Provider.family<UnitPriceResult?, ({
       double price,
       double quantity,
       ProductUnit unit
     })>((ref, params) {
   if (params.price <= 0 || params.quantity <= 0) return null;
   try {
     return computeUnitPrice(params.price, params.quantity, params.unit);
   } catch (_) {
     return null;
   }
 });
 
 /// 查询结果 Provider（按条件）
 final queryResultProvider =
     StreamProvider.family<List<PriceRecordData>, ({
       String product,
       String? store,
     })>((ref, params) {
   final repo = ref.watch(recordRepositoryProvider);
   if (params.store != null && params.store!.isNotEmpty) {
     return repo.watchByProductAndStore(params.product, params.store!);
   }
   return repo.watchByProduct(params.product);
 });
