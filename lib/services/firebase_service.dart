import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/providers/category_provider.dart';
import 'package:getsh_tdone/providers/date_provider.dart';
import 'package:getsh_tdone/providers/description_provider.dart';
import 'package:getsh_tdone/providers/displayname_provider.dart';
import 'package:getsh_tdone/providers/email_provider.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';
import 'package:getsh_tdone/providers/firestore_provider.dart';
import 'package:getsh_tdone/providers/iscompleted_provider.dart';
import 'package:getsh_tdone/providers/photourl_provider.dart';
import 'package:getsh_tdone/providers/smiley_provider.dart';
import 'package:getsh_tdone/providers/sneakpeek_provider.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/providers/title_provider.dart';
import 'package:getsh_tdone/providers/todolist_provider.dart';
import 'package:getsh_tdone/services/logger.dart';

// Custom class FirebaseService which takes a WidgetRef as a parameter.
// This is used to access the Providers. In the code, it's usable as
// FirebaseService(ref).logIn(...) for example.
class FirebaseService {
  FirebaseService(this.ref);
  final WidgetRef ref;

  // Method to sign up the user for a Firebase account. Displayname is
  // stored in the displayNameProvider, email is stored in the
  // emailProvider.
  // These are used to create an initial Firestore document for the user.
  // onError and onSuccess are callbacks which are used to show a
  // SnackBar to the user.
  Future<void> signUp(
    String displayname,
    String email,
    String password,
    String confirmPassword,
    void Function(Object error) onError,
    void Function(String success) onSuccess,
  ) async {
    try {
      // Check if displayname, email or password is empty.
      if (displayname.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('Username, email and/or password cannot be empty.');
      }

      // Check if password is equal to confirmPassword.
      if (password != confirmPassword) {
        throw Exception('Passwords do not match.');
      }

      // Create new Firebase User
      final UserCredential userCredential = await ref
          .read(firebaseProvider)
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store displayName in Firebase Auth.
      await userCredential.user?.updateDisplayName(displayname);

      // Store standard avatar in Firebase Auth.
      await userCredential.user?.updatePhotoURL(ref.watch(photoURLProvider));

      // Send email verification.
      await userCredential.user?.sendEmailVerification();

      // Create Firestore document.
      await ref
          .read(firestoreProvider)
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(<String, dynamic>{
        'displayName': ref.watch(displayNameProvider),
        'photoURL': ref.watch(photoURLProvider),
        'email': ref.watch(emailProvider),
        'darkMode': ref.watch(isDarkModeProvider),
        'greenScheme': ref.watch(isGreenSchemeProvider),
        'creationDate': ref.watch(creationDateProvider),
        'lastSignInDate': ref.watch(lastSignInDateProvider),
      });

      // Create subcollection for todos.
      await ref
          .read(firestoreProvider)
          .collection('users')
          .doc(userCredential.user?.uid)
          .collection('todoCollection')
          .doc()
          .set(<String, dynamic>{
        'id': '0',
        'title': 'My first todo',
        'description':
            'Get your sh_t done.\nSwipe right to delete, swipe left to share '
                'or long press to edit.',
        'category': 'Personal',
        'createdDate': ref.watch(createdDateProvider),
        'dueDate': ref.watch(dueDateProvider),
        'isCompleted': false,
      });

      // If all goes well:
      Logs.signupComplete();
      onSuccess('Successfully signed up! Please verify your email.');
    } catch (error) {
      // If anything goes wrong:
      Logs.signupFailed();
      onError(error);
      rethrow;
    }
  }

  // Method to log in the user and set the correct displayName.
  // onError and onSuccess are callbacks which are used to show
  // a SnackBar to the user.
  Future<void> logIn(
    String email,
    String password,
    void Function(Object error) onError,
    void Function(String success) onSuccess,
  ) async {
    try {
      // Check if email or password is empty.
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and/or password cannot be empty.');
      }
      // Sign in with email and password.
      await ref.read(firebaseProvider).signInWithEmailAndPassword(
            email: email,
            password: password,
          );
      // Retrieve an User object from Firebase Auth.
      final User? currentUser = ref.read(firebaseProvider).currentUser;
      if (currentUser == null) {
        onError('Something went wrong. Please try again.');
      } else {
        if (!currentUser.emailVerified) {
          onError('Please verify your email address.');
        } else {
          // Fetch the Firestore document and store the data in their
          // respective Providers.
          await ref
              .read(firestoreProvider)
              .collection('users')
              .doc(currentUser.uid)
              .get()
              .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
            if (documentSnapshot.exists) {
              ref.read(displayNameProvider.notifier).state =
                  documentSnapshot['displayName'] as String;
              ref.read(emailProvider.notifier).state =
                  documentSnapshot['email'] as String;
              ref.read(photoURLProvider.notifier).state =
                  documentSnapshot['photoURL'] as String;
              ref.read(isDarkModeProvider.notifier).state =
                  documentSnapshot['darkMode'] as bool;
              ref.read(isGreenSchemeProvider.notifier).state =
                  documentSnapshot['greenScheme'] as bool;
              ref.read(creationDateProvider.notifier).state =
                  documentSnapshot['creationDate'] as String;
              ref.read(lastSignInDateProvider.notifier).state =
                  documentSnapshot['lastSignInDate'] as String;
            } else {
              // If anything goes wrong:
              Logs.loginFailed();
              onError('Something went wrong. Please try again.');
            }
          });

          // Fetch the todos from Firestore and store them in the
          // todoListProvider.
          ref.read(todoListProvider.notifier).fetchTodos();

          // If all goes well:
          Logs.loginComplete();
          onSuccess('Successfully logged in. Now get your sh_t done!');
        }
      }
    } catch (error) {
      // If anything goes wrong:
      Logs.loginFailed();
      onError(error);
      rethrow;
    }
  }

  // Method to enter sneak peek mode. That means the user will have
  // the basic functionality of the app available, but no data will
  // be stored in the database. onSuccess is a callback that is used
  // to show a SnackBar to the user.
  Future<void> sneakPeek(
    void Function(String success) onSuccess,
  ) async {
    ref.read(displayNameProvider.notifier).state = 'SNEAK PEEKER';
    ref.read(isSneakPeekerProvider.notifier).state = true;
    ref.read(photoURLProvider.notifier).state = 'handpeaceregular';
    ref.read(smileyProvider.notifier).state = FontAwesomeIcons.handPeace;
    Logs.sneakPeekComplete();
    onSuccess('Enjoy your sneak peek. Your data will not be stored.');
  }

  // Method to reset the password for the user. onError and onSuccess are
  // callbacks which are used to show a SnackBar to the user.
  Future<void> resetPassword(
    String email,
    void Function(Object error) onError,
    void Function(String success) onSuccess,
  ) async {
    try {
      // Check if email is empty.
      if (email.isEmpty) {
        throw Exception('Email cannot be empty.');
      }
      // Send password reset email.
      await ref
          .read(firebaseProvider)
          .sendPasswordResetEmail(email: email)
          .then((_) {
        // If all goes well:
        Logs.resetPasswordComplete();
        onSuccess('Password reset email sent.');
      });
    } catch (error) {
      // If anything goes wrong:
      Logs.resetPasswordFailed();
      onError(error);
      rethrow;
    }
  }

  // Method to sign out the user and invalidate the Providers.
  // onError and onSuccess are callbacks which are used to show a
  // SnackBar to the user.
  Future<void> signOut(
    void Function(Object error) onError,
    void Function(String success) onSuccess,
  ) async {
    try {
      // Cancel the Firestore listener.
      ref.read(todoListProvider.notifier).cancelSubscription();
      // Sign out from Firebase Auth.
      await ref.read(firebaseProvider).signOut().then((_) {
        final User? currentUser = ref.read(firebaseProvider).currentUser;
        if (currentUser == null) {
          // If all goes well:
          invalidateAllProviders();
          Logs.signOutComplete();
          onSuccess('Successfully signed out!');
        } else {
          // If anything goes wrong:
          Logs.signOutFailed();
        }
      });
    } catch (error) {
      // If anything goes wrong:
      Logs.signOutFailed();
      onError(error);
      rethrow;
    }
  }

  // Method to delete the user from Firebase Auth and Firestore. Both the
  // Firebase Auth user and the Firestore document will be deleted after
  // reauthentication.onError and onSuccess are callbacks which are
  // used to show a SnackBar to the user.
  Future<void> deleteUser(
    String email,
    String password,
    void Function(Object error) onError,
    void Function(String success) onSuccess,
  ) async {
    try {
      // Get the current user
      final User? currentUser = ref.read(firebaseProvider).currentUser;
      // Get credentials for reauthentication.
      final AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      // Use the credentials to reauthenticate the user.
      final UserCredential result =
          await currentUser!.reauthenticateWithCredential(credentials);
      // When reauthenticated, delete the user doc from Firestore
      // database.
      await ref
          .read(firestoreProvider)
          .collection('users')
          .doc(result.user?.uid)
          .delete();
      // Now we can delete user from Firebase Auth.
      await ref.watch(firebaseProvider).currentUser?.delete();
      // If all goes well:
      invalidateAllProviders();
      Logs.deleteUserComplete();
      onSuccess('Successfully deleted user.');
    } catch (error) {
      // If anything goes wrong:
      Logs.deleteUserFailed();
      onError(error);
      rethrow;
    }
  }

  // Method to update the displayName in Firebase Auth and Firestore.
  Future<void> updateDisplayName(
    void Function(Object error) onError,
    void Function(String success) onSuccess,
  ) async {
    try {
      final String updatedDisplayName = ref.watch(displayNameProvider);
      final User? currentUser = ref.watch(firebaseProvider).currentUser;
      // Update the displayName in the Provider.
      await currentUser?.updateDisplayName(updatedDisplayName);
      // Surprise, Firebase does not change it until you do the next:
      await ref.read(firebaseProvider).currentUser?.reload();
      // Update the displayName in the Firestore document.
      await ref
          .read(firestoreProvider)
          .collection('users')
          .doc(
            currentUser?.uid,
          )
          .update(
        <String, dynamic>{
          'displayName': updatedDisplayName,
        },
      );
      Logs.displayNameChangeComplete();
      onSuccess('Successfully updated username.');
    } catch (error) {
      Logs.displayNameChangeFailed();
      onError(error);
      rethrow;
    }
  }

  Future<void> updatePhotoURL(
    void Function(Object error) onError,
    void Function(String success) onSuccess,
  ) async {
    try {
      final String updatedPhotoURL = ref.watch(photoURLProvider);
      final User? currentUser = ref.read(firebaseProvider).currentUser;
      // Update the photoURL in the Provider.
      await currentUser?.updatePhotoURL(updatedPhotoURL);
      // Surprise, Firebase does not change it until you do the next:
      await ref.read(firebaseProvider).currentUser?.reload();
      // Update the photoURL in the Firestore document.
      await ref
          .read(firestoreProvider)
          .collection('users')
          .doc(
            currentUser?.uid,
          )
          .update(
        <String, dynamic>{
          'photoURL': updatedPhotoURL,
        },
      );
      // If all goes well:
      Logs.avatarChangeComplete();
      onSuccess('Successfully updated avatar.');
    } catch (error) {
      // If anything goes wrong:
      Logs.avatarChangeFailed();
      onError(error);
      rethrow;
    }
  }

  Future<void> updateThemeMode(
    void Function(Object error) onError,
    void Function(String success) onSuccess,
  ) async {
    try {
      final bool updatedThemeMode = ref.watch(isDarkModeProvider);
      final User? currentUser = ref.read(firebaseProvider).currentUser;

      await ref
          .read(firestoreProvider)
          .collection('users')
          .doc(currentUser!.uid)
          .update(
        <String, dynamic>{
          'darkMode': updatedThemeMode,
        },
      );
      // If all goes well:
      Logs.themeModeChangeComplete();
      onSuccess('Successfully updated theme mode.');
    } catch (error) {
      // If anything goes wrong:
      Logs.themeModeChangeFailed();
      onError(error);
      rethrow;
    }
  }

  Future<void> updateThemeColor(
    void Function(Object error) onError,
    void Function(String success) onSuccess,
  ) async {
    try {
      final bool updatedFlexScheme = ref.watch(isGreenSchemeProvider);
      final User? currentUser = ref.read(firebaseProvider).currentUser;

      await ref
          .read(firestoreProvider)
          .collection('users')
          .doc(currentUser!.uid)
          .update(
        <String, dynamic>{
          'isGreenScheme': updatedFlexScheme,
        },
      );
      // If all goes well:
      Logs.themeColorChangeComplete();
      onSuccess('Successfully updated theme color.');
    } catch (error) {
      // If anything goes wrong:
      Logs.themeColorChangeFailed();
      onError(error);
      rethrow;
    }
  }

  // Method to set all Providers that do not autodispose back to their
  // initial state.
  void invalidateAllProviders() {
    ref
      ..invalidate(firebaseProvider)
      ..invalidate(firestoreProvider)
      ..invalidate(todoListProvider)
      ..invalidate(categoryProvider)
      ..invalidate(dateProvider)
      ..invalidate(createdDateProvider)
      ..invalidate(dueDateProvider)
      ..invalidate(creationDateProvider)
      ..invalidate(lastSignInDateProvider)
      ..invalidate(displayNameProvider)
      ..invalidate(emailProvider)
      ..invalidate(photoURLProvider)
      ..invalidate(smileyProvider)
      ..invalidate(isSneakPeekerProvider)
      ..invalidate(titleProvider)
      ..invalidate(descriptionProvider)
      ..invalidate(isCompletedProvider)
      ..invalidate(isDarkModeProvider)
      ..invalidate(isGreenSchemeProvider)
      ..invalidate(themeModeProvider);
  }
}
