import 'package:confetti/confetti.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:getsh_tdone/all_signals.dart';
import 'package:getsh_tdone/newtaskgroup_bottomsheet.dart';
import 'package:getsh_tdone/theme.dart';
import 'package:getsh_tdone/todo.dart';
import 'package:getsh_tdone/todo_bottomsheet.dart';
import 'package:signals/signals_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              dragDevices: <PointerDeviceKind>{
                PointerDeviceKind.stylus,
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      'GET SH_T DONE',
                      style: TextStyle(fontSize: 64.0),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40.0,
                        child: Watch((_) {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: taskGroupList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    if (taskGroupList[index] == '+') {
                                      showModalBottomSheet<Widget>(
                                        context: context,
                                        showDragHandle: true,
                                        builder: (_) {
                                          return const NewTaskGroupBottomSheet();
                                        },
                                      );
                                    }
                                  },
                                  child: Chip(
                                    label: Text(taskGroupList[index]),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Watch((_) {
                    return ListView(
                      children: [
                        for (final todo in todoStore.todosList.value)
                          Stack(
                            children: [
                              Align(
                                child: Dismissible(
                                  key: Key(todo.title),
                                  onDismissed: (direction) {
                                    todoStore.removeTodo(todo);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Great job on completing your task!',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        showCloseIcon: true,
                                      ),
                                    );
                                  },
                                  background: Card(
                                    color: flexSchemeDark.error,
                                    child: const ListTile(
                                      leading: Icon(
                                        Icons.delete_rounded,
                                      ),
                                    ),
                                  ),
                                  child: Card(
                                    child: ListTile(
                                      title: Text(
                                        todo.title,
                                        style: todo.isDone
                                            ? const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              )
                                            : null,
                                      ),
                                      subtitle: Text(
                                        todo.description,
                                        style: todo.isDone
                                            ? const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              )
                                            : null,
                                      ),
                                      trailing: todo.isDone
                                          ? Icon(
                                              Icons.check_circle_rounded,
                                              color: flexSchemeDark.tertiary,
                                            )
                                          : null,
                                      onTap: () {
                                        todoStore.doneTodo(todo);
                                        // Only play confetti when the task is
                                        // marked as done.
                                        if (!todo.isDone) {
                                          confettiController.play();
                                        }
                                      },
                                      onLongPress: () {
                                        todoStore.removeTodo(todo);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ConfettiWidget(
                                  confettiController: confettiController,
                                  numberOfParticles: 100,
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<Widget>(
              context: context,
              showDragHandle: true,
              builder: (_) {
                return const TodoBottomSheet();
              },
            );
          },
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}
