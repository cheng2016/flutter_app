import 'package:flutter/material.dart';

import '../../app/app_controller.dart';
import '../../core/localization/app_strings.dart';
import '../../core/widgets/app_chrome.dart';
import '../../core/widgets/brand_name_card.dart';
import '../../core/widgets/name_actions.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return GradientPage(
      child: Column(
        children: <Widget>[
          NamoraHeader(
            onLanguagePressed: controller.toggleLanguage,
            trailing: _CountBadge(count: controller.favorites.length),
          ),
          Expanded(
            child: controller.favorites.isEmpty
                ? EmptyState(
                    icon: Icons.favorite_border_rounded,
                    title: strings.emptyFavoritesTitle,
                    body: strings.emptyFavoritesBody,
                    actionLabel: strings.goDiscover,
                    onAction: () => controller.selectNavigation(0),
                  )
                : ListView.builder(
                    key: const PageStorageKey<String>('favorites'),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    itemCount: controller.favorites.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Text(
                            strings.favorites,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        );
                      }
                      final name = controller.favorites[index - 1];
                      return BrandNameCard(
                        name: name,
                        animationIndex: index - 1,
                        isFavorite: true,
                        onFavorite: () => NameActions.toggleFavorite(
                          context,
                          controller,
                          name,
                        ),
                        onCopy: () => NameActions.copy(context, name),
                        onShare: () => NameActions.share(context, name),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          '$count',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      );
}
