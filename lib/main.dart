import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sushimeter/constants/app_strings.dart';
import 'package:sushimeter/screens/home_screen.dart';
import 'package:sushimeter/theme/theme_provider.dart';
import 'models/sushi_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(SushiEntryAdapter());
  await Hive.openBox<SushiEntry>('sushiBox');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
