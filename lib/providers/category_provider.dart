import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Categories { study, work, personal }

class CategoryNotifier extends StateNotifier<Set<Categories>> {
  CategoryNotifier() : super(<Categories>{Categories.personal});

  void updateCategory(Categories category) {
    state = <Categories>{category};
  }

  String getCategoryString() {
    if (state.contains(Categories.study)) {
      return 'Study';
    } else if (state.contains(Categories.work)) {
      return 'Work';
    } else if (state.contains(Categories.personal)) {
      return 'Personal';
    }
    return 'Personal';
  }
}

final AutoDisposeStateNotifierProvider<CategoryNotifier, Set<Categories>>
    categoryProvider =
    StateNotifierProvider.autoDispose<CategoryNotifier, Set<Categories>>(
  (AutoDisposeStateNotifierProviderRef<CategoryNotifier, Set<Categories>> ref) {
    return CategoryNotifier();
  },
);

final Provider<String> categoryStringProvider =
    Provider<String>((ProviderRef<String> ref) {
  final String categoryString =
      ref.read(categoryProvider.notifier).getCategoryString();
  return categoryString;
});
