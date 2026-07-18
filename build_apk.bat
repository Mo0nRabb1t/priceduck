@echo off
REM ============================================================
REM  计价鸭 (Priceduck) APK 一键打包脚本
REM  运行环境: Windows + 已安装 Flutter 3.24+ / Android SDK / 可联网
REM  用法: 双击本文件，或在 aicode 目录执行 build_apk.bat
REM ============================================================
cd /d %~dp0

echo [1/4] 拉取依赖 (flutter pub get)
call flutter pub get || goto :err

echo [2/4] 生成 Drift 代码 (build_runner)
call dart run build_runner build --delete-conflicting-outputs || goto :err

echo [3/4] 生成桌面启动图标 (flutter_launcher_icons)
call dart run flutter_launcher_icons || goto :err

echo [4/4] 打包 APK (debug, 无需签名)
call flutter build apk --debug || goto :err

echo.
echo ===== 打包完成 =====
echo 产物: %cd%\build\app\outputs\flutter-apk\app-debug.apk
goto :end

:err
echo.
echo !!! 打包失败，请查看上方错误信息 !!!
pause
exit /b 1

:end
pause
