import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
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
    final listType = <String>[
      'TASKS',
      '+',
    ];
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'GET SH_T DONE',
                style: TextStyle(fontSize: 64.0),
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: listType.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Chip(
                              label: Text(listType[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Divider(thickness: 2.0),
              Expanded(
                child: Watch((_) {
                  return ListView(
                    children: [
                      for (final todo in todoStore.todosList.value)
                        Stack(
                          children: [
                            Align(
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
                                    confettiController.play();
                                  },
                                  onLongPress: () {
                                    todoStore.removeTodo(todo);
                                  },
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
                      const Divider(thickness: 2.0),
                    ],
                  );
                }),
              ),
            ],
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
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
