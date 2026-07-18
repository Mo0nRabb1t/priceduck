 import 'package:flutter/cupertino.dart';
 import '../../database/tables/price_records.dart';
 import '../../models/price_record.dart';
 import '../../models/product_unit.dart';
 import '../../repositories/record_repository.dart';
 import '../../utils/unit_price.dart';
 import '../../widgets/unit_price_chip.dart';
 import '../../theme/app_theme.dart';
 
 /// 查询结果列表 - 按单价升序排列，显示原始价/量（Med-7 已修复）
 class QueryResultList extends StatelessWidget {
   final List<PriceRecordData> records;
 
   const QueryResultList({super.key, required this.records});
 
   @override
   Widget build(BuildContext context) {
     if (records.isEmpty) {
       return const Center(
         child: Padding(
           padding: EdgeInsets.all(32),
           child: Text('无查询结果',
               style: TextStyle(color: AppTheme.textSecondary)),
         ),
       );
     }
 
     final items = RecordRepository.toPriceRecordList(records);
     items.sort((a, b) {
       final upA = computeUnitPrice(a.price, a.quantity, a.unit);
       final upB = computeUnitPrice(b.price, b.quantity, b.unit);
       return upA.value.compareTo(upB.value);
     });
 
     return CupertinoListSection(
       header: const Text('查询结果（按单价升序）'),
       children: items.map((item) {
         final up = computeUnitPrice(item.price, item.quantity, item.unit);
         return CupertinoListTile(
           title: Text('${item.product} · ${item.store ?? "-"}'),
           subtitle: Text('¥${item.price} / ${item.quantity}${item.unit.symbol}'),
           trailing: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.end,
             children: [
               UnitPriceChip(label: up.display),
               Text(_formatTime(item.createdAt),
                   style: const TextStyle(
                       fontSize: 11, color: AppTheme.textSecondary)),
             ],
           ),
         );
       }).toList(),
     );
   }
 
   String _formatTime(DateTime dt) {
     return '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:'
         '${dt.minute.toString().padLeft(2, '0')}';
   }
 }
