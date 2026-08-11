import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../theme/app_theme.dart';

class GradientPage extends StatelessWidget {
  const GradientPage({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const <Color>[Color(0xFF19162A), AppColors.night]
              : const <Color>[Color(0xFFF0EBFF), Color(0xFFFFF7F3)],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}

class NamoraHeader extends StatelessWidget {
  const NamoraHeader({
    required this.onLanguagePressed,
    this.trailing,
    super.key,
  });

  final VoidCallback onLanguagePressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 12, 6),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[AppColors.violet, AppColors.coral],
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(
            strings.appName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(),
          if (trailing != null) trailing!,
          IconButton(
            key: const Key('languageButton'),
            tooltip: strings.language,
            onPressed: onLanguagePressed,
            icon: const Icon(Icons.language_rounded),
          ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Icon(
                    icon,
                    size: 38,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                FilledButton.tonalIcon(
                  onPressed: onAction,
                  icon: const Icon(Icons.explore_rounded),
                  label: Text(actionLabel),
                ),
              ],
            ),
          ),
        ),
      );
}
