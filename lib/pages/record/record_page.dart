import 'package:flutter/cupertino.dart';
import 'record_form.dart';
import 'record_list.dart';
import '../../theme/app_theme.dart';

/// 记录页 — O1: 整体可滚动，O6: 点击空白收起键盘
class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('物价记录'),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          final scope = FocusScope.of(context);
          if (!scope.hasPrimaryFocus && scope.focusedChild != null) {
            scope.unfocus();
          }
        },
        child: SafeArea(
          child: ListView(
            children: [
              const RecordForm(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(height: 1,
                    color: CupertinoColors.systemGrey.withAlpha(76)),
              ),
              const RecordList(),
            ],
          ),
        ),
      ),
    );
  }
}
