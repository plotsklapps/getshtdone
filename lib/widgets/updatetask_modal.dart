import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/models/task_model.dart';
import 'package:getsh_tdone/providers/category_provider.dart';
import 'package:getsh_tdone/providers/date_provider.dart';
import 'package:getsh_tdone/providers/description_provider.dart';
import 'package:getsh_tdone/providers/iscompleted_provider.dart';
import 'package:getsh_tdone/providers/title_provider.dart';
import 'package:getsh_tdone/services/firestore_service.dart';
import 'package:getsh_tdone/services/logger.dart';
import 'package:getsh_tdone/theme/theme.dart';
import 'package:intl/intl.dart';

class UpdateTaskModal extends ConsumerStatefulWidget {
  const UpdateTaskModal(
    this.task, {
    super.key,
  });

  final Task task;

  @override
  ConsumerState<UpdateTaskModal> createState() {
    return UpdateTaskModalState();
  }
}

class UpdateTaskModalState extends ConsumerState<UpdateTaskModal> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    // Set the initial values of the text controllers to the current values of
    // the task.
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    // Set the initial values of the providers to the current values of the
    // task.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(titleProvider.notifier).state = widget.task.title;
      ref.read(descriptionProvider.notifier).state = widget.task.description!;
    });
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
                    'Update your Task',
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
                onChanged: (String updatedTitle) {
                  // Store the updated title in the state.
                  ref.read(titleProvider.notifier).state = updatedTitle;
                },
                decoration: const InputDecoration(
                  labelText: 'Update Task Title',
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: descriptionController,
                onChanged: (String updatedDescription) {
                  // Store the updated description in the state.
                  ref.read(descriptionProvider.notifier).state =
                      updatedDescription;
                },
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Update Task Description',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Widget that allows the user to select the category of the
                  // task (Default to old category).
                  UpdateTaskCategoryChoiceSegmentedButton(widget.task),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                children: <Widget>[
                  // Widget that allows the user to select the due date of the
                  // task (Defaults to old due date).
                  UpdateTaskDatePickerButton(widget.task.dueDate),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  // Widget that allows the user to cancel the creation of the
                  // updated task.
                  const UpdateTaskCancelButton(),
                  const SizedBox(width: 16.0),
                  // Widget that allows the user to save the updated task to
                  // Firestore database.
                  UpdateTaskSaveButton(
                    ref: ref,
                    id: widget.task.id!,
                    oldTitle: widget.task.title,
                    oldDescription: widget.task.description,
                    oldCreatedDate: widget.task.createdDate,
                    oldDueDate: widget.task.dueDate,
                    titleController: titleController,
                    descriptionController: descriptionController,
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

class UpdateTaskCategoryChoiceSegmentedButton extends ConsumerStatefulWidget {
  const UpdateTaskCategoryChoiceSegmentedButton(this.task, {super.key});

  final Task task;

  @override
  ConsumerState<UpdateTaskCategoryChoiceSegmentedButton> createState() {
    return UpdateTaskCategoryChoiceSegmentedButtonState();
  }
}

class UpdateTaskCategoryChoiceSegmentedButtonState
    extends ConsumerState<UpdateTaskCategoryChoiceSegmentedButton> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Categories initialCategory;
      if (widget.task.category == 'personal') {
        initialCategory = Categories.personal;
      } else if (widget.task.category == 'work') {
        initialCategory = Categories.work;
      } else if (widget.task.category == 'study') {
        initialCategory = Categories.study;
      } else {
        initialCategory = Categories.personal;
      }
      ref.read(updateTaskCategoryProvider.notifier).state = <Categories>{
        initialCategory,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor =
        sIsDark.value ? cFlexSchemeDark().primary : cFlexSchemeLight().primary;
    return Expanded(
      child: SegmentedButton<Categories>(
        selected: ref.watch(updateTaskCategoryProvider),
        onSelectionChanged: (Set<Categories> updatedSelection) {
          ref.read(updateTaskCategoryProvider.notifier).state =
              updatedSelection;
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                if (ref
                    .watch(updateTaskCategoryProvider)
                    .contains(Categories.personal)) {
                  selectedColor = sIsDark.value
                      ? cFlexSchemeDark().primary
                      : cFlexSchemeLight().primary;
                } else if (ref
                    .watch(updateTaskCategoryProvider)
                    .contains(Categories.work)) {
                  selectedColor = sIsDark.value
                      ? cFlexSchemeDark().secondary
                      : cFlexSchemeLight().secondary;
                } else if (ref
                    .watch(updateTaskCategoryProvider)
                    .contains(Categories.study)) {
                  selectedColor = sIsDark.value
                      ? cFlexSchemeDark().tertiary
                      : cFlexSchemeLight().tertiary;
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

class UpdateTaskDatePickerButton extends ConsumerWidget {
  const UpdateTaskDatePickerButton(
    this.dueDate, {
    super.key,
  });

  final String? dueDate;

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
                  DateFormat('yyyy/MM/dd').format(datePicked);
              ref.read(dueDateProvider.notifier).state = formattedDate;
              return null;
            }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.edit_calendar_rounded),
            const SizedBox(width: 8.0),
            Text(ref.watch(dueDateProvider) ?? 'No due date set'),
          ],
        ),
      ),
    );
  }
}

class UpdateTaskCancelButton extends StatelessWidget {
  const UpdateTaskCancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.delete_rounded),
            SizedBox(width: 8.0),
            Text('Cancel'),
          ],
        ),
      ),
    );
  }
}

class UpdateTaskSaveButton extends StatelessWidget {
  const UpdateTaskSaveButton({
    required this.ref,
    required this.id,
    required this.titleController,
    required this.descriptionController,
    super.key,
    this.oldTitle,
    this.oldDescription,
    this.oldCreatedDate,
    this.oldDueDate,
  });

  final WidgetRef ref;
  final String id;
  final String? oldTitle;
  final String? oldDescription;
  final String? oldCreatedDate;
  final String? oldDueDate;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton(
        onPressed: () async {
          try {
            await FirestoreService(ref).updateTask(
              Task(
                id: id,
                title: ref.watch(titleProvider),
                description: ref.watch(descriptionProvider),
                category: ref
                    .watch(updateTaskCategoryProvider)
                    .first
                    .toString()
                    .split('.')
                    .last,
                createdDate: oldCreatedDate,
                dueDate: ref.watch(dueDateProvider),
                isCompleted: false,
              ),
            );
            titleController.clear();
            descriptionController.clear();
            ref
              ..invalidate(titleProvider)
              ..invalidate(descriptionProvider)
              ..invalidate(updateTaskCategoryProvider)
              ..invalidate(createdDateProvider)
              ..invalidate(dueDateProvider)
              ..invalidate(isCompletedProvider);
            Logs.updateTaskComplete();
            Navigator.pop(context);
          } catch (error) {
            Logs.updateTaskFailed();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to update Task: $error',
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: sIsDark.value
                    ? cFlexSchemeDark().error
                    : cFlexSchemeLight().error,
              ),
            );
          }
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.save_rounded,
            ),
            SizedBox(width: 8.0),
            Text(
              'Save',
            ),
          ],
        ),
      ),
    );
  }
}
