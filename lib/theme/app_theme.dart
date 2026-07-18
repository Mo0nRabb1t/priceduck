 import 'package:flutter/cupertino.dart';
 
 /// 应用主题常量
 /// Cupertino 风格，主色 #007aff
 class AppTheme {
   AppTheme._();
 
   /// 主色调
   static const Color primaryColor = Color(0xFF007AFF);
 
   /// 卡片圆角
   static const double cardRadius = 14.0;
 
   /// 三级文字色阶
   static const Color textPrimary = Color(0xFF000000);
   static const Color textSecondary = Color(0xFF8E8E93);
   static const Color textTertiary = Color(0xFFC7C7CC);
 
   /// 背景色
   static const Color backgroundLight = Color(0xFFF2F2F7);
   static const Color cardBackground = Color(0xFFFFFFFF);
 
   /// 毛玻璃底色
   static const Color frostedGlass = Color(0xE5F2F2F7);
 
   /// 分割线色
   static const Color dividerColor = Color(0xFFC6C6C8);
 
   /// 错误色
   static const Color errorColor = Color(0xFFFF3B30);
 
   /// 构建 CupertinoThemeData
   static CupertinoThemeData buildTheme() {
     return const CupertinoThemeData(
       bright: Brightness.light,
       primaryColor: primaryColor,
       scaffoldBackgroundColor: backgroundLight,
       barBackgroundColor: Color(0xE5F9F9F9),
       textTheme: CupertinoTextThemeData(
         primaryColor: primaryColor,
         textStyle: TextStyle(color: textPrimary),
       ),
     );
   }
 }
