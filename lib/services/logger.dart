import 'package:logger/logger.dart';

class Logs {
  static void userUnknown() {
    Logger().w('User is not logged in or verified, going to LoginScreen');
  }

  static void userKnown() {
    Logger().i('User is logged in or verified, going to HomeScreen');
  }

  static void signupComplete() {
    Logger().i('User is created, verification email sent');
  }

  static void signupFailed() {
    Logger().w('User creation failed');
  }

  static void loginComplete() {
    Logger().i('User is logged in');
  }

  static void loginFailed() {
    Logger().w('User login failed');
  }

  static void resetPasswordComplete() {
    Logger().i('Password reset email sent');
  }

  static void resetPasswordFailed() {
    Logger().w('Password reset email failed');
  }

  static void sneakPeekComplete() {
    Logger().i('User is sneak peeking');
  }

  static void displayNameChangeComplete() {
    Logger().i('User display name changed');
  }

  static void displayNameChangeFailed() {
    Logger().w('User display name change failed');
  }

  static void avatarChangeComplete() {
    Logger().i('User avatar changed');
  }

  static void avatarChangeFailed() {
    Logger().w('User avatar change failed');
  }

  static void signOutComplete() {
    Logger().i('User is signed out');
  }

  static void signOutFailed() {
    Logger().w('User sign out failed');
  }

  static void deleteUserComplete() {
    Logger().i('User is deleted');
  }

  static void deleteUserFailed() {
    Logger().w('User deletion failed');
  }

  static void themeModeChangeComplete() {
    Logger().i('Theme mode changed');
  }

  static void themeModeChangeFailed() {
    Logger().w('Theme mode change failed');
  }

  static void themeColorChangeComplete() {
    Logger().i('Theme color changed');
  }

  static void themeColorChangeFailed() {
    Logger().w('Theme color change failed');
  }

  static void addTaskComplete() {
    Logger().i('Task is added to Firestore');
  }

  static void addTaskFailed() {
    Logger().w('Task addition to Firestore failed');
  }

  static void toggleTaskComplete() {
    Logger().i('Task is toggled in Firestore');
  }

  static void toggleTaskFailed() {
    Logger().w('Task toggle in Firestore failed');
  }

  static void updateTaskComplete() {
    Logger().i('Task is updated in Firestore');
  }

  static void updateTaskFailed() {
    Logger().w('Task update in Firestore failed');
  }
}
