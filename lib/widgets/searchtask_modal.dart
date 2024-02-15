import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/models/task_model.dart';
import 'package:getsh_tdone/providers/searchtask_provider.dart';
import 'package:getsh_tdone/providers/tasklist_provider.dart';
import 'package:getsh_tdone/services/firestore_service.dart';
import 'package:getsh_tdone/theme/theme.dart';

class SearchTaskModal extends ConsumerStatefulWidget {
  const SearchTaskModal({super.key});

  @override
  ConsumerState<SearchTaskModal> createState() {
    return SearchTaskModalState();
  }
}

class SearchTaskModalState extends ConsumerState<SearchTaskModal> {
  late TextEditingController searchController;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0,
        8.0,
        16.0,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Search your sh_t',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(thickness: 4.0),
          const SizedBox(height: 16.0),
          TextField(
            controller: searchController,
            onChanged: (String value) {
              ref.read(searchTaskProvider.notifier).state = value;
            },
            decoration: const InputDecoration(
              labelText: 'Enter keyword',
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
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
                    if (!isSearching) {
                      setState(() {
                        isSearching = true;
                      });
                    }
                    final List<Task> tasks =
                        await FirestoreService(ref).searchTask(
                      searchController.text.trim(),
                    );
                    ref.read(taskListProvider.notifier).state =
                        AsyncValue.data(tasks);
                    setState(() {
                      isSearching = false;
                    });
                    Navigator.pop(context);
                  },
                  child: isSearching
                      ? const CircularProgressIndicator()
                      : const Text('Search'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showErrorSnack(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            sIsDark.value ? cFlexSchemeDark().error : cFlexSchemeLight().error,
      ),
    );
  }

  void showSuccessSnack(BuildContext context, String success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
