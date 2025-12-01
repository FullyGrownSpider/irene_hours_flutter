import 'package:flutter/material.dart';
import 'package:irene_hours/screen/base_screen.dart';
import 'package:irene_hours/translations.dart';
import 'package:window_manager/window_manager.dart';

late final ValueNotifier<int> notifier;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dutch(); //TODO better spot

  await windowManager.ensureInitialized();

  Size s = Size (900, 600);
  WindowOptions windowOptions = WindowOptions(
    size: s,
    center: true,
    title: 'Irene Uren',
    backgroundColor: Colors.grey,
    maximumSize: s,
    minimumSize: s,
    skipTaskbar: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MaterialApp(home: BaseScreen(), debugShowCheckedModeBanner: false));
}
