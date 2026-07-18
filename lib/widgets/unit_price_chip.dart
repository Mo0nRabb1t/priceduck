 import 'package:flutter/cupertino.dart';
 import '../theme/app_theme.dart';
 
 /// 单价展示气泡组件
 class UnitPriceChip extends StatelessWidget {
   final String label;
   final bool compact;
 
   const UnitPriceChip({
     super.key,
     required this.label,
     this.compact = false,
   });
 
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.symmetric(
         horizontal: compact ? 6 : 10,
         vertical: compact ? 2 : 4,
       ),
       decoration: BoxDecoration(
         color: AppTheme.primaryColor.withAlpha(25),
         borderRadius: BorderRadius.circular(12),
       ),
       child: Text(
         label,
         style: TextStyle(
           color: AppTheme.primaryColor,
           fontSize: compact ? 12 : 13,
           fontWeight: FontWeight.w600,
         ),
       ),
     );
   }
 }
