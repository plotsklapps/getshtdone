import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  List<String> avatarChoices = <String>[
    'assets/images/avatar_female_black.png',
    'assets/images/avatar_female_white.png',
    'assets/images/avatar_male_black.png',
    'assets/images/avatar_male_white.png',
  ];
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
          const Text('CHANGE YOUR PROFILE PICTURE'),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  // Store the choice to the avatarProvider.
                  ref.read(photoURLProvider.notifier).state = avatarChoices[0];
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      // If the avatarProvider is equal to the first
                      // avatarChoice, set a border color.
                      color: ref.watch(photoURLProvider) == avatarChoices[0]
                          ? flexSchemeLight.primary
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage(
                      avatarChoices[0],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Store the choice to the avatarProvider.
                  ref.read(photoURLProvider.notifier).state = avatarChoices[1];
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      // If the avatarProvider is equal to the second
                      // avatarChoice, set a border color.
                      color: ref.watch(photoURLProvider) == avatarChoices[1]
                          ? flexSchemeLight.primary
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage(
                      avatarChoices[1],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Store the choice to the Provider.
                  ref.read(photoURLProvider.notifier).state = avatarChoices[2];
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      // If the avatarProvider is equal to the third
                      // avatarChoice, set a border color.
                      color: ref.watch(photoURLProvider) == avatarChoices[2]
                          ? flexSchemeLight.primary
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage(
                      avatarChoices[2],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Store the choice to the Provider.
                  ref.read(photoURLProvider.notifier).state = avatarChoices[3];
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      // If the avatarProvider is equal to the fourth
                      // avatarChoice, set a border color.
                      color: ref.watch(photoURLProvider) == avatarChoices[3]
                          ? flexSchemeLight.primary
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage(
                      avatarChoices[3],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('CHANGE YOUR USERNAME'),
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
        backgroundColor: flexSchemeLight.error,
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
