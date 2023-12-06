import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/theme/theme.dart';

class TodoCard extends ConsumerWidget {
  const TodoCard(
    this.todo, {
    super.key,
  });
  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      height: 140.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: flexSchemeDark.tertiary,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 20.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
              ),
              color: flexSchemeDark.tertiary,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(todo.title),
                    subtitle: Text(
                      todo.description ?? 'No Description',
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                    ),
                    trailing: todo.isCompleted
                        ? const FaIcon(FontAwesomeIcons.circleCheck)
                        : const FaIcon(FontAwesomeIcons.circle),
                  ),
                  const Divider(thickness: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(todo.dueDate ?? 'No Due Date'),
                      const SizedBox(width: 8.0),
                      Text(todo.dueTime ?? 'No Due Time'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
