import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/displayname_provider.dart';
import 'package:getsh_tdone/providers/smiley_provider.dart';
import 'package:getsh_tdone/services/firebase_service.dart';
import 'package:getsh_tdone/theme/theme.dart';

class UsernameModal extends ConsumerStatefulWidget {
  const UsernameModal({super.key});

  @override
  ConsumerState<UsernameModal> createState() {
    return UsernameModalState();
  }
}

class UsernameModalState extends ConsumerState<UsernameModal> {
  bool isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final BuildContext outsideContext = context;
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
            'Change your profile',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(thickness: 4.0),
          const SizedBox(height: 8.0),
          const SmileyIconRow(),
          const SizedBox(height: 16),
          TextField(
            onChanged: (String value) {
              ref.read(displayNameProvider.notifier).state = value;
            },
            decoration: const InputDecoration(
              labelText: 'NEW USERNAME',
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Switch bool to true to show loading indicator.
                      if (!isSaving) {
                        setState(() {
                          isSaving = true;
                        });
                      }
                      // If user is logged in, update the
                      // displayname and avatar to Firebase.
                      await FirebaseService(ref).updateDisplayName(
                        // If anything goes wrong:
                        (Object error) {
                          showErrorSnack(outsideContext, error);
                          setState(() {
                            isSaving = false;
                          });
                        },
                        // If everything goes well:
                        (String success) {
                          showSuccessSnack(outsideContext, success);
                          setState(() {
                            isSaving = false;
                          });
                        },
                      );
                      await FirebaseService(ref).updatePhotoURL((Object error) {
                        // If anything goes wrong:
                        showErrorSnack(outsideContext, error);
                        setState(() {
                          isSaving = false;
                        });
                      }, (String success) {
                        // If everything goes well:
                        showSuccessSnack(outsideContext, success);
                        setState(() {
                          isSaving = false;
                        });
                      }).then((_) {
                        Navigator.pop(context);
                      });
                    },
                    child: isSaving
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: CircularProgressIndicator(),
                          )
                        : const Text('SAVE'),
                  ),
                ),
              ],
            ),
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
