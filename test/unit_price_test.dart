 import 'package:flutter_test/flutter_test.dart';
 import 'package:priceduck/utils/unit_price.dart';
 import 'package:priceduck/models/product_unit.dart';
 
 void main() {
   group('computeUnitPrice', () {
     test('(20, 2, kg) -> 10.00/kg', () {
       final result = computeUnitPrice(20, 2, ProductUnit.kg);
       expect(result.value, 10.0);
       expect(result.display, '¥10.00/kg');
     });
 
     test('(25, 2.25, kg) -> 11.11/kg', () {
       final result = computeUnitPrice(25, 2.25, ProductUnit.kg);
       expect(result.value, 11.11);
       expect(result.display, '¥11.11/kg');
     });
 
     test('(9.9, 4, piece) -> 2.48/个', () {
       final result = computeUnitPrice(9.9, 4, ProductUnit.piece);
       expect(result.display, '¥2.48/个');
     });
 
     test('(25, 1.5, l) -> 16.67/L', () {
       final result = computeUnitPrice(25, 1.5, ProductUnit.l);
       expect(result.display, '¥16.67/L');
     });
 
     test('(6, 500, g) -> 12.00/kg', () {
       final result = computeUnitPrice(6, 500, ProductUnit.g);
       expect(result.display, '¥12.00/kg');
     });
 
     test('(3, 300, ml) -> 10.00/L', () {
       final result = computeUnitPrice(3, 300, ProductUnit.ml);
       expect(result.display, '¥10.00/L');
     });
 
     test('quantity = 0 -> throws ArgumentError', () {
       expect(
         () => computeUnitPrice(10, 0, ProductUnit.kg),
         throwsArgumentError,
       );
     });
 
     test('piece axis is 个', () {
       final result = computeUnitPrice(5, 1, ProductUnit.piece);
       expect(result.axis, '个');
     });
   });
 }
