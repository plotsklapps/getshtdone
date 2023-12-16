import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/providers/category_provider.dart';
import 'package:getsh_tdone/providers/date_provider.dart';
import 'package:getsh_tdone/providers/description_provider.dart';
import 'package:getsh_tdone/providers/iscompleted_provider.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/providers/title_provider.dart';
import 'package:getsh_tdone/services/firestore_service.dart';
import 'package:getsh_tdone/services/logger.dart';
import 'package:getsh_tdone/theme/theme.dart';
import 'package:intl/intl.dart';

class NewTodoModal extends ConsumerStatefulWidget {
  const NewTodoModal({
    super.key,
  });

  @override
  ConsumerState<NewTodoModal> createState() {
    return NewTodoModalState();
  }
}

class NewTodoModalState extends ConsumerState<NewTodoModal> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24.0,
        0.0,
        24.0,
        MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          dragDevices: <PointerDeviceKind>{
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.stylus,
          },
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Create new sh_t to do',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 4,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: titleController,
                onChanged: (String newTitle) {
                  ref.read(titleProvider.notifier).state = newTitle;
                },
                decoration: const InputDecoration(
                  labelText: 'New Task Title',
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: descriptionController,
                onChanged: (String newDescription) {
                  ref.read(descriptionProvider.notifier).state = newDescription;
                },
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'New Task Description',
                ),
              ),
              const SizedBox(height: 16.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NewTaskCategoryChoiceSegmentedButton(),
                ],
              ),
              const SizedBox(height: 12.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NewTaskDatePickerButton(),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  const NewTaskCancelButton(),
                  const SizedBox(width: 16.0),
                  NewTaskSaveButton(
                    ref: ref,
                    titleController: titleController,
                    descriptionController: descriptionController,
                    mounted: mounted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewTaskCategoryChoiceSegmentedButton extends ConsumerStatefulWidget {
  const NewTaskCategoryChoiceSegmentedButton({super.key});

  @override
  ConsumerState<NewTaskCategoryChoiceSegmentedButton> createState() {
    return NewTaskCategoryChoiceSegmentedButtonState();
  }
}

class NewTaskCategoryChoiceSegmentedButtonState
    extends ConsumerState<NewTaskCategoryChoiceSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    Color selectedColor = flexSchemeLight(ref).primary;
    return Expanded(
      child: SegmentedButton<Categories>(
        selected: ref.watch(categoryProvider),
        onSelectionChanged: (Set<Categories> newSelection) {
          if (newSelection.contains(Categories.personal)) {
            ref
                .read(categoryProvider.notifier)
                .updateCategory(Categories.personal, ref);
          } else if (newSelection.contains(Categories.work)) {
            ref
                .read(categoryProvider.notifier)
                .updateCategory(Categories.work, ref);
          } else if (newSelection.contains(Categories.study)) {
            ref
                .read(categoryProvider.notifier)
                .updateCategory(Categories.study, ref);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                if (ref.watch(categoryProvider).contains(Categories.personal)) {
                  selectedColor = ref.watch(isDarkModeProvider)
                      ? flexSchemeDark(ref).primary
                      : flexSchemeLight(ref).primary;
                } else if (ref
                    .watch(categoryProvider)
                    .contains(Categories.work)) {
                  selectedColor = ref.watch(isDarkModeProvider)
                      ? flexSchemeDark(ref).secondary
                      : flexSchemeLight(ref).secondary;
                } else if (ref
                    .watch(categoryProvider)
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

class NewTaskDatePickerButton extends ConsumerWidget {
  const NewTaskDatePickerButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () async {
          await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          ).then((DateTime? datePicked) {
            if (datePicked != null) {
              final String formattedDate =
                  DateFormat('dd/MM/yyyy').format(datePicked);
              ref.read(dueDateProvider.notifier).state = formattedDate;
              return null;
            }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const FaIcon(FontAwesomeIcons.flagCheckered),
            const SizedBox(width: 16.0),
            Text(ref.watch(dueDateProvider)),
          ],
        ),
      ),
    );
  }
}

class NewTaskCancelButton extends StatelessWidget {
  const NewTaskCancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(FontAwesomeIcons.trash),
            SizedBox(width: 8.0),
            Text('Cancel'),
          ],
        ),
      ),
    );
  }
}

class NewTaskSaveButton extends StatelessWidget {
  const NewTaskSaveButton({
    required this.ref,
    required this.titleController,
    required this.descriptionController,
    required this.mounted,
    super.key,
  });

  final WidgetRef ref;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton(
        onPressed: () async {
          await FirestoreService(ref).addTodo(
            Todo(
              title: ref.watch(titleProvider),
              description: ref.watch(descriptionProvider),
              category: ref.watch(categoryStringProvider),
              createdDate: ref.watch(createdDateProvider),
              dueDate: ref.watch(dueDateProvider),
              isCompleted: false,
            ),
          );
          titleController.clear();
          descriptionController.clear();
          ref
            ..invalidate(titleProvider)
            ..invalidate(descriptionProvider)
            ..invalidate(categoryProvider)
            ..invalidate(createdDateProvider)
            ..invalidate(dueDateProvider)
            ..invalidate(isCompletedProvider);
          Logs.addTodoComplete();
          if (mounted) {
            Navigator.pop(context);
          }
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(FontAwesomeIcons.solidFloppyDisk),
            SizedBox(width: 8.0),
            Text('Save'),
          ],
        ),
      ),
    );
  }
}
