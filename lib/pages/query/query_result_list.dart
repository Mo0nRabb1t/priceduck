 import 'package:flutter/cupertino.dart';
 import '../../database/app_database.dart';
 import '../../models/price_record.dart';
 import '../../models/product_unit.dart';
 import '../../repositories/record_repository.dart';
 import '../../utils/unit_price.dart';
 import '../../widgets/unit_price_chip.dart';
 import '../../theme/app_theme.dart';
 
/// 查询结果列表 - 卡片表格样式（Q3）
/// 圆角白卡容器 + 表头 + 价格红色醒目
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
 
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: AppTheme.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppTheme.detailHighlightYellow,
              child: Row(children: [
                Expanded(flex: 2, child: _headerCell('超市')),
                Expanded(flex: 3, child: _headerCell('商品')),
                Expanded(flex: 2, child: _headerCell('价格')),
                Expanded(flex: 2, child: _headerCell('时间', align: TextAlign.right)),
              ]),
            ),
            ...items.map((item) => _buildRow(item)).toList(),
          ],
        ),
      ),
     );
   }
 
   String _formatTime(DateTime dt) {
  return '${dt.month}/${dt.day}';
   }
   Widget _headerCell(String text, {TextAlign align = TextAlign.start}) {
     return Text(text, textAlign: align,
         style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
             color: AppTheme.textSecondary));
   }
 
   Widget _buildRow(PriceRecord item) {
     final up = computeUnitPrice(item.price, item.quantity, item.unit);
     return Padding(
       padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
       child: Row(children: [
         Expanded(flex: 2,
             child: Text(item.store ?? '-',
                 style: TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                 overflow: TextOverflow.ellipsis)),
         Expanded(flex: 3,
             child: Text(item.product,
                 style: TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                 overflow: TextOverflow.ellipsis)),
         Expanded(flex: 2,
             child: Text(up.display,
                 style: AppTheme.priceTextStyle.copyWith(fontSize: 16))),
         Expanded(flex: 2,
             child: Text(_formatTime(item.createdAt),
                 textAlign: TextAlign.right,
                 style: TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
      ]),
    );
  }

}
