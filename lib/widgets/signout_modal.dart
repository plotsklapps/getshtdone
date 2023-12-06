import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/services/firebase_service.dart';
import 'package:getsh_tdone/services/navigation.dart';
import 'package:getsh_tdone/theme/theme.dart';

class SignoutModal extends ConsumerStatefulWidget {
  const SignoutModal({super.key});

  @override
  ConsumerState<SignoutModal> createState() {
    return SignoutModalState();
  }
}

class SignoutModalState extends ConsumerState<SignoutModal> {
  bool isSigningOut = false;

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
          const Text(
            'GO BACK TO LOG IN',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(thickness: 4.0),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (!isSigningOut) {
                      setState(() {
                        isSigningOut = true;
                      });
                    }
                    await FirebaseService(ref).signOut(
                        // If anything goes wrong:
                        (Object error) {
                      showErrorSnack(context, error);
                    },
                        // If everything goes well:
                        (String success) {
                      Navigation.navigateToLoginScreen(context);
                      showSuccessSnack(context, success);
                    });
                    setState(() {
                      isSigningOut = false;
                    });
                  },
                  child: isSigningOut
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: CircularProgressIndicator(),
                        )
                      : const Text('SIGN OUT'),
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

  void showErrorSnack(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        behavior: SnackBarBehavior.floating,
        backgroundColor: flexSchemeDark.error,
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
