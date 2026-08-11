import 'package:flutter/material.dart';

import '../../app/app_controller.dart';
import '../../core/localization/app_strings.dart';
import '../../core/widgets/app_chrome.dart';
import '../../core/widgets/brand_name_card.dart';
import '../../core/widgets/name_actions.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return GradientPage(
      child: Column(
        children: <Widget>[
          NamoraHeader(
            onLanguagePressed: controller.toggleLanguage,
            trailing: controller.history.isEmpty
                ? null
                : IconButton(
                    tooltip: strings.clearHistory,
                    onPressed: () {
                      controller.clearHistory();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(strings.historyCleared),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_sweep_outlined),
                  ),
          ),
          Expanded(
            child: controller.history.isEmpty
                ? EmptyState(
                    icon: Icons.history_rounded,
                    title: strings.emptyHistoryTitle,
                    body: strings.emptyHistoryBody,
                    actionLabel: strings.goDiscover,
                    onAction: () => controller.selectNavigation(0),
                  )
                : ListView.builder(
                    key: const PageStorageKey<String>('history'),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    itemCount: controller.history.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Text(
                            strings.history,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        );
                      }
                      final name = controller.history[index - 1];
                      return BrandNameCard(
                        name: name,
                        animationIndex: index - 1,
                        isFavorite: controller.isFavorite(name),
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
