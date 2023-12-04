import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/services/firebase_service.dart';
import 'package:getsh_tdone/services/navigation.dart';

class DeleteUserModal extends ConsumerStatefulWidget {
  const DeleteUserModal({super.key});

  @override
  ConsumerState<DeleteUserModal> createState() {
    return DeleteUserModalState();
  }
}

class DeleteUserModalState extends ConsumerState<DeleteUserModal> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isPasswordObscured = true;
  bool isDeleting = false;

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
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0,
        8.0,
        16.0,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('PERMANENTLY DELETE YOUR ACCOUNT'),
          const SizedBox(
            height: 16,
          ),
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: 'EMAIL',
            ),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (!isDeleting) {
                      setState(() {
                        isDeleting = true;
                      });
                    }
                    await FirebaseService(ref).deleteUser(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        // If anything goes wrong.
                        (Object error) {
                      showErrorSnack(context, error);
                      setState(() {
                        isDeleting = false;
                      });
                    },
                        // If everything goes well.
                        (String success) {
                      showSuccessSnack(context, success);
                      Navigation.navigateToLoginScreen(context);
                      setState(() {
                        isDeleting = false;
                      });
                    });
                  },
                  child: isDeleting
                      ? const CircularProgressIndicator()
                      : const Text('DELETE ACCOUNT'),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL'),
          ),
        ],
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

  void showErrorSnack(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
