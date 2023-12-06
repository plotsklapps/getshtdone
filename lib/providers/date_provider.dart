import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeStateProvider<String> dateProvider =
    StateProvider.autoDispose<String>((
  AutoDisposeStateProviderRef<String> ref,
) {
  return 'Add due date';
});
