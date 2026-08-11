import 'package:flutter/widgets.dart';

import '../models/brand_name.dart';

class AppStrings {
  const AppStrings(this.isChinese);

  final bool isChinese;

  static AppStrings of(BuildContext context) =>
      AppStrings(Localizations.localeOf(context).languageCode == 'zh');

  String get appName => 'Namora';
  String get tagline =>
      isChinese ? '好名字，让好创意被记住。' : 'Names made to be remembered.';
  String get heroTitle =>
      isChinese ? '找到那个\n让人眼前一亮的名字' : 'Find a name\nworth remembering';
  String get heroBody => isChinese
      ? '选择你的赛道与气质，一次生成一组可收藏、可分享的品牌灵感。'
      : 'Choose a space and a vibe. Get a fresh set of brand-ready ideas.';
  String get industry => isChinese ? '行业' : 'Industry';
  String get style => isChinese ? '风格' : 'Style';
  String get generate => isChinese ? '生成灵感' : 'Create names';
  String get generating => isChinese ? '正在酝酿…' : 'Mixing ideas…';
  String get freshIdeas => isChinese ? '本轮灵感' : 'Fresh ideas';
  String get favorites => isChinese ? '收藏' : 'Favorites';
  String get history => isChinese ? '历史' : 'History';
  String get discover => isChinese ? '发现' : 'Discover';
  String get copied => isChinese ? '已复制到剪贴板' : 'Copied to clipboard';
  String get saved => isChinese ? '已加入收藏' : 'Saved to favorites';
  String get removed => isChinese ? '已取消收藏' : 'Removed from favorites';
  String get copy => isChinese ? '复制名称' : 'Copy name';
  String get share => isChinese ? '分享名称' : 'Share name';
  String get save => isChinese ? '收藏名称' : 'Save name';
  String get unsave => isChinese ? '取消收藏' : 'Remove favorite';
  String get language => isChinese ? '切换为英文' : '切换为中文';
  String get emptyFavoritesTitle =>
      isChinese ? '你的灵感收藏夹还空着' : 'Your inspiration shelf is empty';
  String get emptyFavoritesBody => isChinese
      ? '发现喜欢的名字时点一下爱心，它就会出现在这里。'
      : 'Tap the heart on any name you love and it will appear here.';
  String get emptyHistoryTitle =>
      isChinese ? '还没有生成记录' : 'No names generated yet';
  String get emptyHistoryBody => isChinese
      ? '去发现页选择行业与风格，开启第一轮灵感。'
      : 'Choose an industry and style on Discover to start.';
  String get goDiscover => isChinese ? '去发现灵感' : 'Explore names';
  String get clearHistory => isChinese ? '清空历史' : 'Clear history';
  String get historyCleared => isChinese ? '历史已清空' : 'History cleared';
  String get madeWith =>
      isChinese ? '用 Namora 找到的品牌名' : 'A brand name found with Namora';

  String industryName(BrandIndustry value) {
    if (!isChinese) {
      return switch (value) {
        BrandIndustry.technology => 'Technology',
        BrandIndustry.lifestyle => 'Lifestyle',
        BrandIndustry.wellness => 'Wellness',
        BrandIndustry.finance => 'Finance',
        BrandIndustry.creative => 'Creative',
      };
    }
    return switch (value) {
      BrandIndustry.technology => '科技',
      BrandIndustry.lifestyle => '生活方式',
      BrandIndustry.wellness => '健康',
      BrandIndustry.finance => '金融',
      BrandIndustry.creative => '创意',
    };
  }

  String styleName(BrandStyle value) {
    if (!isChinese) {
      return switch (value) {
        BrandStyle.modern => 'Modern',
        BrandStyle.playful => 'Playful',
        BrandStyle.elegant => 'Elegant',
        BrandStyle.bold => 'Bold',
      };
    }
    return switch (value) {
      BrandStyle.modern => '现代',
      BrandStyle.playful => '有趣',
      BrandStyle.elegant => '优雅',
      BrandStyle.bold => '大胆',
    };
  }
}
