import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mocker_ai/Common/Theme/light_theme.dart';
import 'package:mocker_ai/firebase_options.dart';
import 'package:mocker_ai/routes/routes_pages.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future main() async {
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        title: 'Mocker',

        routerConfig: appRouter,
      ),
    );
  }
}
