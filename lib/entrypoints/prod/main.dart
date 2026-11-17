import 'package:flutter/material.dart';
import 'package:ticboom/app.dart';
import 'package:ticboom/core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const config = AppConfig(
    environment: 'prod',
    displayName: 'TicBoom',
    baseUrl: 'http://localhost:8080',
    routerShape: 'root',
  );
  await bootstrapApp(config: config);
}
