# Namora

本地离线的品牌命名灵感 App（Flutter）。

应用显示名与包名均为 **Namora**（`pubspec.yaml` 中为 `namora`，Android/iOS 包标识 `app.namora.mobile`）。仓库目录仍可能叫 `flutter_app`，不影响应用名称。

## 它做什么

选择**行业**和**风格**后，按规则组合英文词，每次生成 6 个候选名。可收藏、查看历史、复制到剪贴板、调用系统分享。数据存在本机，无账号、无网络请求。

名称来自 `english_words` 词库 + 行业词缀/风格模板，**不是 AI 起名**，也不做域名或商标查询。

## 功能明细

| 能力 | 说明 |
|------|------|
| 行业筛选 | 科技 / 生活方式 / 健康 / 金融 / 创意 |
| 风格筛选 | 现代 / 有趣 / 优雅 / 大胆 |
| 生成 | 「生成灵感」刷新一组；切换行业或风格会重新生成 |
| 收藏 | 爱心切换；收藏页可回看；本地持久化 |
| 历史 | 最近生成记录（上限约 60 条）；可清空 |
| 复制 / 分享 | 复制名称；系统分享面板（附 Namora 文案） |
| 语言 | 界面中英切换（品牌名本身仍为英文） |
| 主题 | 跟随系统浅色/深色；尊重「减少动态效果」 |

底部三个入口：**发现**、**收藏**、**历史**。

## 技术要点

- Flutter 3.38.1+ / Dart 3.10+
- 状态：`ChangeNotifier`（`AppController`）
- 持久化：`shared_preferences`
- 分享：`share_plus`
- 词库：`english_words`
- 平台：Android（minSdk 24）与 iOS（13.0+）；未做 Web/桌面

## 目录

```text
lib/
├── main.dart                 # 入口：初始化仓储与 AppController
├── app/                      # NamoraApp、导航壳、全局状态
├── core/
│   ├── localization/         # 中英文界面文案（AppStrings）
│   ├── models/               # BrandName、行业与风格枚举
│   ├── services/             # 生成器、本地 Preferences 仓储
│   ├── theme/                # 浅色/深色主题
│   └── widgets/              # 头部、卡片、空状态、复制分享
└── features/
    ├── generator/            # 发现页（英雄区 + 筛选 + 生成）
    ├── favorites/            # 收藏页
    └── history/              # 历史页
```

## 本地运行

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter run
```

若 Android Gradle wrapper 缺失，可先执行：

```bash
flutter create . --platforms=android,ios
```

再检查 diff，避免覆盖本仓库已改的包名、启动页与 Manifest。

上架前需替换 release 签名；iOS 真机构建需在 macOS + Xcode 上验证。

## 截图

建议补充：发现页、收藏页、深色模式各一张。当前仓库未附真机截图。

## License

Apache License 2.0.
