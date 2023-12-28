import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/models/task_model.dart';
import 'package:getsh_tdone/providers/tasklist_provider.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/theme/theme.dart';

class TaskCard extends ConsumerStatefulWidget {
  const TaskCard(
    this.task, {
    super.key,
  });
  final Task task;

  @override
  ConsumerState<TaskCard> createState() {
    return TaskCardState();
  }
}

class TaskCardState extends ConsumerState<TaskCard> {
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(isDarkModeProvider);
    return Stack(
      children: <Widget>[
        Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          color: widget.task.isCompleted
              ? isDarkMode
                  ? flexSchemeDark(ref).primaryContainer
                  : flexSchemeLight(ref).primaryContainer
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: widget.task.isCompleted
                  ? isDarkMode
                      ? flexSchemeDark(ref).primary
                      : flexSchemeLight(ref).primary
                  : isDarkMode
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
                      color: widget.task.category == 'personal'
                          ? isDarkMode
                              ? flexSchemeDark(ref).primary
                              : flexSchemeLight(ref).primary
                          : widget.task.category == 'work'
                              ? isDarkMode
                                  ? flexSchemeDark(ref).secondary
                                  : flexSchemeLight(ref).secondary
                              : widget.task.category == 'study'
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
                              widget.task.title,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: widget.task.isCompleted
                                    ? isDarkMode
                                        ? flexSchemeDark(ref).outline
                                        : flexSchemeLight(ref).outline
                                    : null,
                                decoration: widget.task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              widget.task.description ?? 'No Description',
                              maxLines: 3,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: widget.task.isCompleted
                                    ? ref.watch(isDarkModeProvider)
                                        ? flexSchemeDark(ref).outline
                                        : flexSchemeLight(ref).outline
                                    : null,
                                decoration: widget.task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: widget.task.isCompleted
                                ? GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(taskListProvider.notifier)
                                          .toggleCompleted(widget.task.id!);
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
                                      confettiController.play();
                                      ref
                                          .read(taskListProvider.notifier)
                                          .toggleCompleted(widget.task.id!);
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
                            Text(widget.task.category ?? 'No Category'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text('Created: ${widget.task.createdDate!}'),
                                Text(
                                  'Due: ${widget.task.dueDate!}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
          ),
        ),
      ],
    );
  }
}
