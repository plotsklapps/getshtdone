import 'package:flutter/material.dart';
import 'package:getsh_tdone/widgets/datepicker_alert.dart';
import 'package:getsh_tdone/widgets/timepicker_alert.dart';

class NewTaskModal extends StatefulWidget {
  const NewTaskModal({
    super.key,
  });

  @override
  State<NewTaskModal> createState() {
    return NewTaskModalState();
  }
}

class NewTaskModalState extends State<NewTaskModal> {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NewTaskDatePickerButton(),
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
        ],
      ),
    );
  }
}

enum Categories { study, work, personal }

class NewTaskCategoryChoiceSegmentedButton extends StatefulWidget {
  const NewTaskCategoryChoiceSegmentedButton({super.key});

  @override
  State<NewTaskCategoryChoiceSegmentedButton> createState() {
    return NewTaskCategoryChoiceSegmentedButtonState();
  }
}

class NewTaskCategoryChoiceSegmentedButtonState
    extends State<NewTaskCategoryChoiceSegmentedButton> {
  Set<Categories> selection = <Categories>{};

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SegmentedButton<Categories>(
        selected: selection,
        onSelectionChanged: (Set<Categories> newSelection) {
          setState(() {
            selection = newSelection;
          });
        },
        emptySelectionAllowed: true,
        multiSelectionEnabled: true,
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
    return TextButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (context) {
            return const DatePickerAlert();
          },
        );
      },
      child: const Row(
        children: [
          Icon(Icons.edit_calendar_rounded),
          SizedBox(width: 8.0),
          Text('Add Due Date'),
        ],
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
    return TextButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (context) {
            return const TimePickerAlert();
          },
        );
      },
      child: const Row(
        children: [
          Icon(Icons.alarm_rounded),
          SizedBox(width: 8.0),
          Text('Add Due Time'),
        ],
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
