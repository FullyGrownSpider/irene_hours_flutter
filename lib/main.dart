import 'package:flutter/material.dart';
import 'package:irene_hours/loading/loading.dart';
import 'package:irene_hours/screen/base_screen.dart';
import 'package:irene_hours/translations.dart';
import 'package:window_manager/window_manager.dart';

late final ValueNotifier<int> notifier;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pickLang(await Loading().getLang());

  await windowManager.ensureInitialized();

  Size s = Size (600, 450);
  WindowOptions windowOptions = WindowOptions(
    size: s,
    center: true,
    title: 'Irene Uren',
    backgroundColor: Colors.grey,
    minimumSize: s,//TODO
    skipTaskbar: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MaterialApp(home: BaseScreen(), debugShowCheckedModeBanner: false));
}
