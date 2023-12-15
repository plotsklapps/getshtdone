import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/firebase_options.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/screens/splash_screen.dart';
import 'package:getsh_tdone/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Get Sh_t Done',
      theme: ref.watch(isDarkModeProvider) ? themeDark(ref) : themeLight(ref),
      themeMode: ref.watch(themeModeProvider),
      home: const SplashScreen(),
    );
  }
}
