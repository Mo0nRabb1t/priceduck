 import 'product_unit.dart';
 
 /// 物价记录数据模型
 /// store 为可选字段（违反锁定规格已修复）
 class PriceRecord {
   final int? id;
   final String? store;      // 改为可选
   final String product;
   final double price;
   final double quantity;
   final ProductUnit unit;
   final DateTime createdAt;
 
   const PriceRecord({
     this.id,
     this.store,             // 不再 required
     required this.product,
     required this.price,
     required this.quantity,
     required this.unit,
     required this.createdAt,
   });
 
   PriceRecord copyWith({
     int? id,
     String? store,
     String? product,
     double? price,
     double? quantity,
     ProductUnit? unit,
     DateTime? createdAt,
   }) {
     return PriceRecord(
       id: id ?? this.id,
       store: store ?? this.store,
       product: product ?? this.product,
       price: price ?? this.price,
       quantity: quantity ?? this.quantity,
       unit: unit ?? this.unit,
       createdAt: createdAt ?? this.createdAt,
     );
   }
 
   @override
   String toString() =>
       'PriceRecord(id=$id, store=$store, product=$product, '
       'price=$price, qty=$quantity, unit=${unit.symbol})';
 
   @override
   bool operator ==(Object other) =>
       identical(this, other) ||
       other is PriceRecord &&
           runtimeType == other.runtimeType &&
           id == other.id;
 
   @override
   int get hashCode => id.hashCode;
 }
