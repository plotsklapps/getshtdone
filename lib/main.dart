import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/firebase_options.dart';
import 'package:getsh_tdone/theme.dart';
import 'package:getsh_tdone/widgets/newtask_modal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Get Sh_t Done',
      theme: themeDark,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              child: Icon(Icons.person_4_rounded),
            ),
            title: Text('Get Sh_t Done'),
            subtitle: Text('plotsklapps'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month_rounded),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.doorbell_rounded),
              onPressed: () {},
            ),
          ],
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Todo",
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Text('Wednesday, 24 March 2023'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet<void>(
                showDragHandle: true,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return const NewTaskModal();
                });
          },
          label: const Row(
            children: [
              Icon(Icons.add_rounded),
              SizedBox(width: 8.0),
              Text('New Sh_t To Do'),
            ],
          ),
        ));
  }
}
