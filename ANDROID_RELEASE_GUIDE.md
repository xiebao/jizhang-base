# Android AAB 发布指南

## 准备工作

### 1. 签名密钥
- 已生成签名密钥文件：`android/keystore/mathfish.jks`
- 密钥别名：`mathfish`
- 密钥密码：`mathfish123`
- 有效期：10000天

### 2. 应用信息
- 应用ID：`com.jizhang.goodgood`
- 应用名称：`NGTmathFish`
- 当前版本：`1.0.6+6`

## 构建AAB文件

### 方法一：使用构建脚本（推荐）
```bash
./build_aab.sh
```

### 方法二：手动构建
```bash
# 清理项目
flutter clean

# 获取依赖
flutter pub get

# 生成图标
flutter pub run flutter_launcher_icons:main

# 构建AAB
flutter build appbundle --release
```

## 输出文件
构建完成后，AAB文件位于：
```
build/app/outputs/bundle/release/app-release.aab
```

## 上传到Google Play

1. 登录 [Google Play Console](https://play.google.com/console)
2. 选择您的应用
3. 进入"发布" > "应用包"
4. 上传 `app-release.aab` 文件
5. 填写版本说明
6. 提交审核

## 重要提醒

### 密钥安全
- 请妥善保管 `mathfish.jks` 密钥文件
- 密钥密码：`mathfish123`
- 建议将密钥文件备份到安全位置

### 版本更新
- 每次发布新版本时，需要更新 `pubspec.yaml` 中的版本号
- 版本格式：`version: x.y.z+build_number`
- 例如：`version: 1.0.7+7`

### 测试
- 发布前请充分测试应用功能
- 确保所有权限配置正确
- 验证网络功能正常

## 故障排除

### 构建失败
1. 检查Flutter环境：`flutter doctor`
2. 清理项目：`flutter clean`
3. 重新获取依赖：`flutter pub get`

### 签名问题
1. 确认密钥文件存在：`android/keystore/mathfish.jks`
2. 检查密钥密码是否正确
3. 验证密钥别名：`mathfish`

### 权限问题
- 确保 `AndroidManifest.xml` 包含必要权限
- 网络权限：`INTERNET`, `ACCESS_NETWORK_STATE`

## 联系支持
如有问题，请检查：
1. Flutter版本兼容性
2. Android SDK版本
3. 依赖包版本
