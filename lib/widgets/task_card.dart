import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/models/task_model.dart';
import 'package:getsh_tdone/providers/tasklist_provider.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/theme/theme.dart';
import 'package:getsh_tdone/widgets/updatetask_modal.dart';

class TaskCard extends ConsumerWidget {
  const TaskCard(
    this.task, {
    super.key,
  });
  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    return GestureDetector(
      onLongPress: () async {
        await showModalBottomSheet<Widget>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return UpdateTaskModal(task);
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: task.isCompleted
                ? ref.watch(isDarkModeProvider)
                    ? flexSchemeDark(ref).primary
                    : flexSchemeLight(ref).primary
                : ref.watch(isDarkModeProvider)
                    ? flexSchemeDark(ref).outline
                    : flexSchemeLight(ref).outline,
            width: 2.0,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                    ),
                    color: task.category == 'personal'
                        ? isDarkMode
                            ? flexSchemeDark(ref).primary
                            : flexSchemeLight(ref).primary
                        : task.category == 'work'
                            ? isDarkMode
                                ? flexSchemeDark(ref).secondary
                                : flexSchemeLight(ref).secondary
                            : task.category == 'study'
                                ? isDarkMode
                                    ? flexSchemeDark(ref).tertiary
                                    : flexSchemeLight(ref).tertiary
                                : flexSchemeLight(ref).primary,
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            task.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 22.0,
                              color: task.isCompleted
                                  ? ref.watch(isDarkModeProvider)
                                      ? flexSchemeDark(ref).outline
                                      : flexSchemeLight(ref).outline
                                  : null,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            task.description ?? 'No Description',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: task.isCompleted
                                  ? ref.watch(isDarkModeProvider)
                                      ? flexSchemeDark(ref).outline
                                      : flexSchemeLight(ref).outline
                                  : null,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: task.isCompleted
                              ? GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(taskListProvider.notifier)
                                        .toggleCompleted(task.id!);
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.circleCheck,
                                    color: ref.watch(isDarkModeProvider)
                                        ? flexSchemeDark(ref).primary
                                        : flexSchemeLight(ref).primary,
                                    size: 32.0,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(taskListProvider.notifier)
                                        .toggleCompleted(task.id!);
                                  },
                                  child: const FaIcon(
                                    FontAwesomeIcons.circle,
                                    size: 32.0,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Divider(thickness: 2.0),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(task.category ?? 'No Category'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text('Created: ${task.createdDate!}'),
                              Text(
                                'Due: ${task.dueDate!}',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
