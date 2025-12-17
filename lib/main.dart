import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'join_screen.dart';

// 1. Create a Global "Switch" that stores the current mode
//  made it global so other screens can access it easily.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Wrap the app in a builder that listens to the switch
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Football Fan Chat',

          // Define what "Normal Mode" looks like
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green, brightness: Brightness.light),
            useMaterial3: true,
          ),

          // Define what "Dark Mode" looks like
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green, // Keep it green, but dark!
                brightness: Brightness.dark),
            useMaterial3: true,
          ),

          // This tells Flutter which one to use right now
          themeMode: currentMode,

          home: const JoinScreen(),
        );
      },
    );
  }
}
