import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:getsh_tdone/firebase_options.dart';
import 'package:getsh_tdone/home_screen.dart';
import 'package:getsh_tdone/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Get Sh_t Done',
      theme: themeDark,
      home: const HomeScreen(),
    );
  }
}
