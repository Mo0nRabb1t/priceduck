 import 'package:flutter/cupertino.dart';
 import 'record_form.dart';
 import 'record_list.dart';
 
 /// 记录页面 - 表单固定页首，列表占剩余空间滚动（去掉 SingleChildScrollView 包裹）
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
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Image.asset('assets/icons/priceduck.jpeg',
                width: 28, height: 28),
          ),
          middle: const Text('物价记录'),
       ),
       child: SafeArea(
         child: Column(
           children: [
             // 表单固定页首（无滚动包裹）
             const RecordForm(),
            // 分隔
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(height: 1,
                  color: CupertinoColors.systemGrey.withAlpha(76)),
            ),
             // 列表占剩余空间，内部可滚动
             const Expanded(
               child: RecordList(),
             ),
           ],
         ),
       ),
     );
   }
 }
