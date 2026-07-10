import "dart:io";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:my_beer_diary/screen/home.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Homescreen());
  }
}
