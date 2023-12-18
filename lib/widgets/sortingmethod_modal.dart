import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/category_provider.dart';
import 'package:getsh_tdone/providers/date_provider.dart';
import 'package:getsh_tdone/providers/sortingmethod_provider.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/theme/theme.dart';

class SortingMethodModal extends ConsumerStatefulWidget {
  const SortingMethodModal({super.key});

  @override
  ConsumerState<SortingMethodModal> createState() {
    return SortingMethodModalState();
  }
}

class SortingMethodModalState extends ConsumerState<SortingMethodModal> {
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0,
        8.0,
        16.0,
        MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Sort your sh_t',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(thickness: 4.0),
          const SizedBox(height: 8.0),
          const Row(
            children: <Widget>[
              SortTaskCategoryChoiceSegmentedButton(),
            ],
          ),
          const SizedBox(height: 16.0),
          const Row(
            children: <Widget>[
              SortTaskDateChoiceSegmentedButton(),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(sortingMethodProvider.notifier).state = 'dueDate';
                    ref
                        .read(categoryProvider.notifier)
                        .updateCategory(Categories.all, ref);
                    Navigator.pop(context);
                  },
                  child: const Text('Remove all sorts'),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    // When the user presses OK, update the sorting method
                    // according to the sortTaskCategoryProvider that was
                    // updated in the SortTaskCategoryChoiceSegmentedButton.
                    Categories category = Categories.all;
                    DateFilter dateFilter = DateFilter.dueDate;
                    if (ref
                        .watch(sortTaskCategoryProvider)
                        .contains(Categories.personal)) {
                      category = Categories.personal;
                    } else if (ref
                        .watch(sortTaskCategoryProvider)
                        .contains(Categories.work)) {
                      category = Categories.work;
                    } else if (ref
                        .watch(sortTaskCategoryProvider)
                        .contains(Categories.study)) {
                      category = Categories.study;
                    } else if (ref
                        .watch(sortDateCategoryProvider)
                        .contains(DateFilter.dueDate)) {
                      dateFilter = DateFilter.dueDate;
                    } else if (ref
                        .watch(sortDateCategoryProvider)
                        .contains(DateFilter.createdDate)) {
                      dateFilter = DateFilter.createdDate;
                    }
                    ref
                        .read(categoryProvider.notifier)
                        .updateCategory(category, ref);
                    ref
                        .read(dateFilterProvider.notifier)
                        .updateDateFilter(dateFilter, ref);
                    Navigator.pop(context);
                  },
                  child: isSaving
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: CircularProgressIndicator(),
                        )
                      : const Text('OK'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showErrorSnack(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        behavior: SnackBarBehavior.floating,
        backgroundColor: flexSchemeLight(ref).error,
      ),
    );
  }

  void showSuccessSnack(BuildContext context, String success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class SortTaskCategoryChoiceSegmentedButton extends ConsumerStatefulWidget {
  const SortTaskCategoryChoiceSegmentedButton({super.key});

  @override
  ConsumerState<SortTaskCategoryChoiceSegmentedButton> createState() {
    return SortTaskCategoryChoiceSegmentedButtonState();
  }
}

class SortTaskCategoryChoiceSegmentedButtonState
    extends ConsumerState<SortTaskCategoryChoiceSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    Color selectedColor =
        isDarkMode ? flexSchemeDark(ref).primary : flexSchemeLight(ref).primary;
    return Expanded(
      child: SegmentedButton<Categories>(
        selected: ref.watch(sortTaskCategoryProvider),
        onSelectionChanged: (Set<Categories> newSortSelection) {
          // When the selection changes, store the value of the newSortSelection
          // in the sortTaskCategoryProvider, SEPARATE from the categoryProvider
          // so that the category is only picked here in this modal and not
          // sorted immediately.
          ref.read(sortTaskCategoryProvider.notifier).state = newSortSelection;
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                // Change the color of the button when it's selected.
                if (ref
                    .watch(sortTaskCategoryProvider)
                    .contains(Categories.personal)) {
                  selectedColor = ref.watch(isDarkModeProvider)
                      ? flexSchemeDark(ref).primary
                      : flexSchemeLight(ref).primary;
                } else if (ref
                    .watch(sortTaskCategoryProvider)
                    .contains(Categories.work)) {
                  selectedColor = ref.watch(isDarkModeProvider)
                      ? flexSchemeDark(ref).secondary
                      : flexSchemeLight(ref).secondary;
                } else if (ref
                    .watch(sortTaskCategoryProvider)
                    .contains(Categories.study)) {
                  selectedColor = ref.watch(isDarkModeProvider)
                      ? flexSchemeDark(ref).tertiary
                      : flexSchemeLight(ref).tertiary;
                }
                return selectedColor;
              }
              return Colors.transparent;
            },
          ),
        ),
        emptySelectionAllowed: true,
        segments: const <ButtonSegment<Categories>>[
          ButtonSegment<Categories>(
            value: Categories.personal,
            label: Text('Personal'),
          ),
          ButtonSegment<Categories>(
            value: Categories.work,
            label: Text('Work'),
          ),
          ButtonSegment<Categories>(
            value: Categories.study,
            label: Text('Study'),
          ),
        ],
      ),
    );
  }
}

class SortTaskDateChoiceSegmentedButton extends ConsumerStatefulWidget {
  const SortTaskDateChoiceSegmentedButton({super.key});

  @override
  ConsumerState<SortTaskDateChoiceSegmentedButton> createState() {
    return SortTaskDateChoiceSegmentedButtonState();
  }
}

class SortTaskDateChoiceSegmentedButtonState
    extends ConsumerState<SortTaskDateChoiceSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    Color selectedColor =
        isDarkMode ? flexSchemeDark(ref).primary : flexSchemeLight(ref).primary;
    return Expanded(
      child: SegmentedButton<DateFilter>(
        selected: ref.watch(sortDateCategoryProvider),
        onSelectionChanged: (Set<DateFilter> newSortSelection) {
          // When the selection changes, store the value of the newSortSelection
          // in the sortTaskCategoryProvider, SEPARATE from the categoryProvider
          // so that the category is only picked here in this modal and not
          // sorted immediately.
          ref.read(sortDateCategoryProvider.notifier).state = newSortSelection;
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                // Change the color of the button when it's selected.
                if (ref
                    .watch(sortDateCategoryProvider)
                    .contains(DateFilter.dueDate)) {
                  selectedColor = ref.watch(isDarkModeProvider)
                      ? flexSchemeDark(ref).primary
                      : flexSchemeLight(ref).primary;
                } else if (ref
                    .watch(sortDateCategoryProvider)
                    .contains(DateFilter.createdDate)) {
                  selectedColor = ref.watch(isDarkModeProvider)
                      ? flexSchemeDark(ref).primary
                      : flexSchemeLight(ref).primary;
                }
                return selectedColor;
              }
              return Colors.transparent;
            },
          ),
        ),
        emptySelectionAllowed: true,
        segments: const <ButtonSegment<DateFilter>>[
          ButtonSegment<DateFilter>(
            value: DateFilter.dueDate,
            label: Text('Due Date'),
          ),
          ButtonSegment<DateFilter>(
            value: DateFilter.createdDate,
            label: Text('Created Date'),
          ),
        ],
      ),
    );
  }
}
