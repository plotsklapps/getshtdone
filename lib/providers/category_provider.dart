import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Categories { study, work, personal }

final AutoDisposeStateNotifierProvider<CategoryNotifier, Set<Categories>>
    categoryProvider =
    StateNotifierProvider.autoDispose<CategoryNotifier, Set<Categories>>(
  (AutoDisposeStateNotifierProviderRef<CategoryNotifier, Set<Categories>> ref) {
    return CategoryNotifier();
  },
);

class CategoryNotifier extends StateNotifier<Set<Categories>> {
  CategoryNotifier() : super(<Categories>{Categories.personal});

  void updateCategory(Categories category, WidgetRef ref) {
    state = <Categories>{category};
    if (state.contains(Categories.personal)) {
      ref.read(categoryStringProvider.notifier).state = 'Personal';
    } else if (state.contains(Categories.work)) {
      ref.read(categoryStringProvider.notifier).state = 'Work';
    } else if (state.contains(Categories.study)) {
      ref.read(categoryStringProvider.notifier).state = 'Study';
    }
  }
}

final StateProvider<String> categoryStringProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  return 'Personal';
});
