 import 'package:flutter_riverpod/flutter_riverpod.dart';
 import '../database/app_database.dart';
 import '../repositories/filter_options_repository.dart';
 
 /// 过滤选项仓库 Provider
 final filterOptionsRepositoryProvider =
     Provider<FilterOptionsRepository>((ref) {
   final db = ref.watch(databaseProvider);
   return FilterOptionsRepository(db);
 });
 
 /// 去重物品列表 Provider
 final productOptionsProvider = FutureProvider<List<String>>((ref) {
   final repo = ref.watch(filterOptionsRepositoryProvider);
   return repo.distinctProducts();
 });
 
 /// 去重超市列表 Provider
 final storeOptionsProvider = FutureProvider<List<String>>((ref) {
   final repo = ref.watch(filterOptionsRepositoryProvider);
   return repo.distinctStores();
 });
