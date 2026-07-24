import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../repositories/filter_options_repository.dart';
import 'records_provider.dart';

/// 过滤选项仓库 Provider
final filterOptionsRepositoryProvider =
    Provider<FilterOptionsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return FilterOptionsRepository(db);
});

/// 去重物品列表 Provider（Stream 实时监听）
final productOptionsProvider = StreamProvider<List<String>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.priceRecordDao.watchDistinctProducts();
});

/// 去重超市列表 Provider（Stream 实时监听）
final storeOptionsProvider = StreamProvider<List<String>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.priceRecordDao.watchDistinctStores();
});
