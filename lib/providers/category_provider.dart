import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Categories { all, personal, work, study }

final AutoDisposeStateNotifierProvider<CategoryNotifier, Set<Categories>>
    categoryProvider =
    StateNotifierProvider.autoDispose<CategoryNotifier, Set<Categories>>(
  (AutoDisposeStateNotifierProviderRef<CategoryNotifier, Set<Categories>> ref) {
    return CategoryNotifier();
  },
);

class CategoryNotifier extends StateNotifier<Set<Categories>> {
  CategoryNotifier() : super(<Categories>{Categories.all});

  void updateCategory(Categories category, WidgetRef ref) {
    state = <Categories>{category};
    if (state.contains(Categories.personal)) {
      ref.read(categoryStringProvider.notifier).state = 'personal';
    } else if (state.contains(Categories.work)) {
      ref.read(categoryStringProvider.notifier).state = 'work';
    } else if (state.contains(Categories.study)) {
      ref.read(categoryStringProvider.notifier).state = 'study';
    } else {
      ref.read(categoryStringProvider.notifier).state = 'all';
    }
  }
}

final StateProvider<String> categoryStringProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  return 'all';
});

final StateProvider<Set<Categories>> newTodoCategoryProvider =
    StateProvider<Set<Categories>>((StateProviderRef<Set<Categories>> ref) {
  return <Categories>{Categories.all};
});
