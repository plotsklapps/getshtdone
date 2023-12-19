import 'package:flutter_riverpod/flutter_riverpod.dart';

// A list of categories. For now it is not expandable.
enum Categories { all, personal, work, study }

// The provider for the category state. It always returns set of categories.
// The default value is set to all via the Notifier.
final StateNotifierProvider<CategoryNotifier, Set<Categories>>
    categoryProvider = StateNotifierProvider<CategoryNotifier, Set<Categories>>(
  (StateNotifierProviderRef<CategoryNotifier, Set<Categories>> ref) {
    return CategoryNotifier();
  },
);

class CategoryNotifier extends StateNotifier<Set<Categories>> {
  CategoryNotifier() : super(<Categories>{Categories.all});

  // This function is used to update the category state and simultaneously
  // update the categoryStringProvider state. This is used to update the
  // Strings in the UI and Firestore.
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

// This provider is used to update the UI and Firestore with the category.
final StateProvider<String> categoryStringProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  return 'all';
});

// When a new task is created, a category can be selected, but we do not
// want to update the category state just yet. This provider is used to
// temporarily store the category state until the task is actually created.
// This way we can show different states in the UI, without immediately
// storing to Firestore.
final StateProvider<Set<Categories>> newTaskCategoryProvider =
    StateProvider<Set<Categories>>((StateProviderRef<Set<Categories>> ref) {
  return <Categories>{Categories.all};
});

// Same as above, but now for updating categories. So the UI can change, but
// the backend does not update yet.
final StateProvider<Set<Categories>> updateTaskCategoryProvider =
    StateProvider<Set<Categories>>((StateProviderRef<Set<Categories>> ref) {
  return <Categories>{Categories.all};
});

// Same as above, but now for sorting categories. So the UI can change, but
// the backend does not update yet.
final StateProvider<Set<Categories>> sortTaskCategoryProvider =
    StateProvider<Set<Categories>>((StateProviderRef<Set<Categories>> ref) {
  return <Categories>{Categories.all};
});
