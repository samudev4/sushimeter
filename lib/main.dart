import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sushimeter/constants/app_strings.dart';
import 'package:sushimeter/screens/home_screen.dart';
import 'package:sushimeter/theme/theme_provider.dart';
import 'models/sushi_entry.dart';

// ✅ nuevo import
import 'package:sushimeter/settings/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(SushiEntryAdapter());
  await Hive.openBox<SushiEntry>('sushiBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // ✅ cargamos preferencia y aplicamos wakelock al iniciar
        ChangeNotifierProvider(create: (_) => SettingsProvider()..load()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.textoNombreApp,
      theme: ThemeData(
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
        ),
      ),

      darkTheme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
