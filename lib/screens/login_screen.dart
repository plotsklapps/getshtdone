import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/services/firebase_service.dart';
import 'package:getsh_tdone/services/navigation.dart';
import 'package:getsh_tdone/theme/theme.dart';
import 'package:getsh_tdone/widgets/responsive_layout.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isLoggingIn = false;
  bool isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ResponsiveLayout(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'EMAIL',
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: passwordController,
                  obscureText: isPasswordObscured,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: 'PASSWORD',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordObscured = !isPasswordObscured;
                        });
                      },
                      icon: isPasswordObscured
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigation.navigateToSignupScreen(context);
                        },
                        child: const Text('SIGN UP'),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          // Switch bool to true to show loading indicator
                          if (!isLoggingIn) {
                            setState(() {
                              isLoggingIn = true;
                            });
                          }
                          // Log in user. Show snackbar on success or error.
                          // Switch bool to false to hide loading indicator.
                          await FirebaseService(ref).logIn(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              // If anything goes wrong:
                              (Object error) {
                            showErrorSnack(context, error);
                            setState(() {
                              isLoggingIn = false;
                            });
                          },
                              // If everything goes well:
                              (String success) {
                            Navigation.navigateToHomeScreen(context);
                            showSuccessSnack(context, success);
                            setState(() {
                              isLoggingIn = false;
                            });
                          });
                        },
                        child: isLoggingIn
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    ref.watch(isDarkModeProvider)
                                        ? flexSchemeDark(ref).onPrimary
                                        : flexSchemeLight(ref).onPrimary,
                                  ),
                                ),
                              )
                            : const Text(
                                'LOG IN',
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigation.navigateToPasswordScreen(context);
                      },
                      child: const Text('FORGOT PASSWORD'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLoggingIn = true;
                        });
                        // Sneak peek user. Show snackbar on success
                        // or error.
                        FirebaseService(ref).sneakPeek(
                            // If everything goes well:
                            (String success) {
                          setState(() {
                            isLoggingIn = false;
                          });
                          Navigation.navigateToHomeScreen(context);
                          showSuccessSnack(context, success);
                        });
                      },
                      child: isLoggingIn
                          ? const CircularProgressIndicator()
                          : const Text('SNEAK PEEK'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showErrorSnack(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showSuccessSnack(BuildContext context, String success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
