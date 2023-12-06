import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<String> descriptionProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  return '';
});
