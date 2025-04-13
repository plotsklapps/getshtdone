import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';
import 'package:getsh_tdone/providers/sneakpeek_provider.dart';
import 'package:getsh_tdone/services/logger.dart';
import 'package:getsh_tdone/services/navigation.dart';
import 'package:logger/logger.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  final Logger _logger = Logger();
  late Timer progressTimer;
  double progressValue = 0;

  @override
  void initState() {
    super.initState();

    // Here we start a timer that will increment the progressValue.
    progressTimer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      // Check if not mounted to avoid calling setState after dispose.
      if (!mounted) {
        return;
      }
      setState(() {
        progressValue += 0.01;
      });

      final User? currentUser = ref.watch(firebaseProvider).currentUser;
      // Check if user is logged in and verified.
      if (currentUser != null && currentUser.emailVerified) {
        progressValue = 1.0;
        progressTimer.cancel();
        _logger.i('User is logged in or verified, going to HomeScreen');

        // User is known: set sneak peeker bool to false.
        ref.read(isSneakPeekerProvider.notifier).state = false;
        Navigation.navigateToHomeScreen(context);
      } else if (progressValue >= 1.0) {
        progressValue = 1.0;
        progressTimer.cancel();
        Logs.userUnknown();
        Navigation.navigateToLoginScreen(context);
      }
    });
  }

  @override
  void dispose() {
    progressTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              Align(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 10,
                  ),
                ),
              ),
              Align(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/gsdIcon.png',
                    height: 72,
                    width: 72,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
