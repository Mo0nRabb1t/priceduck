 # 计价鸭（Priceduck）- 离线比价 App
 
 离线比价 App，Flutter 开发，Cupertino 风格。
 
 ## 技术栈
 
 - Flutter 3.24+ / Dart 3.4+
 - **状态管理**: Riverpod
 - **数据库**: Drift (SQLite)
 - **图表**: fl_chart
 
 ## 快速开始
 
 ```bash
 # 1. 安装依赖
 flutter pub get
 
 # 2. 生成 Drift 代码
 dart run build_runner build
 
 # 3. 运行
 flutter run
 ```
 
 ## 项目结构
 
 ```
 lib/
   main.dart                     # 入口
   app_shell.dart                # CupertinoTabScaffold 壳层
   models/                       # 数据模型
     price_record.dart           # PriceRecord 类
     product_unit.dart           # ProductUnit 枚举
   database/                     # 数据层 (drift)
     app_database.dart           # 数据库单例
     tables/price_records.dart   # 表定义
     daos/price_record_dao.dart  # DAO
   repositories/                 # 仓库层
     record_repository.dart
     filter_options_repository.dart
   utils/                        # 领域层 (纯 Dart)
    unit_price.dart             # 单价换算
  providers/                    # Riverpod 状态管理
     records_provider.dart
     filter_options_provider.dart
   theme/app_theme.dart          # 主题
   widgets/                      # 公用组件
     filter_combobox.dart        # 可输可选下拉
     unit_price_chip.dart        # 单价气泡
   pages/
     record/                     # 记录页
     query/                      # 查询页
 ```
 
 ## 验收脚本
 
 1. 录入「山姆 20元/2kg 鸡蛋」「盒马 25元/2.25kg 鸡蛋」
 2. 查询「鸡蛋」→ 列表按单价升序：山姆(¥10.00/kg) 排盒马(¥11.11/kg) 之前
 3. 折线图展示单价趋势
 
 ## App 图标
 
 当前为占位图标。如需使用 `priceduck.jpeg` 生成正式图标：
 
 ```bash
 # 安装 flutter_launcher_icons
 flutter pub add --dev flutter_launcher_icons
 # 运行
 dart run flutter_launcher_icons
 ```
