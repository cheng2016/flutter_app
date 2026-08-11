import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localization/app_strings.dart';
import '../models/brand_name.dart';
import '../theme/app_theme.dart';

class BrandNameCard extends StatelessWidget {
  const BrandNameCard({
    required this.name,
    required this.isFavorite,
    required this.onFavorite,
    required this.onCopy,
    required this.onShare,
    this.animationIndex = 0,
    super.key,
  });

  final BrandName name;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final int animationIndex;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion
        ? Duration.zero
        : Duration(milliseconds: 240 + animationIndex.clamp(0, 5) * 55);

    return TweenAnimationBuilder<double>(
      key: ValueKey(name.value),
      duration: duration,
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: child,
        ),
      ),
      child: Semantics(
        container: true,
        label:
            '${name.value}, ${strings.industryName(name.industry)}, ${strings.styleName(name.style)}',
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.fromLTRB(20, 18, 12, 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .outlineVariant
                  .withValues(alpha: .45),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.violet.withValues(alpha: .08),
                blurRadius: 26,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      name.value,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  _ActionIcon(
                    tooltip: strings.copy,
                    icon: Icons.content_copy_rounded,
                    onPressed: onCopy,
                  ),
                  _ActionIcon(
                    tooltip: strings.share,
                    icon: Icons.ios_share_rounded,
                    onPressed: onShare,
                  ),
                  Semantics(
                    button: true,
                    label: isFavorite ? strings.unsave : strings.save,
                    child: IconButton(
                      key: Key('favorite-${name.value}'),
                      tooltip: isFavorite ? strings.unsave : strings.save,
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        onFavorite();
                      },
                      icon: AnimatedSwitcher(
                        duration: reduceMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 220),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          key: ValueKey(isFavorite),
                          color: isFavorite ? AppColors.coral : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: <Widget>[
                  _Tag(label: strings.industryName(name.industry)),
                  _Tag(label: strings.styleName(name.style)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: tooltip,
        child: IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          icon: Icon(icon, size: 21),
        ),
      );
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withValues(alpha: .55),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}
