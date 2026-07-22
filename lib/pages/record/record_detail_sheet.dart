 import 'package:flutter/cupertino.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';
 import '../../database/tables/price_records.dart';
 import '../../models/price_record.dart';
 import '../../models/product_unit.dart';
 import '../../repositories/record_repository.dart';
 import '../../utils/unit_price.dart';
 import '../../widgets/unit_price_chip.dart';
 import '../../providers/records_provider.dart';
 import '../../theme/app_theme.dart';
 
 /// 记录详情底部弹窗（编辑模式支持改单位，Med-6 已修复）
 class RecordDetailSheet extends ConsumerStatefulWidget {
   final PriceRecordData data;
 
   const RecordDetailSheet({super.key, required this.data});
 
   @override
   ConsumerState<RecordDetailSheet> createState() => _RecordDetailSheetState();
 }
 
 class _RecordDetailSheetState extends ConsumerState<RecordDetailSheet> {
   late bool _isEditing;
   final _storeCtrl = TextEditingController();
   final _productCtrl = TextEditingController();
   final _priceCtrl = TextEditingController();
   final _qtyCtrl = TextEditingController();
   late ProductUnit _selectedUnit;
   late PriceRecord _record;
 
   @override
   void initState() {
     super.initState();
     _isEditing = false;
     _record = RecordRepository.toPriceRecord(widget.data);
     _storeCtrl.text = _record.store ?? '';
     _productCtrl.text = _record.product;
     _priceCtrl.text = _record.price.toString();
     _qtyCtrl.text = _record.quantity.toString();
     _selectedUnit = _record.unit;
   }
 
   @override
   void dispose() {
     _storeCtrl.dispose();
     _productCtrl.dispose();
     _priceCtrl.dispose();
     _qtyCtrl.dispose();
     super.dispose();
   }
 
   void _toggleEdit() => setState(() => _isEditing = !_isEditing);
 
   Future<void> _save() async {
     final repo = ref.read(recordRepositoryProvider);
     final updated = _record.copyWith(
       store: _storeCtrl.text.trim().isEmpty ? null : _storeCtrl.text.trim(),
       product: _productCtrl.text.trim(),
       price: double.tryParse(_priceCtrl.text) ?? _record.price,
       quantity: double.tryParse(_qtyCtrl.text) ?? _record.quantity,
       unit: _selectedUnit,
     );
     await repo.updateRecord(updated);
     setState(() {
       _record = updated;
       _isEditing = false;
     });
   }
 
   Future<void> _delete() async {
     final confirm = await showCupertinoDialog<bool>(
       context: context,
       builder: (ctx) => CupertinoAlertDialog(
         title: const Text('确认删除'),
         content: const Text('删除后无法恢复'),
         actions: [
           CupertinoDialogAction(
             isDestructiveAction: true,
             child: const Text('删除'),
             onPressed: () => Navigator.of(ctx).pop(true),
           ),
           CupertinoDialogAction(
             child: const Text('取消'),
             onPressed: () => Navigator.of(ctx).pop(false),
           ),
         ],
       ),
     );
     if (confirm == true && _record.id != null) {
       final repo = ref.read(recordRepositoryProvider);
       await repo.deleteRecord(_record.id!);
       if (mounted) Navigator.of(context).pop();
     }
   }
 
   @override
   Widget build(BuildContext context) {
     final up = computeUnitPrice(
         _record.price, _record.quantity, _record.unit);
 
     return CupertinoPageScaffold(
       navigationBar: CupertinoNavigationBar(
         middle: Text(_isEditing ? '编辑记录' : '记录详情'),
         trailing: CupertinoButton(
           padding: EdgeInsets.zero,
           child: Text(_isEditing ? '保存' : '编辑'),
           onPressed: _isEditing ? _save : _toggleEdit,
         ),
       ),
       child: SafeArea(
         child: ListView(
           padding: const EdgeInsets.all(16),
           children: [
            Center(child: Text(up.display, style: AppTheme.priceTextStyle)),
             const SizedBox(height: 16),
             CupertinoFormSection(
               children: [
                 CupertinoFormRow(
                   label: const Text('超市'),
                   child: _isEditing
                       ? CupertinoTextField(controller: _storeCtrl)
                       : Text(_record.store ?? ''),
                 ),
                 CupertinoFormRow(
                   label: const Text('商品'),
                   child: _isEditing
                       ? CupertinoTextField(controller: _productCtrl)
                       : Text(_record.product),
                 ),
                 CupertinoFormRow(
                   label: const Text('价格'),
                   child: _isEditing
                       ? CupertinoTextField(
                           controller: _priceCtrl,
                           keyboardType: TextInputType.number,
                         )
                       : Text('¥${_record.price.toStringAsFixed(2)}'),
                 ),
                 CupertinoFormRow(
                   label: const Text('数量'),
                   child: _isEditing
                       ? CupertinoTextField(
                           controller: _qtyCtrl,
                           keyboardType: TextInputType.number,
                         )
                       : Text(_record.quantity.toString()),
                 ),
                 CupertinoFormRow(
                   label: const Text('单位'),
                   child: _isEditing
                       ? CupertinoButton(
                           padding: EdgeInsets.zero,
                           child: Text(_selectedUnit.symbol),
                           onPressed: () => _showUnitPicker(),
                         )
                       : Text(_selectedUnit.symbol),
                 ),
               ],
             ),
             const SizedBox(height: 16),
             CupertinoButton(
               color: AppTheme.errorColor,
               child: const Text('删除记录'),
               onPressed: _delete,
             ),
           ],
         ),
       ),
     );
   }
 
   void _showUnitPicker() {
     showCupertinoModalPopup(
       context: context,
       builder: (ctx) => _EditUnitPicker(
         selected: _selectedUnit,
         onSelected: (unit) {
           setState(() => _selectedUnit = unit);
           Navigator.of(ctx).pop();
         },
       ),
     );
   }
 }
 
 class _EditUnitPicker extends StatelessWidget {
   final ProductUnit selected;
   final ValueChanged<ProductUnit> onSelected;
 
   const _EditUnitPicker({required this.selected, required this.onSelected});
 
   @override
   Widget build(BuildContext context) {
     return Container(
       height: 260,
       color: CupertinoColors.systemBackground,
       child: Column(
         children: [
           CupertinoButton(
             child: const Text('完成'),
             onPressed: () => Navigator.of(context).pop(),
           ),
           Expanded(
             child: CupertinoPicker(
               itemExtent: 40,
               scrollController: FixedExtentScrollController(
                 initialItem: ProductUnit.values.indexOf(selected),
               ),
               onSelectedItemChanged: (i) =>
                   onSelected(ProductUnit.values[i]),
               children: ProductUnit.values
                   .map((u) => Center(child: Text(u.symbol)))
                   .toList(),
             ),
           ),
         ],
       ),
     );
   }
 }
 
 /// 便捷展示详情弹窗
 void showRecordDetail(BuildContext context, PriceRecordData data) {
   showCupertinoModalPopup(
     context: context,
     builder: (_) => RecordDetailSheet(data: data),
   );
 }
