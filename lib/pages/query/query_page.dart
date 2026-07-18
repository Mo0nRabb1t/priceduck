 import 'package:flutter/cupertino.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';
 import '../../providers/records_provider.dart';
 import '../../providers/filter_options_provider.dart';
 import '../../widgets/filter_combobox.dart';
 import 'query_result_list.dart';
 import 'price_chart.dart';
 import '../../theme/app_theme.dart';
 
 /// 查询页面
 class QueryPage extends ConsumerStatefulWidget {
   const QueryPage({super.key});
 
   @override
   ConsumerState<QueryPage> createState() => _QueryPageState();
 }
 
 class _QueryPageState extends ConsumerState<QueryPage> {
   final _productCtrl = TextEditingController();
   final _storeCtrl = TextEditingController();
   bool _searched = false;
   String? _searchProduct;
   String? _searchStore;
 
   @override
   void dispose() {
     _productCtrl.dispose();
     _storeCtrl.dispose();
     super.dispose();
   }
 
   void _search() {
     final product = _productCtrl.text.trim();
     if (product.isEmpty) {
       showCupertinoDialog(
         context: context,
         builder: (ctx) => CupertinoAlertDialog(
           title: const Text('提示'),
           content: const Text('请输入要查询的物品'),
           actions: [
             CupertinoDialogAction(
               child: const Text('确定'),
               onPressed: () => Navigator.of(ctx).pop(),
             ),
           ],
         ),
       );
       return;
     }
     setState(() {
       _searched = true;
       _searchProduct = product;
       _searchStore = _storeCtrl.text.trim();
       _searchStore = _searchStore!.isEmpty ? null : _searchStore;
     });
   }
 
   void _reset() {
     _productCtrl.clear();
     _storeCtrl.clear();
     setState(() {
       _searched = false;
       _searchProduct = null;
       _searchStore = null;
     });
   }
 
   @override
   Widget build(BuildContext context) {
     final productOptions = ref.watch(productOptionsProvider)
         .when(data: (d) => d, loading: () => <String>[], error: (_, __) => <String>[]);
     final storeOptions = ref.watch(storeOptionsProvider)
         .when(data: (d) => d, loading: () => <String>[], error: (_, __) => <String>[]);
 
     return CupertinoPageScaffold(
       navigationBar: CupertinoNavigationBar(
         middle: const Text('查询比价'),
       ),
       child: SafeArea(
         child: Column(
           children: [
             // 筛选区域
             Padding(
               padding: const EdgeInsets.all(12),
               child: Column(
                 children: [
                   FilterComboBox(
                     controller: _productCtrl,
                     options: productOptions,
                     hintText: '物品（必填）',
                   ),
                   const SizedBox(height: 8),
                   FilterComboBox(
                     controller: _storeCtrl,
                     options: storeOptions,
                     hintText: '超市（可选）',
                   ),
                   const SizedBox(height: 12),
                   Row(
                     children: [
                       Expanded(
                         child: CupertinoButton.filled(
                           child: const Text('搜索'),
                           onPressed: _search,
                         ),
                       ),
                       const SizedBox(width: 12),
                       CupertinoButton(
                         child: const Text('重置'),
                         onPressed: _reset,
                       ),
                     ],
                   ),
                 ],
               ),
             ),
             Container(height: 1,
                 color: CupertinoColors.systemGrey.withAlpha(76)),
             // 结果区域
             Expanded(
               child: _searched && _searchProduct != null
                   ? _buildResults()
                   : const Center(
                       child: Text('请输入物品进行查询',
                           style: TextStyle(color: AppTheme.textSecondary)),
                     ),
             ),
           ],
         ),
       ),
     );
   }
 
   Widget _buildResults() {
     final recordsAsync = ref.watch(queryResultProvider((
       product: _searchProduct!,
       store: _searchStore,
     )));
 
     return recordsAsync.when(
       data: (records) {
         if (records.isEmpty) {
           return const Center(
             child: Text('无查询结果',
                 style: TextStyle(color: AppTheme.textSecondary)),
           );
         }
 
         if (_searchStore != null) {
           // 物品+超市 → 折线图 + 明细
           return SingleChildScrollView(
             child: PriceChart(
               records: records,
               product: _searchProduct!,
               store: _searchStore!,
             ),
           );
         }
 
         // 仅物品 → 列表（按单价升序）
         return SingleChildScrollView(
           child: QueryResultList(records: records),
         );
       },
       loading: () => const Center(child: CupertinoActivityIndicator()),
       error: (err, _) => Center(child: Text('查询失败: $err')),
     );
   }
 }
