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

// Provider for the date of creation of the task. Formats it to a String and
// auto disposes it.
final AutoDisposeStateProvider<String> createdDateProvider =
    StateProvider.autoDispose<String>((
  AutoDisposeStateProviderRef<String> ref,
) {
  final DateTime creationDate = DateTime.now();
  final String formattedDate = DateFormat('yyyy/MM/dd').format(creationDate);
  return formattedDate;
});

// Provider for the due date. Formats it to a String and auto disposes it.
final AutoDisposeStateProvider<String> dueDateProvider =
    StateProvider.autoDispose<String>((
  AutoDisposeStateProviderRef<String> ref,
) {
  final String createdDate = ref.watch(createdDateProvider);
  final DateFormat format = DateFormat('yyyy/MM/dd');
  final DateTime dueDate = format.parse(createdDate);
  final DateTime dueDatePlusWeek = dueDate.add(const Duration(days: 7));
  final String formattedDate = format.format(dueDatePlusWeek);
  return formattedDate;
});

// Provider for the date of creation of the account. First, it fetches
// the user from the firebaseProvider, then it fetches the creationTime
// for that user and formats it to a String and auto disposes it.
final AutoDisposeStateProvider<String> creationDateProvider =
    StateProvider.autoDispose<String>((StateProviderRef<String> ref) {
  final User? user = ref.watch(firebaseProvider).currentUser;
  final DateTime? creationDate = user?.metadata.creationTime;
  if (creationDate != null) {
    final String formattedDate = DateFormat('yyyy/MM/dd').format(creationDate);
    return formattedDate;
  } else {
    return 'NEVER';
  }
});

// Provider for the date of the last sign in. First, it fetches
// the user from the firebaseProvider, then it fetches the lastSignInTime
// for that user and formats it to a String and auto disposes it.
final AutoDisposeStateProvider<String> lastSignInDateProvider =
    StateProvider.autoDispose<String>((StateProviderRef<String> ref) {
  final User? user = ref.watch(firebaseProvider).currentUser;
  final DateTime? lastSignInDate = user?.metadata.lastSignInTime;
  if (lastSignInDate != null) {
    final String formattedDate =
        DateFormat('yyyy/MM/dd').format(lastSignInDate);
    return formattedDate;
  } else {
    return 'NEVER';
  }
});
