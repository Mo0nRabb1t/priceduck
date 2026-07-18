 import 'package:flutter/cupertino.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';
 import 'theme/app_theme.dart';
 import 'pages/record/record_page.dart';
 import 'pages/query/query_page.dart';
 
 /// 应用壳层 - CupertinoTabScaffold 底部导航
 class AppShell extends ConsumerWidget {
   const AppShell({super.key});
 
   @override
   Widget build(BuildContext context, WidgetRef ref) {
     return CupertinoTabScaffold(
       tabBar: CupertinoTabBar(
         activeColor: AppTheme.primaryColor,
         items: const [
           BottomNavigationBarItem(
             icon: Icon(CupertinoIcons.doc_text),
             label: '记录',
           ),
           BottomNavigationBarItem(
             icon: Icon(CupertinoIcons.search),
             label: '查询',
           ),
         ],
       ),
       tabBuilder: (context, index) {
         switch (index) {
           case 0:
             return const RecordPage();
           case 1:
             return const QueryPage();
           default:
             return const RecordPage();
         }
       },
     );
   }
 }
