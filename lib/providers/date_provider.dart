import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';
import 'package:intl/intl.dart';

// Provider for the current date. Formats it to a String.
final AutoDisposeStateProvider<String> dateProvider =
    StateProvider.autoDispose<String>((StateProviderRef<String> ref) {
  final String formattedDate = DateFormat.yMMMMEEEEd().format(DateTime.now());
  return formattedDate;
});

// Provider for the due date. Formats it to a String and auto disposes it.
final AutoDisposeStateProvider<String> dueDateProvider =
    StateProvider.autoDispose<String>((
  AutoDisposeStateProviderRef<String> ref,
) {
  return 'Add due date';
});

// Provider for the date of creation of the account. First, it fetches
// the user from the firebaseProvider, then it fetches the creationTime
// for that user and formats it to a String and auto disposes it.
final AutoDisposeProvider<String> creationDateProvider =
    Provider.autoDispose<String>((ProviderRef<String> ref) {
  final User? user = ref.watch(firebaseProvider).currentUser;
  final DateTime? creationDate = user?.metadata.creationTime;
  if (creationDate != null) {
    final String formattedDate = DateFormat('dd-MM-yyyy').format(creationDate);
    return formattedDate;
  } else {
    return 'NEVER';
  }
});

// Provider for the date of the last sign in. First, it fetches
// the user from the firebaseProvider, then it fetches the lastSignInTime
// for that user and formats it to a String and auto disposes it.
final AutoDisposeProvider<String> lastSignInDateProvider =
    Provider.autoDispose<String>((ProviderRef<String> ref) {
  final User? user = ref.watch(firebaseProvider).currentUser;
  final DateTime? lastSignInDate = user?.metadata.lastSignInTime;
  if (lastSignInDate != null) {
    final String formattedDate =
        DateFormat('dd-MM-yyyy').format(lastSignInDate);
    return formattedDate;
  } else {
    return 'NEVER';
  }
});
