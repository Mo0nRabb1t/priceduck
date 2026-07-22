import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/records_provider.dart';
import '../../models/price_record.dart';
import '../../models/product_unit.dart';
import '../../utils/unit_price.dart';
import '../../theme/app_theme.dart';

/// 录入表单 — B1/O2/O3/O4/O5 修复
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
  String? _storeError;
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
      _storeError = _storeCtrl.text.trim().isEmpty ? '超市不能为空' : null;
      _productError = _productCtrl.text.trim().isEmpty ? '商品不能为空' : null;
      _priceError = null;
      _qtyError = null;
      final price = double.tryParse(_priceCtrl.text);
      if (price == null || price <= 0) _priceError = '价格必须 > 0';
      final qty = double.tryParse(_qtyCtrl.text);
      if (qty == null || qty <= 0) _qtyError = '数量必须 > 0';
    });
    return _storeError == null &&
        _productError == null &&
        _priceError == null &&
        _qtyError == null;
  }

  Future<void> _save() async {
    if (!_validate()) return;
    final repo = ref.read(recordRepositoryProvider);
    await repo.insertRecord(PriceRecord(
      store: _storeCtrl.text.trim(),
      product: _productCtrl.text.trim(),
      price: double.parse(_priceCtrl.text),
      quantity: double.parse(_qtyCtrl.text),
      unit: _selectedUnit,
      createdAt: DateTime.now(),
    ));
    _storeCtrl.clear();
    _productCtrl.clear();
    _priceCtrl.clear();
    _qtyCtrl.clear();
    setState(() {
      _selectedUnit = ProductUnit.kg;
      _storeError = null;
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
      price: priceVal, quantity: qtyVal, unit: _selectedUnit,
    )));

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField('超市', _storeCtrl, '如：山姆'),
          if (_storeError != null) _buildError(_storeError!),
          _buildField('商品', _productCtrl, '如：鸡蛋'),
          if (_productError != null) _buildError(_productError!),
          _buildField('价格', _priceCtrl, '如：20', decimal: true),
          if (_priceError != null) _buildError(_priceError!),
          _buildField('数量', _qtyCtrl, '如：2', decimal: true),
          if (_qtyError != null) _buildError(_qtyError!),
          _buildUnitField(),
          if (preview != null) _buildPreview(preview),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              child: const Text('保存'),
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController c, String ph,
      {bool decimal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary)),
          ),
          CupertinoTextField(
            controller: c,
            placeholder: ph,
            keyboardType: decimal
                ? const TextInputType.numberWithOptions(decimal: true)
                : null,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              border: Border.all(color: AppTheme.dividerColor, width: 2),
              borderRadius: BorderRadius.circular(AppTheme.inputRadius),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text('单位',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary)),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: const Color(0xFFF5F5F7),
            borderRadius: BorderRadius.circular(AppTheme.inputRadius),
            child: Row(
              children: [
                Text(_selectedUnit.displayLabel,
                    style: const TextStyle(
                        fontSize: 17, color: AppTheme.textPrimary)),
                const Spacer(),
                const Icon(CupertinoIcons.chevron_down,
                    size: 16, color: AppTheme.textSecondary),
              ],
            ),
            onPressed: _showUnitPicker,
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(UnitPriceResult preview) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const Text('单价: ',
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
          Text(preview.display,
              style: AppTheme.priceTextStyle.copyWith(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildError(String msg) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 8),
      child: Text(msg,
          style: const TextStyle(color: AppTheme.errorColor, fontSize: 12)),
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

/// 单位选择器 — B1 修复：用 ListView 替代 CupertinoPicker
class _UnitPickerSheet extends StatelessWidget {
  final ProductUnit selected;
  final ValueChanged<ProductUnit> onSelected;
  const _UnitPickerSheet({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      color: CupertinoColors.systemBackground,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            CupertinoButton(
              child: const Text('完成',
                  style: TextStyle(color: AppTheme.primaryColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
           ],
          ),
        ),
        Container(height: 0.5, color: AppTheme.dividerColor),
        Expanded(
          child: ListView.builder(
            itemCount: ProductUnit.values.length,
            itemBuilder: (context, index) {
              final unit = ProductUnit.values[index];
              final isSelected = unit == selected;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelected(unit),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  color: isSelected
                      ? AppTheme.primaryColor.withAlpha(25)
                      : CupertinoColors.white,
                  child: Row(
                    children: [
                      Text(unit.displayLabel,
                          style: TextStyle(
                            fontSize: 17,
                            color: isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          )),
                      const Spacer(),
                      if (isSelected)
                        const Icon(CupertinoIcons.checkmark,
                            color: AppTheme.primaryColor, size: 18),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
