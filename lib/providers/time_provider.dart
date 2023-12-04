import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeProvider = StateProvider.autoDispose<String>((ref) {
  return 'Add due time';
});
