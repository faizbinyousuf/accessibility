import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:map_test/screens/home/view/home_view.dart';
import 'package:map_test/screens/home/view_model/home_view_model.dart';
import 'package:map_test/screens/landing/landing_view.dart';
import 'package:map_test/screens/offline_sync/model/task_model.dart';
import 'package:map_test/screens/offline_sync/view_model.dart/offline_view_model.dart';
import 'package:map_test/services/file_services/file_service.dart';
import 'package:map_test/services/hive_manager.dart';
import 'package:map_test/theme/theme.dart';
import 'package:map_test/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  HiveManager.initialize();
  // await Hive.openBox('tasksBox');
  await FileService().saveJsonData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => OfflineViewModel()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Builder(builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Test',
          theme: themeProvider.currentTheme,
          highContrastTheme: AppTheme.highContrastTheme,
          home: const LandingPage(),
        );
      }),
    );
  }
}
