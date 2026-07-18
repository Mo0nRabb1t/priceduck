 import 'package:flutter/cupertino.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';
 import 'app_shell.dart';
 import 'theme/app_theme.dart';
 
 void main() {
   WidgetsFlutterBinding.ensureInitialized();
   runApp(
     const ProviderScope(
       child: PriceduckApp(),
     ),
   );
 }
 
 /// 物价记录助手 App
 class PriceduckApp extends StatelessWidget {
   const PriceduckApp({super.key});
 
   @override
   Widget build(BuildContext context) {
     return CupertinoApp(
       title: '计价鸭',
       theme: AppTheme.buildTheme(),
       home: const AppShell(),
     );
   }
 }
