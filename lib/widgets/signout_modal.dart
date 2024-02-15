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
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Are you sure?',
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
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL'),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
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
                      Navigation.navigateToSplashScreen(context);
                      showSuccessSnack(context, success);
                    });
                    setState(() {
                      isSigningOut = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sIsDark.value
                        ? cFlexSchemeDark().error
                        : cFlexSchemeLight().error,
                  ),
                  child: Text(
                    'SIGN OUT',
                    style: TextStyle(
                      color: sIsDark.value
                          ? cFlexSchemeDark().onError
                          : cFlexSchemeLight().onError,
                    ),
                  ),
                ),
              ),
            ],
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
        backgroundColor:
            sIsDark.value ? cFlexSchemeDark().error : cFlexSchemeLight().error,
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
