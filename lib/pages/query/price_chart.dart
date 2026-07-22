 import 'package:flutter/cupertino.dart';
 import 'package:fl_chart/fl_chart.dart';
 import '../../database/app_database.dart';
 import '../../models/price_record.dart';
 import '../../models/product_unit.dart';
 import '../../repositories/record_repository.dart';
 import '../../utils/unit_price.dart';
 import '../../theme/app_theme.dart';
 
 /// 折线图组件 - 展示指定物品+超市的单价趋势
 class PriceChart extends StatelessWidget {
   final List<PriceRecordData> records;
   final String product;
   final String store;
 
   const PriceChart({
     super.key,
     required this.records,
     required this.product,
     required this.store,
   });
 
   @override
   Widget build(BuildContext context) {
     if (records.length < 2) {
       return const Center(
         child: Padding(
           padding: EdgeInsets.all(32),
           child: Text('数据点不足，至少需要 2 条记录才能绘制图表',
               textAlign: TextAlign.center,
               style: TextStyle(color: AppTheme.textSecondary)),
         ),
       );
     }
 
     // 按时间升序排列
     final items = RecordRepository.toPriceRecordList(records);
     items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
 
     // 计算归一化单价
     final spots = <FlSpot>[];
     double minY = double.infinity;
     double maxY = double.negativeInfinity;
 
     for (int i = 0; i < items.length; i++) {
       final up = computeUnitPrice(
           items[i].price, items[i].quantity, items[i].unit);
       spots.add(FlSpot(i.toDouble(), up.value));
       if (up.value < minY) minY = up.value;
       if (up.value > maxY) maxY = up.value;
     }
 
     if (minY == maxY) {
       minY -= 1;
       maxY += 1;
     }
 
     return Column(
       children: [
         // 图表标题
         Padding(
           padding: const EdgeInsets.all(8),
           child: Text('单价走势 - $product · $store',
               style: const TextStyle(
                   fontWeight: FontWeight.w600, fontSize: 14)),
         ),
         // 折线图
         SizedBox(
           height: 200,
           child: Padding(
             padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
             child: LineChart(
               LineChartData(
                 minY: minY * 0.9,
                 maxY: maxY * 1.1,
                 gridData: FlGridData(
                   show: true,
                   horizontalInterval:
                       ((maxY - minY) / 4).clamp(0.01, double.infinity),
                   getDrawingHorizontalLine: (value) => FlLine(
                     color: AppTheme.dividerColor.withAlpha(60),
                     strokeWidth: 1,
                   ),
                 ),
                 titlesData: FlTitlesData(
                   bottomTitles: AxisTitles(
                     sideTitles: SideTitles(
                       showTitles: true,
                       reservedSize: 30,
                       getTitlesWidget: (value, meta) {
                         final idx = value.toInt();
                         if (idx >= 0 && idx < items.length) {
                           final dt = items[idx].createdAt;
                           return Padding(
                             padding: const EdgeInsets.only(top: 4),
                             child: Text(
                               '${dt.month}/${dt.day}',
                               style: const TextStyle(fontSize: 10),
                             ),
                           );
                         }
                         return const SizedBox();
                       },
                     ),
                   ),
                   leftTitles: AxisTitles(
                     sideTitles: SideTitles(
                       showTitles: true,
                       reservedSize: 40,
                       getTitlesWidget: (value, meta) => Text(
 value.toStringAsFixed(2),
                         style: const TextStyle(fontSize: 10),
                       ),
                     ),
                   ),
                   topTitles: const AxisTitles(
                       sideTitles: SideTitles(showTitles: false)),
                   rightTitles: const AxisTitles(
                       sideTitles: SideTitles(showTitles: false)),
                 ),
                 borderData: FlBorderData(show: false),
                 lineBarsData: [
                   LineChartBarData(
                     spots: spots,
                     isCurved: true,
                     color: AppTheme.primaryColor,
                     barWidth: 2.5,
                     dotData: FlDotData(
                       show: true,
                       getDotPainter: (spot, percent, bar, index) =>
                           FlDotCirclePainter(
                         radius: 4,
                         color: AppTheme.primaryColor,
                         strokeWidth: 1.5,
                         strokeColor: CupertinoColors.white,
                       ),
                    ),
                     belowBarData: BarAreaData(
                       show: true,
                       gradient: LinearGradient(
                         begin: Alignment.topCenter,
                         end: Alignment.bottomCenter,
                         colors: [
                           AppTheme.primaryColor.withAlpha(60),
                           AppTheme.primaryColor.withAlpha(10),
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ),
         // 明细列表
         CupertinoListSection(
           header: const Text('明细'),
           children: items.reversed.map((item) {
             final up = computeUnitPrice(
                 item.price, item.quantity, item.unit);
             return CupertinoListTile(
               title: Text('¥${item.price} / ${item.quantity}${item.unit.symbol}'),
               subtitle: Text(_formatTime(item.createdAt)),
               trailing: Text(up.valueDisplay,
                   style: const TextStyle(
                       fontWeight: FontWeight.w600, fontSize: 13)),
             );
           }).toList(),
         ),
       ],
     );
   }
 
   String _formatTime(DateTime dt) {
     return '${dt.year}/${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:'
         '${dt.minute.toString().padLeft(2, '0')}';
   }
 }
