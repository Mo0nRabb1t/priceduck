 import 'package:flutter/cupertino.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';
 import '../../database/tables/price_records.dart';
 import '../../providers/records_provider.dart';
 import '../../repositories/record_repository.dart';
 import '../../models/product_unit.dart';
 import '../../utils/unit_price.dart';
 import '../../widgets/unit_price_chip.dart';
 import '../../theme/app_theme.dart';
 
 /// 记录列表（有数据时用 ListView 包裹 CupertinoListSection 实现滚动）
 class RecordList extends ConsumerWidget {
   const RecordList({super.key});
 
   @override
   Widget build(BuildContext context, WidgetRef ref) {
     final recordsAsync = ref.watch(recordsProvider);
 
     return recordsAsync.when(
       data: (records) {
         if (records.isEmpty) {
           return const Center(
             child: Text('暂无记录',
                 style: TextStyle(color: AppTheme.textSecondary)),
           );
         }
         // ListView 在 Expanded 内获得有界约束，自然可滚动
         return ListView(
           children: [
             CupertinoListSection(
               children: records.map<Widget>((r) {
                 final record = RecordRepository.toPriceRecord(r);
                 final up = computeUnitPrice(
                     record.price, record.quantity, record.unit);
                 final storeLabel = record.store ?? '-';
                 return CupertinoListTile(
                   title: Text('${record.product} · $storeLabel'),
                   subtitle: Text(_formatTime(record.createdAt)),
                   trailing: UnitPriceChip(label: up.display),
                 );
               }).toList(),
             ),
           ],
         );
       },
       loading: () => const Center(child: CupertinoActivityIndicator()),
       error: (err, _) => Center(child: Text('加载失败: $err')),
     );
   }
 
   String _formatTime(DateTime dt) {
     return '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:'
         '${dt.minute.toString().padLeft(2, '0')}';
   }
 }
