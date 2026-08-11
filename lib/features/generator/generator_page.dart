import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_controller.dart';
import '../../core/localization/app_strings.dart';
import '../../core/models/brand_name.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_chrome.dart';
import '../../core/widgets/brand_name_card.dart';
import '../../core/widgets/name_actions.dart';

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return GradientPage(
      child: CustomScrollView(
        key: const PageStorageKey<String>('generator'),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: NamoraHeader(
              onLanguagePressed: controller.toggleLanguage,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            sliver: SliverList.list(
              children: <Widget>[
                _Hero(strings: strings),
                const SizedBox(height: 28),
                _FilterGroup<BrandIndustry>(
                  title: strings.industry,
                  values: BrandIndustry.values,
                  selected: controller.industry,
                  labelFor: strings.industryName,
                  onSelected: controller.selectIndustry,
                ),
                const SizedBox(height: 20),
                _FilterGroup<BrandStyle>(
                  title: strings.style,
                  values: BrandStyle.values,
                  selected: controller.style,
                  labelFor: strings.styleName,
                  onSelected: controller.selectStyle,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  key: const Key('generateButton'),
                  onPressed: controller.isGenerating
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          controller.generate();
                        },
                  icon: controller.isGenerating
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Icon(Icons.auto_awesome_rounded),
                  label: Text(
                    controller.isGenerating
                        ? strings.generating
                        : strings.generate,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: <Widget>[
                    Text(
                      strings.freshIdeas,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lemon.withValues(alpha: .34),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        '${controller.suggestions.length}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AnimatedSwitcher(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 280),
                  child: Column(
                    key: ValueKey(
                      controller.suggestions.map((item) => item.value).join(),
                    ),
                    children: <Widget>[
                      for (final (index, name)
                          in controller.suggestions.indexed)
                        BrandNameCard(
                          name: name,
                          animationIndex: index,
                          isFavorite: controller.isFavorite(name),
                          onFavorite: () => NameActions.toggleFavorite(
                            context,
                            controller,
                            name,
                          ),
                          onCopy: () => NameActions.copy(context, name),
                          onShare: () => NameActions.share(context, name),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: .9),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .outlineVariant
                .withValues(alpha: .45),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: -22,
              top: -34,
              child: Container(
                width: 115,
                height: 115,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: <Color>[
                      AppColors.coral.withValues(alpha: .45),
                      AppColors.lemon.withValues(alpha: .3),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  strings.tagline,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .2,
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Text(
                    strings.heroTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Text(
                    strings.heroBody,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _FilterGroup<T> extends StatelessWidget {
  const _FilterGroup({
    required this.title,
    required this.values,
    required this.selected,
    required this.labelFor,
    required this.onSelected,
  });

  final String title;
  final List<T> values;
  final T selected;
  final String Function(T) labelFor;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final value in values)
                ChoiceChip(
                  label: Text(labelFor(value)),
                  selected: value == selected,
                  onSelected: (_) => onSelected(value),
                ),
            ],
          ),
        ],
      );
}
