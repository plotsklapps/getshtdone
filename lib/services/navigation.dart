import 'package:flutter/material.dart';
import 'package:getsh_tdone/screens/home_screen.dart';
import 'package:getsh_tdone/screens/login_screen.dart';
import 'package:getsh_tdone/screens/password_screen.dart';
import 'package:getsh_tdone/screens/signup_screen.dart';
import 'package:getsh_tdone/screens/splash_screen.dart';
import 'package:getsh_tdone/screens/useraccount_screen.dart';

class Navigation {
  static void navigateToSplashScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) {
          return const SplashScreen();
        },
      ),
    );
  }

  static void navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) {
          return const HomeScreen();
        },
      ),
    );
  }

  static void navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) {
          return const LoginScreen();
        },
      ),
    );
  }

  static void navigateToSignupScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) {
          return const SignupScreen();
        },
      ),
    );
  }

  static void navigateToPasswordScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) {
          return const PasswordScreen();
        },
      ),
    );
  }

  static void navigateToUserAccountScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) {
          return const UserAccountScreen();
        },
      ),
    );
  }
}
