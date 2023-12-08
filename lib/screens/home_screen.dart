import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/providers/date_provider.dart';
import 'package:getsh_tdone/providers/smiley_provider.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/services/firestore_service.dart';
import 'package:getsh_tdone/theme/theme.dart';
import 'package:getsh_tdone/widgets/newtodo_modal.dart';
import 'package:getsh_tdone/widgets/todo_card.dart';
import 'package:getsh_tdone/widgets/todoerror_card.dart';
import 'package:getsh_tdone/widgets/todoloading_card.dart';
import 'package:getsh_tdone/widgets/usersettings_modal.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Todo>> todoList = ref.watch(todoListProvider);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Get Sh_t Done',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(ref.watch(dateProvider)),
                    ],
                  ),
                ],
              ),
              const Divider(
                thickness: 4.0,
              ),
              const SizedBox(height: 8.0),
              Flexible(
                child: todoList.when(
                  data: (List<Todo> todoList) {
                    return ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(
                        dragDevices: <PointerDeviceKind>{
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad,
                          PointerDeviceKind.stylus,
                        },
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: todoList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: Key(todoList[index].id!),
                            background: const TodoCardBackgroundDelete(),
                            secondaryBackground:
                                const TodoCardBackgroundShare(),
                            confirmDismiss: (DismissDirection direction) {
                              if (direction == DismissDirection.startToEnd) {
                                return showDeleteTaskModal(
                                  context,
                                  ref,
                                  todoList,
                                  index,
                                );
                              } else {
                                return showShareTaskModal(
                                  context,
                                  ref,
                                );
                              }
                            },
                            child: TodoCard(
                              todoList[index],
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (Object error, StackTrace stackTrace) {
                    return TodoErrorCard(error, stackTrace);
                  },
                  loading: () {
                    return const TodoLoadingCard();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          indicatorColor: Colors.transparent,
          selectedIndex: 1,
          onDestinationSelected: (int index) {
            if (index == 0) {
              showModalBottomSheet<Widget>(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return const UserSettingsModal();
                },
              );
            } else if (index == 1) {
              showModalBottomSheet<Widget>(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return const NewTodoModal();
                },
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Work in progress!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: Icon(ref.watch(smileyProvider)),
              label: 'Account',
            ),
            NavigationDestination(
              icon: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    top: -24.0,
                    left: 0.0,
                    right: 0.0,
                    child: Icon(
                      FontAwesomeIcons.circlePlus,
                      size: 72.0,
                      color: ref.watch(isDarkModeProvider)
                          ? flexSchemeDark.primary
                          : flexSchemeLight.primary,
                    ),
                  ),
                ],
              ),
              label: 'New Sh_t Todo',
            ),
            const NavigationDestination(
              icon: Icon(FontAwesomeIcons.circleQuestion),
              label: 'About',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> showShareTaskModal(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24.0,
            0.0,
            24.0,
            MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Share this task?',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('CANCEL'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '''
This feature is a work in progress...''',
                          ),
                          duration: Duration(
                            seconds: 2,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'SHARE',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> showDeleteTaskModal(
    BuildContext context,
    WidgetRef ref,
    List<Todo> todoList,
    int index,
  ) {
    return showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24.0,
            0.0,
            24.0,
            MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Delete this task?',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('CANCEL'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirestoreService(ref).deleteTodo(
                        todoList[index].id!,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ref.watch(
                        isDarkModeProvider,
                      )
                          ? flexSchemeDark.error
                          : flexSchemeLight.error,
                    ),
                    child: Text(
                      'DELETE',
                      style: TextStyle(
                        color: ref.watch(
                          isDarkModeProvider,
                        )
                            ? flexSchemeDark.onError
                            : flexSchemeLight.onError,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class TodoCardBackgroundShare extends ConsumerWidget {
  const TodoCardBackgroundShare({
    super.key,
  });

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
          width: 4.0,
        ),
      ),
      child: Container(
        height: 140.0,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.share,
                color: ref.watch(isDarkModeProvider)
                    ? flexSchemeDark.primary
                    : flexSchemeLight.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoCardBackgroundDelete extends ConsumerWidget {
  const TodoCardBackgroundDelete({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: ref.watch(isDarkModeProvider)
              ? flexSchemeDark.error
              : flexSchemeLight.error,
          width: 4.0,
        ),
      ),
      child: Container(
        height: 140.0,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Row(
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.trash,
                color: ref.watch(isDarkModeProvider)
                    ? flexSchemeDark.error
                    : flexSchemeLight.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
