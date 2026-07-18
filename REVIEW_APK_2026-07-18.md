# 代码复查 + APK 打包可行性评估（2026-07-18）

> 背景：用户要求 review 应用名/Logo 改动，若无问题则打包 APK 发送。
> 结论先行：**应用名 + Logo 代码改动无问题；但本沙箱环境无法打包 APK，已提供替代出包方案。**

---

## 一、代码复查结论（应用名 & 占位 Logo）

对照《新增设计书-应用名与Logo》逐条核验，开发已按设计书改好：

| 设计书要求 | 实际代码 | 状态 |
|-----------|---------|------|
| 应用显示名「计价鸭」（5 处） | `lib/main.dart:22`、`android/.../AndroidManifest.xml:3`、`ios/Runner/Info.plist:8(CFBundleDisplayName)`、`pubspec.yaml:2(description)`、`README.md:1` | ✅ |
| 包名保留 `priceduck` | `pubspec.yaml:1`、`Info.plist:16(CFBundleName)` | ✅（设计书明确要求保留） |
| 占位图复制进项目 | `assets/icons/priceduck.jpeg`（795KB，已存在） | ✅ |
| pubspec 声明 assets | `pubspec.yaml:30-31` | ✅ |
| launcher_icons 配置 | `pubspec.yaml:33-37` | ✅ |
| App 内导航栏 Logo（28×28） | `lib/pages/record/record_page.dart:20` `Image.asset('assets/icons/priceduck.jpeg', 28, 28)` | ✅ |
| 桌面启动图标 | 由 `flutter_launcher_icons` 生成（需在开发机跑命令，属打包步骤，非代码缺陷） | ⏳（见第二节） |

**代码侧结论：应用名 + Logo 改动全部符合设计书，无遗漏、无多余改动（未触碰数据层/比价/查询/折线图）。**

---

## 二、APK 打包可行性：本环境不可行

在 `E:\sourcecode\aicode` 所在沙箱执行环境探测，结果如下：

| 前置条件 | 探测结果 | 是否满足 |
|---------|---------|---------|
| 可用 Flutter SDK | 仅 `C:/Users/admin/.cache/flutter/flutter.zip`（65MB，损坏/截断，真实 SDK 压缩包 700MB+）；PATH 及全盘无 `flutter`/`dart` 可执行 | ❌ |
| Android SDK | `ANDROID_HOME`/`ANDROID_SDK_ROOT` 均空；`sdkmanager` 不在 PATH | ❌ |
| 网络（下载依赖） | `pub.dev` 不可达（curl 退出非零）；`storage.googleapis.com` 不可达 → `flutter pub get` 跑不通 | ❌ |
| Drift 生成代码 | `lib/**/*.g.dart` 全部缺失（未跑 `build_runner`） | ❌ |
| 依赖锁定 | 无 `pubspec.lock`、无 `.dart_tool`（从未 `pub get`） | ❌ |
| 签名 / Licences | 未配置（release 包需 keystore） | ❌ |
| 磁盘空间 | C 盘剩 45GB，够装 | ✅ |

**结论：本沙箱无法生成 APK 文件。** 这是环境工具链与网络限制，非代码缺陷。即使代码 100% 正确，缺少 Flutter SDK + Android SDK + 网络三条任一项都无法编译打包。

---

## 三、替代方案：在你/开发机器出包

前提：出包机器已安装 **Flutter 3.24+ / Dart 3.4+**、**Android SDK（含 platform-tools / build-tools / 对应 platform）**、**可联网**。

已提供两份交付：
- `Claw/docs/物价记录助手-APK打包指南.md` —— 完整步骤 + 前置自检 + 排错
- `aicode/build_apk.bat` —— 一键脚本（开发机双击运行）

最简命令序列（在 `aicode` 目录）：
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run flutter_launcher_icons          # 生成桌面启动图标（mipmap）
flutter build apk --debug                # 调试包，无需签名
# flutter build apk --release            # 正式包，需先配签名
```
产物：`build/app/outputs/flutter-apk/app-debug.apk`

---

## 四、待用户决策

- **A**：把出包交开发，在其机器执行 `build_apk.bat`，出包后直接发你（推荐，最省事）
- **B**：你本地装好 Flutter/Android SDK 后，用指南 + 脚本自行出包
- **C**：暂不出包，等开发联调 + 双平台验收后再出 release 包（最稳，避免反复打调试包）

> 注：本沙箱内 git 所有文件仍为未跟踪（`??`），你此前说"最后再确认 git"，此处不处理。
