import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';
import 'package:getsh_tdone/providers/sneakpeek_provider.dart';
import 'package:getsh_tdone/services/logger.dart';
import 'package:getsh_tdone/services/navigation.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  late Timer progressTimer;
  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();

    // Here we start a timer that will increment the progressValue.
    progressTimer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      // Check if not mounted to avoid calling setState after dispose.
      if (!mounted) {
        return;
      }
      setState(() {
        progressValue += 0.01;
      });

      // When we reach 1.0, we perform the next logic.
      if (progressValue >= 1.0) {
        final User? currentUser = ref.watch(firebaseProvider).currentUser;
        progressValue = 1.0;
        progressTimer.cancel();

        // Check if user is logged in and verified.
        if (currentUser != null && currentUser.emailVerified) {
          Logs.userKnown();
          // User is known: set sneak peeker bool to false.
          ref.read(isSneakPeekerProvider.notifier).state = false;
          Navigation.navigateToHomeScreen(context);
        } else {
          Logs.userUnknown();
          // User is unknown: set sneak peeker bool to true.
          ref.read(isSneakPeekerProvider.notifier).state = true;
          Navigation.navigateToLoginScreen(context);
        }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'GET SH_T DONE',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48.0),
              CircularProgressIndicator(
                value: progressValue,
                strokeWidth: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
