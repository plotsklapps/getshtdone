import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/providers/category_provider.dart';
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
        MediaQuery.of(context).viewInsets.bottom,
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
          const SizedBox(height: 8.0),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.arrowDownWideShort),
            title: const Text('By due date (default)'),
            subtitle: const Text('Show the most urgent tasks first'),
            onTap: () {
              ref.read(sortingMethodProvider.notifier).state = 'dueDate';
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.arrowDownWideShort),
            title: const Text('By creation date'),
            subtitle: const Text('Show the newest tasks first'),
            onTap: () {
              ref.read(sortingMethodProvider.notifier).state = 'createdDate';
              Navigator.pop(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(sortingMethodProvider.notifier).state =
                          'dueDate';
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
                      // TODO(plotsklapps): Continue here!
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
          ref.read(sortTaskCategoryProvider.notifier).state = newSortSelection;
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
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
