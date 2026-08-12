import "dart:io";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/screen/home_screen.dart";
import "package:provider/provider.dart";
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BeerNotifier()..refresh()),

        ChangeNotifierProvider(
          create: (_) => BeerConsumptionNotifier()..refresh(),
        ),

        ChangeNotifierProvider(create: (_) => EventNotifier()..refresh()),

        ChangeNotifierProvider(create: (_) => TagNotifier()..refresh()),
      ],
      child: const MainApp(),
    ),
  );
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
          seedColor: appColorSeed,
          surface: appColorSurface,
          surfaceContainer: appColorSurface,
          surfaceContainerLow: appColorContainer,
          surfaceContainerHigh: appColorContainer,
        ),
        cardTheme: CardThemeData(elevation: 2.0),
      ),
      home: HomeScreen(),
    );
  }
}
