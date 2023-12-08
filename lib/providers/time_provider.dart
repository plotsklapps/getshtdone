import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeStateProvider<String> dueTimeProvider =
    StateProvider.autoDispose<String>((
  AutoDisposeStateProviderRef<String> ref,
) {
  return 'Add due time';
});
