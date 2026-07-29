import "dart:io";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:my_beer_diary/screen/home.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "package:sqflite_common_ffi_web/sqflite_ffi_web.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final isWeb = kIsWeb;
  final isDesktop =
      !isWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

  if (isWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (isDesktop) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Můj pivní deníček",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xfff5ddb1),
          surface: Color(0xfffffefa),
          surfaceContainerLow: Colors.white,
          surfaceContainerHigh: Colors.white,
          surfaceContainer: Color(0xfffffefa),
        ),
        cardTheme: CardThemeData(elevation: 2.0),
      ),
      home: Homescreen(),
    );
  }
}
