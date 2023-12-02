import 'package:flutter/material.dart';
import 'package:getsh_tdone/todo.dart';

class TodoBottomSheet extends StatefulWidget {
  const TodoBottomSheet({super.key});

  @override
  State<TodoBottomSheet> createState() {
    return _TodoBottomSheetState();
  }
}

class _TodoBottomSheetState extends State<TodoBottomSheet> {
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
          16.0, 0.0, 16.0, MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add a new task'),
            const SizedBox(height: 16.0),
            TextField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('Title'),
                )),
            const SizedBox(height: 16.0),
            TextField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                maxLines: 3,
                decoration: const InputDecoration(
                  label: Text('Description'),
                )),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                todoStore.addTodo(
                  Todo(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                  ),
                );
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
