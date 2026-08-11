import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/app_controller.dart';
import '../localization/app_strings.dart';
import '../models/brand_name.dart';

abstract final class NameActions {
  static void copy(BuildContext context, BrandName name) {
    final strings = AppStrings.of(context);
    unawaited(Clipboard.setData(ClipboardData(text: name.value)));
    _showMessage(context, strings.copied);
  }

  static void share(BuildContext context, BrandName name) {
    final strings = AppStrings.of(context);
    final box = context.findRenderObject() as RenderBox?;
    unawaited(
      SharePlus.instance.share(
        ShareParams(
          text: '${name.value}\n\n${strings.madeWith}',
          subject: name.value,
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      ),
    );
  }

  static void toggleFavorite(
    BuildContext context,
    AppController controller,
    BrandName name,
  ) {
    final strings = AppStrings.of(context);
    final isSaved = controller.toggleFavorite(name);
    _showMessage(context, isSaved ? strings.saved : strings.removed);
  }

  static void _showMessage(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}
