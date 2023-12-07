import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/providers/date_provider.dart';
import 'package:getsh_tdone/providers/displayname_provider.dart';
import 'package:getsh_tdone/providers/smiley_provider.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/services/firestore_service.dart';
import 'package:getsh_tdone/theme/theme.dart';
import 'package:getsh_tdone/widgets/newtask_modal.dart';
import 'package:getsh_tdone/widgets/todo_card.dart';
import 'package:getsh_tdone/widgets/todoerror_card.dart';
import 'package:getsh_tdone/widgets/todoloading_card.dart';
import 'package:getsh_tdone/widgets/usersettings_modal.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Todo>> todoList = ref.watch(todoListProvider);

    return Scaffold(
      appBar: buildHomeScreenAppBar(context, ref),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(
            dragDevices: <PointerDeviceKind>{
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.stylus,
            },
          ),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "Today's Todo's",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(ref.watch(dateProvider)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  todoList.when(
                    data: (List<Todo> todoList) {
                      return ListView.builder(
                        shrinkWrap: true,
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
                      );
                    },
                    error: (Object error, StackTrace stackTrace) {
                      return TodoErrorCard(error, stackTrace);
                    },
                    loading: () {
                      return const TodoLoadingCard();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return const NewTaskModal();
            },
          );
        },
        child: const FaIcon(FontAwesomeIcons.plus),
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

  AppBar buildHomeScreenAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: InkWell(
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return const UserSettingsModal();
              },
            );
          },
          child: FaIcon(ref.watch(smileyIconProvider)),
        ),
        title: const Text('Get Sh_t Done'),
        subtitle: Text(ref.watch(displayNameProvider)),
      ),
      actions: <Widget>[
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.calendarDay),
          onPressed: () {},
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.solidBell),
          onPressed: () {},
        ),
      ],
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
      ),
      child: Container(
        height: 140.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
          color: ref.watch(isDarkModeProvider)
              ? flexSchemeDark.primary
              : flexSchemeLight.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.share,
              color: ref.watch(isDarkModeProvider)
                  ? flexSchemeDark.onPrimary
                  : flexSchemeLight.onPrimary,
            ),
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
      ),
      child: Container(
        height: 140.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
          color: ref.watch(isDarkModeProvider)
              ? flexSchemeDark.error
              : flexSchemeLight.error,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.trash,
              color: ref.watch(isDarkModeProvider)
                  ? flexSchemeDark.background
                  : flexSchemeLight.background,
            ),
          ),
        ),
      ),
    );
  }
}
