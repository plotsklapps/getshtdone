import 'package:flutter/material.dart';
import 'package:getsh_tdone/all_signals.dart';

class NewTaskGroupBottomSheet extends StatefulWidget {
  const NewTaskGroupBottomSheet({super.key});

  @override
  State<NewTaskGroupBottomSheet> createState() {
    return NewTaskGroupBottomSheetState();
  }
}

class NewTaskGroupBottomSheetState extends State<NewTaskGroupBottomSheet> {
  late TextEditingController taskGroupTitle;

  @override
  void initState() {
    super.initState();
    taskGroupTitle = TextEditingController();
  }

  @override
  void dispose() {
    taskGroupTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0,
        0.0,
        16.0,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add a new task group'),
            const SizedBox(height: 16.0),
            TextField(
              controller: taskGroupTitle,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                label: Text('Task group title'),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                taskGroupList.add(taskGroupTitle.text.trim());
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
