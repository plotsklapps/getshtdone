import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/providers/category_provider.dart';
import 'package:getsh_tdone/providers/date_provider.dart';
import 'package:getsh_tdone/providers/sortingmethod_provider.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/theme/theme.dart';
import 'package:logger/logger.dart';

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
          const Row(
            children: <Widget>[
              SortTaskAscendingChoiceSegmentedButton(),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              RemoveAllSorts(ref: ref),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    setState(() {
                      isSaving = true;
                    });
                    // When the user presses OK, update the sorting method
                    // according to the sortTaskCategoryProvider that was
                    // updated in the SortTaskCategoryChoiceSegmentedButton.
                    final Categories category =
                        ref.watch(sortTaskCategoryProvider).first;
                    final DateFilter dateFilter =
                        ref.watch(sortDateCategoryProvider).first;
                    final SortOrder sortOrder =
                        ref.watch(sortOrderCategoryProvider).first;
                    ref
                        .read(categoryProvider.notifier)
                        .updateCategory(category, ref);
                    ref
                        .read(dateFilterProvider.notifier)
                        .updateDateFilter(dateFilter, ref);
                    ref
                        .read(sortOrderProvider.notifier)
                        .updateSortOrder(sortOrder, ref);
                    setState(() {
                      isSaving = false;
                    });
                    Navigator.pop(context);
                  },
                  child: isSaving
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Sort'),
                ),
              ),
            ],
          ),
        ],
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
                // Change the color of the button when it's selected, defaults
                // to Categories.all and is secondaryContainer color.
                if (ref
                    .watch(sortTaskCategoryProvider)
                    .contains(Categories.all)) {
                  selectedColor = isDarkMode
                      ? flexSchemeDark(ref).secondaryContainer
                      : flexSchemeLight(ref).secondaryContainer;
                } else if (ref
                    .watch(sortTaskCategoryProvider)
                    .contains(Categories.personal)) {
                  selectedColor = isDarkMode
                      ? flexSchemeDark(ref).primary
                      : flexSchemeLight(ref).primary;
                } else if (ref
                    .watch(sortTaskCategoryProvider)
                    .contains(Categories.work)) {
                  selectedColor = isDarkMode
                      ? flexSchemeDark(ref).secondary
                      : flexSchemeLight(ref).secondary;
                } else if (ref
                    .watch(sortTaskCategoryProvider)
                    .contains(Categories.study)) {
                  selectedColor = isDarkMode
                      ? flexSchemeDark(ref).tertiary
                      : flexSchemeLight(ref).tertiary;
                }
                return selectedColor;
              }
              return Colors.transparent;
            },
          ),
        ),
        segments: const <ButtonSegment<Categories>>[
          ButtonSegment<Categories>(
            value: Categories.all,
            label: Text('All'),
          ),
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
    return Expanded(
      child: SegmentedButton<DateFilter>(
        selected: ref.watch(sortDateCategoryProvider),
        onSelectionChanged: (Set<DateFilter> newSortDateSelection) {
          ref.read(sortDateCategoryProvider.notifier).state =
              newSortDateSelection;
        },
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

class SortTaskAscendingChoiceSegmentedButton extends ConsumerStatefulWidget {
  const SortTaskAscendingChoiceSegmentedButton({super.key});

  @override
  ConsumerState<SortTaskAscendingChoiceSegmentedButton> createState() {
    return SortTaskAscendingChoiceSegmentedButtonState();
  }
}

class SortTaskAscendingChoiceSegmentedButtonState
    extends ConsumerState<SortTaskAscendingChoiceSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SegmentedButton<SortOrder>(
        selected: ref.watch(sortOrderCategoryProvider),
        onSelectionChanged: (Set<SortOrder> newSortOrderSelection) {
          ref.read(sortOrderCategoryProvider.notifier).state =
              newSortOrderSelection;
          Logger().w('After making choice: $newSortOrderSelection');
          Logger().w(ref.watch(isDescendingProvider));
        },
        segments: const <ButtonSegment<SortOrder>>[
          ButtonSegment<SortOrder>(
            value: SortOrder.ascending,
            label: Text('Ascending'),
          ),
          ButtonSegment<SortOrder>(
            value: SortOrder.descending,
            label: Text('Descending'),
          ),
        ],
      ),
    );
  }
}

class RemoveAllSorts extends StatelessWidget {
  const RemoveAllSorts({
    required this.ref,
    super.key,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          ref
            ..invalidate(categoryProvider)
            ..invalidate(categoryStringProvider)
            ..invalidate(sortTaskCategoryProvider)
            ..invalidate(dateFilterProvider)
            ..invalidate(sortDateCategoryProvider)
            ..invalidate(sortByDateProvider)
            ..invalidate(isDescendingProvider)
            ..invalidate(sortOrderProvider)
            ..invalidate(sortOrderCategoryProvider);
          Navigator.pop(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(
              FontAwesomeIcons.trash,
              color: isDarkMode
                  ? flexSchemeDark(ref).error
                  : flexSchemeLight(ref).error,
            ),
            const SizedBox(width: 16.0),
            Text(
              'Remove all sorts',
              style: TextStyle(
                color: isDarkMode
                    ? flexSchemeDark(ref).error
                    : flexSchemeLight(ref).error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
