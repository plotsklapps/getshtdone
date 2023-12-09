import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/providers/todolist_provider.dart';
import 'package:getsh_tdone/theme/theme.dart';

class TodoCard extends ConsumerWidget {
  const TodoCard(
    this.todo, {
    super.key,
  });
  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: ref.watch(isDarkModeProvider)
              ? flexSchemeDark.primary
              : flexSchemeLight.primary,
        ),
      ),
      child: SizedBox(
        height: 140.0,
        child: Row(
          children: <Widget>[
            Container(
              width: 20.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                ),
                color: ref.watch(isDarkModeProvider)
                    ? flexSchemeDark.primary
                    : flexSchemeLight.primary,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        ref
                            .read(todoListProvider.notifier)
                            .toggleCompleted(todo.id!);
                      },
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        todo.title,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                      subtitle: Text(
                        todo.description ?? 'No Description',
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
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
      ),
    );
  }
}
