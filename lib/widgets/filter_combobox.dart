 import 'package:flutter/cupertino.dart';
 import '../theme/app_theme.dart';
 
 /// 可输入可选的下拉选择器（复用组件）
 ///
 /// - 带搜索过滤功能
 /// - 支持自由输入文本
 /// - 点击右侧 ▾ 按钮弹出选项列表
 class FilterComboBox extends StatelessWidget {
   final TextEditingController controller;
   final List<String> options;
   final String hintText;
   final ValueChanged<String>? onChanged;
 
   const FilterComboBox({
     super.key,
     required this.controller,
     required this.options,
     this.hintText = '',
     this.onChanged,
   });
 
   @override
   Widget build(BuildContext context) {
     return CupertinoTextField(
       controller: controller,
       placeholder: hintText,
       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
       decoration: BoxDecoration(
         color: CupertinoColors.white,
         borderRadius: BorderRadius.circular(10),
         border: Border.all(color: AppTheme.dividerColor.withAlpha(100)),
       ),
       suffix: GestureDetector(
         onTap: () => _showOptions(context),
         child: const Padding(
           padding: EdgeInsets.symmetric(horizontal: 8),
           child: Icon(
             CupertinoIcons.chevron_down,
             size: 18,
             color: AppTheme.textSecondary,
           ),
         ),
       ),
       onChanged: onChanged,
     );
   }
 
   void _showOptions(BuildContext context) {
     // 过滤当前输入
     final query = controller.text.toLowerCase();
     final filtered = options
         .where((o) => o.toLowerCase().contains(query))
         .toList();
 
     showCupertinoModalPopup(
       context: context,
       builder: (context) => _OptionsSheet(
         options: filtered,
         onSelected: (value) {
           controller.text = value;
           onChanged?.call(value);
           Navigator.of(context).pop();
         },
       ),
     );
   }
 }
 
 /// 选项弹出层
 class _OptionsSheet extends StatelessWidget {
   final List<String> options;
   final ValueChanged<String> onSelected;
 
   const _OptionsSheet({
     required this.options,
     required this.onSelected,
   });
 
   @override
   Widget build(BuildContext context) {
     return CupertinoPageScaffold(
       navigationBar: const CupertinoNavigationBar(
         middle: Text('选择'),
       ),
       child: SafeArea(
         child: options.isEmpty
             ? const Center(
                 child: Text('无匹配选项', style: TextStyle(color: AppTheme.textSecondary)))
             : ListView.builder(
                 itemCount: options.length,
                 itemBuilder: (context, index) {
                   final option = options[index];
                   return CupertinoListTile(
                     title: Text(option),
                     onTap: () => onSelected(option),
                   );
                 },
               ),
       ),
     );
   }
 }
