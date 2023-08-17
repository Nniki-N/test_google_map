
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_google_map/presentation/app/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await SystemChrome.setSystemUIChangeCallback(
    (bool systemOverlaysAreVisible) async {
      if (!systemOverlaysAreVisible) {
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: [],
        );
      }
    },
  );

  runApp(const MyApp());
}
