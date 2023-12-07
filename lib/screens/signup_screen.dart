import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/displayname_provider.dart';
import 'package:getsh_tdone/providers/email_provider.dart';
import 'package:getsh_tdone/services/firebase_service.dart';
import 'package:getsh_tdone/services/navigation.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() {
    return SignupScreenState();
  }
}

class SignupScreenState extends ConsumerState<SignupScreen> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool isSigningUp = false;
  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'SIGN UP',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: usernameController,
                onChanged: (String value) {
                  ref.read(displayNameProvider.notifier).state = value;
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_2_rounded),
                  labelText: 'USERNAME',
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: emailController,
                onChanged: (String value) {
                  ref.read(emailProvider.notifier).state = value;
                },
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
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: confirmPasswordController,
                obscureText: isConfirmPasswordObscured,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'CONFIRM PASSWORD',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordObscured = !isConfirmPasswordObscured;
                      });
                    },
                    icon: isConfirmPasswordObscured
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Switch bool to true to show loading indicator.
                        if (!isSigningUp) {
                          setState(() {
                            isSigningUp = true;
                          });
                        }
                        // Sign up with Firebase. Show snackbar on
                        // success or error. Switch bool to false to
                        // hide loading indicator.
                        await FirebaseService(ref).signUp(
                            usernameController.text.trim(),
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            confirmPasswordController.text.trim(),
                            // If anything goes wrong:
                            (Object error) {
                          showErrorSnack(context, error);
                          setState(() {
                            isSigningUp = false;
                          });
                        },
                            // If everything goes well:
                            (String success) {
                          Navigation.navigateToLoginScreen(context);
                          showSuccessSnack(context, success);
                          setState(() {
                            isSigningUp = false;
                          });
                        });
                      },
                      child: isSigningUp
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: CircularProgressIndicator(),
                            )
                          : const Text(
                              'SIGN UP',
                            ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigation.navigateToLoginScreen(context);
                },
                child: const Text('BACK TO LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showErrorSnack(BuildContext context, Object onError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(onError.toString()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showSuccessSnack(BuildContext context, String onSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(onSuccess),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
