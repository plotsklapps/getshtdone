import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateProvider = StateProvider.autoDispose<String>((ref) {
  return 'Add due date';
});
