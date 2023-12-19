import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<String> sortByDateProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  return 'dueDate';
});

final StateProvider<bool> isDescendingProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

enum SortOrder { ascending, descending }

final StateNotifierProvider<SortOrderNotifier, Set<SortOrder>>
    sortOrderProvider =
    StateNotifierProvider<SortOrderNotifier, Set<SortOrder>>(
        (StateNotifierProviderRef<SortOrderNotifier, Set<SortOrder>> ref) {
  return SortOrderNotifier();
});

class SortOrderNotifier extends StateNotifier<Set<SortOrder>> {
  SortOrderNotifier() : super(<SortOrder>{SortOrder.ascending});

  void updateSortOrder(SortOrder sortOrder, WidgetRef ref) {
    state = <SortOrder>{sortOrder};
    if (state.contains(SortOrder.ascending)) {
      ref.read(isDescendingProvider.notifier).state = false;
    } else {
      ref.read(isDescendingProvider.notifier).state = true;
    }
  }
}

final StateProvider<Set<SortOrder>> sortOrderCategoryProvider =
    StateProvider<Set<SortOrder>>((StateProviderRef<Set<SortOrder>> ref) {
  return <SortOrder>{SortOrder.ascending};
});
