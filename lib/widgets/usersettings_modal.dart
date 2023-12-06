import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/services/firebase_service.dart';
import 'package:getsh_tdone/services/navigation.dart';
import 'package:getsh_tdone/theme/theme.dart';
import 'package:getsh_tdone/widgets/avatar_listtile.dart';
import 'package:getsh_tdone/widgets/deleteuser_modal.dart';
import 'package:getsh_tdone/widgets/signout_modal.dart';
import 'package:getsh_tdone/widgets/username_modal.dart';

class UserSettingsModal extends ConsumerStatefulWidget {
  const UserSettingsModal({super.key});

  @override
  ConsumerState<UserSettingsModal> createState() {
    return UserSettingsModalState();
  }
}

class UserSettingsModalState extends ConsumerState<UserSettingsModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Profile ListTile.
          ListTile(
            onTap: () async {
              if (ref.watch(isSneakPeekerProvider) == true) {
                showSneakPeekerSnack(context);
              } else {
                await showModalBottomSheet<BottomSheet>(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (BuildContext context) {
                    return const UsernameModal();
                  },
                );
              }
            },
            leading: AvatarListTile(
              ref: ref,
              assetPath: ref.watch(photoURLProvider),
            ),
            title: Text(ref.watch(displayNameProvider)),
            subtitle: const Text('CHANGE YOUR PROFILE'),
            trailing: const Icon(Icons.edit_rounded),
          ),

          // Sign out listtile.
          ListTile(
            onTap: () async {
              if (ref.watch(isSneakPeekerProvider)) {
                Navigation.navigateToLoginScreen(context);
                showSuccessSnack(context);
              } else {
                await showModalBottomSheet<BottomSheet>(
                  isScrollControlled: true,
                  showDragHandle: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const SignoutModal();
                  },
                );
              }
            },
            leading: FaIcon(FontAwesomeIcons.signOut),
            title: const Text('SIGN OUT'),
            subtitle: const Text('GO BACK TO LOGIN'),
            trailing: const Icon(Icons.logout_rounded),
          ),
          // Delete user listtile.
          ListTile(
            onTap: () async {
              if (ref.watch(isSneakPeekerProvider)) {
                showSneakPeekerSnack(context);
              } else {
                await showModalBottomSheet<BottomSheet>(
                  isScrollControlled: true,
                  showDragHandle: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const DeleteUserModal();
                  },
                );
              }
            },
            leading: const AvatarListTile(
              assetPath: 'assets/images/deleteUser.png',
            ),
            title: const Text('DELETE ACCOUNT'),
            subtitle: const Text('PERMANENTLY REMOVE YOUR DATA'),
            trailing: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
    );
  }

  void showSuccessSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully signed out!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showSneakPeekerSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You are currently in sneak peek mode. '
            'Please sign in to get access.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: flexSchemeLight.error,
      ),
    );
  }
}
