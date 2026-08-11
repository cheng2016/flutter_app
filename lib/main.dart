import 'package:flutter/material.dart';

import 'app/app_controller.dart';
import 'app/namora_app.dart';
import 'core/services/preferences_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = AppController(
    repository: LocalPreferencesRepository(),
  );
  await controller.initialize();
  runApp(NamoraApp(controller: controller));
}
