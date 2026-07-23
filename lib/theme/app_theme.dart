import 'package:flutter/cupertino.dart';

/// 应用主题常量（对齐 HTML 原型 Design Token）
class AppTheme {
  AppTheme._();

  // 颜色 (贴原型)
  static const Color primaryColor = Color(0xFF3399FF);
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color backgroundLight = Color(0xFFFFFAA8);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1D1D1F);
  static const Color textSecondary = Color(0xFF86868B);
  static const Color textTertiary = Color(0xFFAEAEB2);
  static const Color dividerColor = Color(0xFFE5E5EA);

  // 圆角/阴影 (新增)
  static const double cardRadius = 14.0;
  static const double inputRadius = 12.0;
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x14000000), blurRadius: 3, offset: Offset(0, 1)),
  ];

  // 价格红字样式
  static const TextStyle priceTextStyle = TextStyle(
    color: errorColor, fontSize: 20, fontWeight: FontWeight.w700,
    fontFamily: 'DINAlternate',
  );
  static const TextStyle numberTextStyle = TextStyle(
    color: errorColor, fontSize: 20, fontWeight: FontWeight.w700,
    fontFamily: 'DINAlternate',
  );
  static const TextStyle numberPlainStyle = TextStyle(
    fontFamily: 'DINAlternate',
  );

  static CupertinoThemeData buildTheme() {
    return const CupertinoThemeData(
      brightness: Brightness.light,
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
