import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ndoujin/model/theme.dart';
import 'package:ndoujin/screen/home.dart';
import 'package:ndoujin/theme.dart';
import 'package:ndoujin/utils/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final setting =
      ThemeSettings(sourceColor: Colors.red, themeMode: ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ndoujin',
        theme:
            ThemeProvider(settings: setting, darkDynamic: darkDynamic).dark(),
        home: const HomeScreen(),
      ),
    );
  }
}
