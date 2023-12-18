import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/models/task_model.dart';
import 'package:getsh_tdone/providers/date_provider.dart';
import 'package:getsh_tdone/providers/smiley_provider.dart';
import 'package:getsh_tdone/providers/tasklist_provider.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:getsh_tdone/services/firestore_service.dart';
import 'package:getsh_tdone/theme/theme.dart';
import 'package:getsh_tdone/widgets/newtask_modal.dart';
import 'package:getsh_tdone/widgets/responsive_layout.dart';
import 'package:getsh_tdone/widgets/sortingmethod_modal.dart';
import 'package:getsh_tdone/widgets/task_card.dart';
import 'package:getsh_tdone/widgets/taskerror_card.dart';
import 'package:getsh_tdone/widgets/taskloading_card.dart';
import 'package:getsh_tdone/widgets/updatetask_modal.dart';
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
  Widget build(BuildContext context) {
    final AsyncValue<List<Task>> taskList = ref.watch(taskListProvider);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 64.0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Get Sh_t Done',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 32.0),
              Text(ref.watch(dateProvider)),
            ],
          ),
          centerTitle: true,
        ),
        body: ResponsiveLayout(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 12.0, 18.0, 12.0),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: taskList.when(
                    data: (List<Task> taskList) {
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
                          itemCount: taskList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: Key(taskList[index].id!),
                              // Swiping to the right is for deleting the task.
                              background: const TaskCardBackgroundDelete(),
                              secondaryBackground:
                                  // Swiping to the left is for editing the
                                  // task.
                                  const TaskCardBackGroundEdit(),
                              confirmDismiss: (DismissDirection direction) {
                                if (direction == DismissDirection.startToEnd) {
                                  return showDeleteTaskModal(
                                    context,
                                    ref,
                                    taskList,
                                    index,
                                  );
                                } else {
                                  return showUpdateTaskModal(
                                    context,
                                    ref,
                                    taskList,
                                    index,
                                  );
                                }
                              },
                              child: TaskCard(
                                taskList[index],
                              ),
                            );
                          },
                        ),
                      );
                    },
                    error: (Object error, StackTrace stackTrace) {
                      return TaskErrorCard(error, stackTrace);
                    },
                    loading: () {
                      return const TaskLoadingCard();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 64.0,
          notchMargin: 12.0,
          shape: const CircularNotchedRectangle(),
          child: ResponsiveLayout(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Feature is being made up as we speak...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.circleQuestion,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet<Widget>(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return const UserSettingsModal();
                          },
                        );
                      },
                      icon: FaIcon(
                        ref.watch(smileyProvider),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 64.0),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Pomodoro timer is coming!',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.stopwatch20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet<Widget>(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return const SortingMethodModal();
                          },
                        );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.sort,
                      ),
                    ),
                  ],
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
              isScrollControlled: true,
              builder: (BuildContext context) {
                return const NewTaskModal();
              },
            );
          },
          child: const Icon(
            FontAwesomeIcons.plus,
            size: 32.0,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Future<bool?> showUpdateTaskModal(
    BuildContext context,
    WidgetRef ref,
    List<Task> taskList,
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
                    'Edit this task?',
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
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('CANCEL'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await showModalBottomSheet<Widget>(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return UpdateTaskModal(taskList[index]);
                          },
                        );
                      },
                      child: const Text(
                        'EDIT',
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

  Future<bool?> showDeleteTaskModal(
    BuildContext context,
    WidgetRef ref,
    List<Task> taskList,
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
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('CANCEL'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        FirestoreService(ref).deleteTask(
                          taskList[index].id!,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ref.watch(
                          isDarkModeProvider,
                        )
                            ? flexSchemeDark(ref).error
                            : flexSchemeLight(ref).error,
                      ),
                      child: Text(
                        'DELETE',
                        style: TextStyle(
                          color: ref.watch(
                            isDarkModeProvider,
                          )
                              ? flexSchemeDark(ref).onError
                              : flexSchemeLight(ref).onError,
                        ),
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

class TaskCardBackGroundEdit extends ConsumerWidget {
  const TaskCardBackGroundEdit({
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
              ? flexSchemeDark(ref).primary
              : flexSchemeLight(ref).primary,
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
                FontAwesomeIcons.solidPenToSquare,
                color: ref.watch(isDarkModeProvider)
                    ? flexSchemeDark(ref).primary
                    : flexSchemeLight(ref).primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskCardBackgroundDelete extends ConsumerWidget {
  const TaskCardBackgroundDelete({
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
              ? flexSchemeDark(ref).error
              : flexSchemeLight(ref).error,
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
                    ? flexSchemeDark(ref).error
                    : flexSchemeLight(ref).error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
