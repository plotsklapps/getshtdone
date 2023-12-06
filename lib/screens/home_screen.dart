import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/services/firestore_service.dart';
import 'package:getsh_tdone/theme/theme.dart';
import 'package:getsh_tdone/widgets/newtask_modal.dart';
import 'package:getsh_tdone/widgets/todo_card.dart';
import 'package:getsh_tdone/widgets/usersettings_modal.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Todo>> todoList = ref.watch(todoListProvider);
    return Scaffold(
      appBar: AppBar(
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
            child: const CircleAvatar(
              child: FaIcon(FontAwesomeIcons.userNinja),
            ),
          ),
          title: const Text('Get Sh_t Done'),
          subtitle: const Text('plotsklapps'),
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
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          dragDevices: <PointerDeviceKind>{
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.stylus,
          },
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Today's Todo",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Wednesday, 24 March 2023'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: todoList.value!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(todoList.value![index].id!),
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          height: 140.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: flexSchemeDark.error,
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.xmark,
                            ),
                          ),
                        ),
                        onDismissed: (DismissDirection direction) {
                          FirestoreService(ref).deleteTodo(
                            todoList.value![index].id!,
                          );
                        },
                        child: TodoCard(getIndex: index),
                      );
                    })
              ],
            ),
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
}
