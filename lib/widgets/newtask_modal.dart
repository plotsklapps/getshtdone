import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/category_provider.dart';

class NewTaskModal extends ConsumerStatefulWidget {
  const NewTaskModal({
    super.key,
  });

  @override
  ConsumerState<NewTaskModal> createState() {
    return NewTaskModalState();
  }
}

class NewTaskModalState extends ConsumerState<NewTaskModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24.0,
        0.0,
        24.0,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create new sh_t to do',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 4,
          ),
          SizedBox(height: 8.0),
          TextField(
            decoration: InputDecoration(
              labelText: 'New TODO Title',
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'New TODO Description',
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NewTaskCategoryChoiceSegmentedButton(),
            ],
          ),
          SizedBox(height: 12.0),
          Row(
            children: [
              NewTaskDatePickerButton(),
              SizedBox(width: 16.0),
              NewTaskTimePickerButton(),
            ],
          ),
          Row(
            children: [
              NewTaskCancelButton(),
              SizedBox(width: 16.0),
              NewTaskSaveButton(),
            ],
          ),
          SizedBox(height: 20.0),
        ],
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
    return Expanded(
      child: SegmentedButton<Categories>(
        selected: ref.watch(categoryProvider),
        onSelectionChanged: (Set<Categories> newSelection) {
          if (newSelection.contains(Categories.study)) {
            ref
                .read(categoryProvider.notifier)
                .updateCategory(Categories.study);
          } else if (newSelection.contains(Categories.work)) {
            ref.read(categoryProvider.notifier).updateCategory(Categories.work);
          } else if (newSelection.contains(Categories.personal)) {
            ref
                .read(categoryProvider.notifier)
                .updateCategory(Categories.personal);
          }
        },
        emptySelectionAllowed: true,
        segments: const <ButtonSegment<Categories>>[
          ButtonSegment<Categories>(
            value: Categories.study,
            label: Text('Study'),
          ),
          ButtonSegment<Categories>(
            value: Categories.work,
            label: Text('Work'),
          ),
          ButtonSegment<Categories>(
            value: Categories.personal,
            label: Text('personal'),
          ),
        ],
      ),
    );
  }
}

class NewTaskDatePickerButton extends StatelessWidget {
  const NewTaskDatePickerButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_calendar_rounded),
            SizedBox(width: 8.0),
            Text('Add Due Date'),
          ],
        ),
      ),
    );
  }
}

class NewTaskTimePickerButton extends StatelessWidget {
  const NewTaskTimePickerButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.alarm_rounded),
            SizedBox(width: 8.0),
            Text('Add Due Time'),
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
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_rounded),
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_rounded),
            SizedBox(width: 8.0),
            Text('Save'),
          ],
        ),
      ),
    );
  }
}
