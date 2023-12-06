import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
    'assets/images/face-angry.svg',
    'assets/images/face-dizzy.svg',
    'assets/images/face-flushed.svg',
    'assets/images/face-grin-stars.svg',
    'assets/images/face-kiss-wink-heart.svg',
    'assets/images/face-sad-tear.svg',
    'assets/images/face-surprise.svg',
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
          const Text(
            'Change your profile',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(thickness: 4.0),
          const SizedBox(height: 8.0),
          SmileyRow(ref: ref, avatarChoices: avatarChoices),
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

class SmileyRow extends StatelessWidget {
  const SmileyRow({
    required this.ref,
    required this.avatarChoices,
    super.key,
  });

  final WidgetRef ref;
  final List<String> avatarChoices;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          ProfileSmiley(
            ref: ref,
            avatarChoices: avatarChoices,
            avatarIndex: 0,
          ),
          ProfileSmiley(
            ref: ref,
            avatarChoices: avatarChoices,
            avatarIndex: 1,
          ),
          ProfileSmiley(
            ref: ref,
            avatarChoices: avatarChoices,
            avatarIndex: 2,
          ),
          ProfileSmiley(
            ref: ref,
            avatarChoices: avatarChoices,
            avatarIndex: 3,
          ),
          ProfileSmiley(
            ref: ref,
            avatarChoices: avatarChoices,
            avatarIndex: 4,
          ),
          ProfileSmiley(
            ref: ref,
            avatarChoices: avatarChoices,
            avatarIndex: 5,
          ),
          ProfileSmiley(
            ref: ref,
            avatarChoices: avatarChoices,
            avatarIndex: 6,
          ),
        ],
      ),
    );
  }
}

class ProfileSmiley extends StatelessWidget {
  const ProfileSmiley({
    required this.ref,
    required this.avatarChoices,
    required this.avatarIndex,
    super.key,
  });

  final WidgetRef ref;
  final List<String> avatarChoices;
  final int avatarIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Store the choice to the avatarProvider.
        ref.read(photoURLProvider.notifier).state = avatarChoices[avatarIndex];
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.only(right: 8.0),
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            // If the avatarProvider is equal to the first
            // avatarChoice, set a border color.
            color: ref.watch(photoURLProvider) == avatarChoices[avatarIndex]
                ? flexSchemeDark.primary
                : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: SvgPicture.asset(
          height: 80.0,
          width: 80.0,
          avatarChoices[avatarIndex],
          colorFilter: ColorFilter.mode(
            ref.watch(photoURLProvider) == avatarChoices[avatarIndex]
                ? flexSchemeDark.primary
                : flexSchemeDark.secondary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
