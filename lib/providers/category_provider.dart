import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Categories { study, work, personal }

class CategoryNotifier extends StateNotifier<Set<Categories>> {
  CategoryNotifier() : super(<Categories>{});

  void updateCategory(Categories category) {
    state = {category};
  }

  int getCategoryInt() {
    if (state.contains(Categories.study)) {
      return 0;
    } else if (state.contains(Categories.work)) {
      return 1;
    } else if (state.contains(Categories.personal)) {
      return 2;
    }
    return 2;
  }
}

final categoryProvider =
    StateNotifierProvider.autoDispose<CategoryNotifier, Set<Categories>>(
  (ref) {
    return CategoryNotifier();
  },
);
