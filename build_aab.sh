#!/bin/bash

echo "开始构建生产环境AAB文件..."

# 清理之前的构建
echo "清理之前的构建..."
flutter clean

# 获取依赖
echo "获取依赖..."
flutter pub get

# 生成图标
echo "生成应用图标..."
flutter pub run flutter_launcher_icons:main

# 构建AAB文件
echo "构建AAB文件..."
flutter build appbundle --release

echo "AAB文件构建完成！"
echo "文件位置: build/app/outputs/bundle/release/app-release.aab"
echo "请将此文件上传到Google Play Console进行发布。"
