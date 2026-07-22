/// 商品计量单位枚举
enum ProductUnit { g, kg, ml, l, piece }

/// ProductUnit 扩展方法
extension ProductUnitX on ProductUnit {
  /// 显示符号
  String get symbol {
    switch (this) {
      case ProductUnit.g:
        return 'g';
      case ProductUnit.kg:
        return 'kg';
      case ProductUnit.ml:
        return 'ml';
      case ProductUnit.l:
        return 'L';
      case ProductUnit.piece:
        return '个';
    }
  }

  /// 归一化轴（用于单价展示）
  String get axis {
    switch (this) {
      case ProductUnit.g:
      case ProductUnit.kg:
        return 'kg';
      case ProductUnit.ml:
      case ProductUnit.l:
        return 'L';
      case ProductUnit.piece:
        return '个';
    }
  }

  /// 带中文标签的展示名称（用于 Picker 选项和已选展示）
  String get displayLabel {
    switch (this) {
      case ProductUnit.g:
        return 'g (克)';
      case ProductUnit.kg:
        return 'kg (千克)';
      case ProductUnit.ml:
        return 'ml (毫升)';
      case ProductUnit.l:
        return 'L (升)';
      case ProductUnit.piece:
        return '个';
    }
  }

  /// 所有可选项的中文展示列表
  static List<String> get displayLabels =>
      ProductUnit.values.map((u) => u.displayLabel).toList();
}

/// 根据符号字符串解析为单位枚举（顶层函数，避免被误判为枚举构造器）
ProductUnit? parseProductUnit(String s) {
  for (final unit in ProductUnit.values) {
    if (unit.symbol == s) return unit;
  }
  return null;
}
