import 'package:flutter/material.dart';
import 'package:getsh_tdone/home_screen.dart';
import 'package:getsh_tdone/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Sh_t Done',
      theme: themeDark,
      home: const HomeScreen(),
    );
  }
}
