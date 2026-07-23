import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'pages/record/record_page.dart';
import 'pages/query/query_page.dart';

/// 应用壳层 - 底栏 emoji（🏠记录 / 🔍查询）
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  late final CupertinoTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController();
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    // 仅在 Tab 真正切换时收键盘；键盘弹起导致的重建不会触发此处
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        activeColor: AppTheme.primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: const Text('🏠', style: TextStyle(fontSize: 22)),
            label: '记录',
          ),
          BottomNavigationBarItem(
            icon: const Text('🔍', style: TextStyle(fontSize: 22)),
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
