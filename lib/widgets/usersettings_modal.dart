import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/providers/displayname_provider.dart';
import 'package:getsh_tdone/providers/smiley_provider.dart';
import 'package:getsh_tdone/providers/sneakpeek_provider.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/services/firebase_service.dart';
import 'package:getsh_tdone/services/navigation.dart';
import 'package:getsh_tdone/theme/theme.dart';
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
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'User Settings',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(thickness: 4.0),

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
            title: Text(ref.watch(displayNameProvider)),
            subtitle: const Text('CHANGE YOUR PROFILE'),
            trailing: FaIcon(ref.watch(smileyProvider)),
          ),

          // Change thememode ListTile.
          ListTile(
            onTap: () {
              ref.read(isDarkModeProvider.notifier).state =
                  !ref.watch(isDarkModeProvider);
              FirebaseService(ref).updateThemeMode((Object error) {
                // If anything goes wrong:
                showErrorSnack(context, error);
              }, (String success) {
                // If all goes well: Do nothing.
              });
            },
            title: ref.watch(isDarkModeProvider)
                ? const Text('Dark Mode')
                : const Text('Light Mode'),
            subtitle: const Text('Change the app theme'),
            trailing: ref.watch(isDarkModeProvider)
                ? const FaIcon(FontAwesomeIcons.moon)
                : const FaIcon(FontAwesomeIcons.sun),
          ),

          // Change themecolor ListTile.
          ListTile(
            onTap: () {
              ref.read(isGreenSchemeProvider.notifier).state =
                  !ref.watch(isGreenSchemeProvider);
              FirebaseService(ref).updateThemeColor((Object error) {
                // If anything goes wrong:
                showErrorSnack(context, error);
              }, (String success) {
                // If all goes well: Do nothing.
              });
            },
            title: ref.watch(isGreenSchemeProvider)
                ? const Text('Green Money')
                : const Text('Espresso'),
            subtitle: const Text('Change the app colors'),
            trailing: ref.watch(isGreenSchemeProvider)
                ? const FaIcon(FontAwesomeIcons.moneyBills)
                : const FaIcon(FontAwesomeIcons.mugHot),
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
            title: const Text('SIGN OUT'),
            subtitle: const Text('GO BACK TO LOGIN'),
            trailing: const FaIcon(
              FontAwesomeIcons.personWalkingDashedLineArrowRight,
            ),
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
            title: const Text('DELETE ACCOUNT'),
            subtitle: const Text('PERMANENTLY REMOVE YOUR DATA'),
            trailing: const FaIcon(FontAwesomeIcons.trashCan),
          ),
        ],
      ),
    );
  }

  void showErrorSnack(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$error'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ref.watch(isDarkModeProvider)
            ? flexSchemeDark(ref).error
            : flexSchemeDark(ref).error,
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
        backgroundColor: ref.watch(isDarkModeProvider)
            ? flexSchemeDark(ref).error
            : flexSchemeDark(ref).error,
      ),
    );
  }
}
