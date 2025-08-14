# iPhone Only Configuration

## 概述
此文档说明如何配置FirstMathFish应用只支持iPhone设备，而不支持iPad。

## 修改的文件

### 1. Info.plist (ios/Runner/Info.plist)
**修改内容：**
- 移除了 `UISupportedInterfaceOrientations~ipad` 配置
- 添加了 `UIRequiresFullScreen` 设置为 `true`
- 添加了 `UIDeviceFamily` 设置为只包含 `1` (iPhone)

**具体修改：**
```xml
<!-- 移除了iPad支持 -->
<!-- <key>UISupportedInterfaceOrientations~ipad</key> -->

<!-- 添加了全屏要求 -->
<key>UIRequiresFullScreen</key>
<true/>

<!-- 只支持iPhone -->
<key>UIDeviceFamily</key>
<array>
    <integer>1</integer>
</array>
```

### 2. project.pbxproj (ios/Runner.xcodeproj/project.pbxproj)
**修改内容：**
- 将所有 `TARGETED_DEVICE_FAMILY` 从 `"1,2"` 改为 `1`
- 确保 `SUPPORTED_PLATFORMS` 设置为 `iphoneos`

**具体修改：**
```
TARGETED_DEVICE_FAMILY = 1;  // 只支持iPhone (1)，不支持iPad (2)
SUPPORTED_PLATFORMS = iphoneos;  // 只支持iOS设备
```

## 设备支持说明

### UIDeviceFamily 值说明：
- `1` = iPhone
- `2` = iPad  
- `1,2` = iPhone + iPad

### 当前配置：
- ✅ 只支持 iPhone (UIDeviceFamily = 1)
- ❌ 不支持 iPad (移除了iPad相关配置)
- ✅ 支持横屏和竖屏方向
- ✅ 要求全屏显示

## 验证方法

1. **构建验证：**
   ```bash
   flutter build ios --no-codesign
   ```

2. **Xcode验证：**
   - 打开 Xcode
   - 选择项目设置
   - 在 "General" 标签页中查看 "Deployment Info"
   - 确认 "Devices" 只显示 "iPhone"

3. **App Store Connect验证：**
   - 上传应用到 App Store Connect
   - 在应用信息中确认设备支持只显示 iPhone

## 优势

1. **避免iPad审核问题：** 不会因为iPad适配问题被拒绝
2. **简化开发：** 不需要为iPad设计专门的UI
3. **减少测试：** 只需要在iPhone上测试
4. **更快的审核：** 减少了审核复杂度

## 注意事项

1. **用户期望：** 用户可能期望应用在iPad上也能运行
2. **市场限制：** 无法在iPad App Store中展示
3. **兼容性：** 在iPad上会以iPhone兼容模式运行（小屏幕居中显示）

## 恢复iPad支持

如果需要重新支持iPad，需要：
1. 将 `UIDeviceFamily` 改回 `"1,2"`
2. 恢复 `UISupportedInterfaceOrientations~ipad` 配置
3. 移除 `UIRequiresFullScreen` 配置
4. 为iPad设计响应式UI布局
