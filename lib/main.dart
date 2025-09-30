import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'blocs/dice_bloc.dart';
import 'screens/home_screen.dart';
import 'models/dice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(DiceTypeAdapter());
  Hive.registerAdapter(DiceRollAdapter());
  
  runApp(const RunvikApp());
}

class RunvikApp extends StatelessWidget {
  const RunvikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runvik RPG Helper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B4513), // Dark brown for RPG theme
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2A2A2A),
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF2A2A2A),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B4513),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFD4AF37), // Gold color for icons
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
      home: BlocProvider(
        create: (context) => DiceBloc(),
        child: const HomeScreen(),
      ),
    );
  }
}