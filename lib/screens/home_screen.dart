import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/providers/date_provider.dart';
import 'package:getsh_tdone/providers/displayname_provider.dart';
import 'package:getsh_tdone/providers/smiley_provider.dart';
import 'package:getsh_tdone/services/firestore_service.dart';
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
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: todoList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: Key(todoList[index].id!),
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 12.0),
                              height: 140.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.xmark,
                                ),
                              ),
                            ),
                            onDismissed: (DismissDirection direction) {
                              FirestoreService(ref).deleteTodo(
                                todoList[index].id!,
                              );
                            },
                            child: TodoCard(todoList[index]),
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

  AppBar buildHomeScreenAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
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
