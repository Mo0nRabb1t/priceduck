 import 'package:flutter/cupertino.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';
 import '../../providers/records_provider.dart';
 import '../../models/price_record.dart';
 import '../../models/product_unit.dart';
 import '../../widgets/unit_price_chip.dart';
 import '../../theme/app_theme.dart';
 
 /// 文字录入表单（语音回填已移除 V1.1）
 class RecordForm extends ConsumerStatefulWidget {
   const RecordForm({super.key});
 
   @override
   ConsumerState<RecordForm> createState() => _RecordFormState();
 }
 
 class _RecordFormState extends ConsumerState<RecordForm> {
   final _storeCtrl = TextEditingController();
   final _productCtrl = TextEditingController();
   final _priceCtrl = TextEditingController();
   final _qtyCtrl = TextEditingController();
   ProductUnit _selectedUnit = ProductUnit.kg;
 
   String? _productError;
   String? _priceError;
   String? _qtyError;
 
   @override
   void dispose() {
     _storeCtrl.dispose();
     _productCtrl.dispose();
     _priceCtrl.dispose();
     _qtyCtrl.dispose();
     super.dispose();
   }
 
   bool _validate() {
     setState(() {
       _productError = _productCtrl.text.trim().isEmpty ? '商品不能为空' : null;
       _priceError = null;
       _qtyError = null;
 
       final price = double.tryParse(_priceCtrl.text);
       if (price == null || price <= 0) _priceError = '价格必须 > 0';
       final qty = double.tryParse(_qtyCtrl.text);
       if (qty == null || qty <= 0) _qtyError = '数量必须 > 0';
     });
     return _productError == null && _priceError == null && _qtyError == null;
   }
 
   Future<void> _save() async {
     if (!_validate()) return;
 
     final repo = ref.read(recordRepositoryProvider);
     await repo.insertRecord(PriceRecord(
       store: _storeCtrl.text.trim().isEmpty
           ? null : _storeCtrl.text.trim(),
       product: _productCtrl.text.trim(),
       price: double.parse(_priceCtrl.text),
       quantity: double.parse(_qtyCtrl.text),
       unit: _selectedUnit,
       createdAt: DateTime.now(),
     ));
 
     // 清空表单
     _storeCtrl.clear();
     _productCtrl.clear();
     _priceCtrl.clear();
     _qtyCtrl.clear();
     setState(() {
       _selectedUnit = ProductUnit.kg;
       _productError = null;
       _priceError = null;
       _qtyError = null;
     });
 
     if (mounted) {
       showCupertinoDialog(
         context: context,
         builder: (ctx) => CupertinoAlertDialog(
           title: const Text('保存成功'),
           actions: [
             CupertinoDialogAction(
               child: const Text('确定'),
               onPressed: () => Navigator.of(ctx).pop(),
             ),
           ],
         ),
       );
     }
   }
 
   @override
   Widget build(BuildContext context) {
     final priceVal = double.tryParse(_priceCtrl.text) ?? 0;
     final qtyVal = double.tryParse(_qtyCtrl.text) ?? 0;
     final preview = ref.watch(unitPricePreviewProvider((
       price: priceVal,
       quantity: qtyVal,
       unit: _selectedUnit,
     )));
 
     return CupertinoFormSection(
       header: const Text('录入信息'),
       children: [
         // 超市（可选）
         CupertinoFormRow(
           label: const Text('超市'),
           child: CupertinoTextField(
             controller: _storeCtrl,
             placeholder: '可选，如 山姆',
           ),
         ),
         // 商品（必填）
         CupertinoFormRow(
           label: const Text('商品'),
           child: CupertinoTextField(
             controller: _productCtrl,
             placeholder: '如 鸡蛋',
           ),
         ),
         if (_productError != null)
           Padding(
             padding: const EdgeInsets.only(left: 16, bottom: 4),
             child: Text(_productError!,
                 style: const TextStyle(color: AppTheme.errorColor, fontSize: 12)),
           ),
         // 价格
         CupertinoFormRow(
           label: const Text('价格'),
           child: CupertinoTextField(
             controller: _priceCtrl,
             placeholder: '如 20',
             keyboardType: const TextInputType.numberWithOptions(decimal: true),
           ),
         ),
         if (_priceError != null)
           Padding(
             padding: const EdgeInsets.only(left: 16, bottom: 4),
             child: Text(_priceError!,
                 style: const TextStyle(color: AppTheme.errorColor, fontSize: 12)),
           ),
         // 数量
         CupertinoFormRow(
           label: const Text('数量'),
           child: CupertinoTextField(
             controller: _qtyCtrl,
             placeholder: '如 2',
             keyboardType: const TextInputType.numberWithOptions(decimal: true),
           ),
         ),
         if (_qtyError != null)
           Padding(
             padding: const EdgeInsets.only(left: 16, bottom: 4),
             child: Text(_qtyError!,
                 style: const TextStyle(color: AppTheme.errorColor, fontSize: 12)),
           ),
         // 单位选择
         CupertinoFormRow(
           label: const Text('单位'),
           child: CupertinoButton(
             padding: EdgeInsets.zero,
             child: Text(_selectedUnit.symbol),
             onPressed: () => _showUnitPicker(),
           ),
         ),
         // 实时单价预览
         if (preview != null)
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             child: Row(
               children: [
                 const Text('单价: ', style: TextStyle(fontSize: 13)),
                 UnitPriceChip(label: preview.display, compact: true),
               ],
             ),
           ),
         // 保存按钮
         CupertinoFormRow(
           child: CupertinoButton.filled(
             child: const Text('保存'),
             onPressed: _save,
           ),
         ),
       ],
     );
   }
 
   void _showUnitPicker() {
     showCupertinoModalPopup(
       context: context,
       builder: (ctx) => _UnitPickerSheet(
         selected: _selectedUnit,
         onSelected: (unit) {
           setState(() => _selectedUnit = unit);
           Navigator.of(ctx).pop();
         },
       ),
     );
   }
 }
 
 class _UnitPickerSheet extends StatelessWidget {
   final ProductUnit selected;
   final ValueChanged<ProductUnit> onSelected;
 
   const _UnitPickerSheet({required this.selected, required this.onSelected});
 
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
