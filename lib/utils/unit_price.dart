 import '../models/product_unit.dart';
 
 /// 单价换算结果
 class UnitPriceResult {
   /// 已归一化值，如 10.0
   final double value;
 
   /// 归一化轴，如 'kg', 'L', '个'
   final String axis;
 
   const UnitPriceResult(this.value, this.axis);
 
   /// 标签
   String get label => '元/$axis';
 
   /// 展示文本，如 ¥10.00/kg
 String get display => '¥${valueDisplay}/$axis';
 
   /// 仅数值部分，如 "10.00"
   String get valueDisplay => _round2(value).toStringAsFixed(2);
 }
 
 /// 计算单条记录的归一化单价
 ///
 /// [price] 录入价格
 /// [quantity] 数量/包装规格
 /// [unit] 单位枚举
 /// 抛出 [ArgumentError] 当 quantity <= 0
 UnitPriceResult computeUnitPrice(
     double price, double quantity, ProductUnit unit) {
   if (quantity <= 0) {
     throw ArgumentError('quantity 必须 > 0');
   }
 
   final perUnit = price / quantity;
 
   // 归一化因子
   double factor;
   switch (unit) {
     case ProductUnit.g:
       factor = 1000.0;
     case ProductUnit.kg:
       factor = 1.0;
     case ProductUnit.ml:
       factor = 1000.0;
     case ProductUnit.l:
       factor = 1.0;
     case ProductUnit.piece:
       factor = 1.0;
   }
 
   return UnitPriceResult(_round2(perUnit * factor), unit.axis);
 }
 
 /// 确定性保留 2 位小数，避免浮点 tie 误差
 double _round2(double v) => (v * 100).round() / 100;
 
 // ===== 单测用例（QA 验收表）=====
 // (20, 2, kg)     -> ¥10.00/kg
 // (25, 2.25, kg)  -> ¥11.11/kg
 // (9.9, 4, piece) -> ¥2.48/个
 // (25, 1.5, l)    -> ¥16.67/L
 // (6, 500, g)     -> ¥12.00/kg
 // (3, 300, ml)    -> ¥10.00/L
 // (price, 0, kg)  -> ArgumentError
