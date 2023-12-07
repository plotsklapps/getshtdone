import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/date_provider.dart';
import 'package:getsh_tdone/providers/displayname_provider.dart';
import 'package:getsh_tdone/providers/email_provider.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';
import 'package:getsh_tdone/providers/photourl_provider.dart';
import 'package:getsh_tdone/providers/smiley_provider.dart';
import 'package:getsh_tdone/providers/sneakpeek_provider.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/services/firestore_service.dart';
import 'package:getsh_tdone/services/logger.dart';

// Custom class FirebaseService which takes a WidgetRef as a parameter.
// This is used to access the Providers. In the code, it's usable as
// FirebaseService(ref).logIn(...) for example.
class FirebaseService {
  FirebaseService(this.ref);
  final WidgetRef ref;

  // Method to sign up the user for a Firebase account. Username is
  // stored in the displayNameProvider, email is stored in the
  // emailProvider.
  // These are used to create an initial Firestore document for the user.
  // onError and onSuccess are callbacks which are used to show a
  // SnackBar to the user.
  Future<void> signUp(
    String username,
    String email,
    String password,
    String confirmPassword,
    void Function(Object error) onError,
    void Function(String success) onSuccess,
  ) async {
    try {
      // Check if username, email or password is empty.
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
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
      await userCredential.user?.updateDisplayName(username);

      // Store standard avatar in Firebase Auth.
      await userCredential.user
          ?.updatePhotoURL(ref.watch(smileyProvider).toString());

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
        'description': 'This is my first todo',
        'category': 'Personal',
        'dueDate': '01-01-2025',
        'dueTime': '12:00 PM',
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
      await ref
          .read(firebaseProvider)
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((_) async {
        final User? currentUser = ref.watch(firebaseProvider).currentUser;
        if (currentUser != null) {
          // Check if the user is verified.
          if (currentUser.emailVerified) {
            // Fetch the Firestore document and store the data in their
            // respective Providers. (Punches will be done later.)
            await ref
                .read(firestoreProvider)
                .collection('users')
                .doc(currentUser.uid)
                .get()
                .then(
                    (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
              if (documentSnapshot.exists) {
                ref.read(displayNameProvider.notifier).state =
                    documentSnapshot['displayName'] as String;
                ref.read(emailProvider.notifier).state =
                    documentSnapshot['email'] as String;
                ref.read(photoURLProvider.notifier).state =
                    documentSnapshot['photoURL'] as String;
                ref.read(isDarkModeProvider.notifier).state =
                    documentSnapshot['darkMode'] as bool;
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

            // Fetch the todos from the Firestore subcollection.
            await ref
                .read(firestoreProvider)
                .collection('users')
                .doc(currentUser.uid)
                .collection('todoCollection')
                .get();

            // If all goes well:
            Logs.loginComplete();
            onSuccess('Successfully logged in. Now get your sh_t done!');
          } else {
            // If anything goes wrong:
            Logs.loginFailed();
            onError('Please verify your email address.');
          }
        } else {
          // If anything goes wrong:
          Logs.loginFailed();
          onError('Something went wrong. Please try again.');
        }
      });
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
      await ref.read(firebaseProvider).signOut().then((_) {
        // If all goes well:
        invalidateAllProviders();
        Logs.signOutComplete();
        onSuccess('Successfully signed out!');
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
      // Get credentials for reauthentication.
      final AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      // Use the credentials to reauthenticate the user.
      final UserCredential? result = await ref
          .read(firebaseProvider)
          .currentUser
          ?.reauthenticateWithCredential(credentials);
      // When reauthenticated, delete the user doc from Firestore
      // database.
      await ref
          .read(firestoreProvider)
          .collection('users')
          .doc(result?.user?.uid)
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
      await currentUser?.updateDisplayName(
        updatedDisplayName,
      );
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
          'username': updatedDisplayName,
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
      final String updatedAvatar = ref.watch(photoURLProvider);
      final User? currentUser = ref.read(firebaseProvider).currentUser;
      // Update the photoURL in the Provider.
      await currentUser?.updatePhotoURL(updatedAvatar);
      // Surprise, Firebase does not change it until you do the next:
      await currentUser?.reload();
      // Update the photoURL in the Firestore document.
      await ref
          .read(firestoreProvider)
          .collection('users')
          .doc(
            ref.read(firebaseProvider).currentUser?.uid,
          )
          .update(
        <String, dynamic>{
          'photoURL': ref.watch(photoURLProvider),
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
          'isDarkMode': updatedThemeMode,
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

  // Method to set all Providers that do not autodispose back to their
  // initial state.
  void invalidateAllProviders() {
    ref.invalidate(isDarkModeProvider);
  }
}
