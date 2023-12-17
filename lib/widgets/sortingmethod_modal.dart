import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/providers/category_provider.dart';
import 'package:getsh_tdone/providers/sortingmethod_provider.dart';
import 'package:getsh_tdone/theme/theme.dart';

class SortingMethodModal extends ConsumerStatefulWidget {
  const SortingMethodModal({super.key});

  @override
  ConsumerState<SortingMethodModal> createState() {
    return SortingMethodModalState();
  }
}

class SortingMethodModalState extends ConsumerState<SortingMethodModal> {
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0,
        8.0,
        16.0,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Sort your sh_t',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(thickness: 4.0),
          const SizedBox(height: 8.0),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.arrowDownWideShort),
            title: const Text('By due date (default)'),
            subtitle: const Text('Show the most urgent tasks first'),
            onTap: () {
              ref.read(sortingMethodProvider.notifier).state = 'dueDate';
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.arrowDownWideShort),
            title: const Text('By creation date'),
            subtitle: const Text('Show the newest tasks first'),
            onTap: () {
              ref.read(sortingMethodProvider.notifier).state = 'creationDate';
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.arrowDownWideShort),
            title: const Text('By \'Personal\''),
            subtitle: const Text('Show only personal tasks'),
            onTap: () {
              ref
                  .read(categoryProvider.notifier)
                  .updateCategory(Categories.personal, ref);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.arrowDownWideShort),
            title: const Text('By \'Work\''),
            subtitle: const Text('Show only work tasks'),
            onTap: () {
              ref
                  .read(categoryProvider.notifier)
                  .updateCategory(Categories.work, ref);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.arrowDownWideShort),
            title: const Text('By \'Study\''),
            subtitle: const Text('Show only study tasks'),
            onTap: () {
              ref
                  .read(categoryProvider.notifier)
                  .updateCategory(Categories.study, ref);
              Navigator.pop(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(sortingMethodProvider.notifier).state =
                          'dueDate';
                      ref
                          .read(categoryProvider.notifier)
                          .updateCategory(Categories.all, ref);
                      Navigator.pop(context);
                    },
                    child: const Text('Remove all sorts'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: isSaving
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: CircularProgressIndicator(),
                          )
                        : const Text('OK'),
                  ),
                ),
              ],
            ),
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
        backgroundColor: flexSchemeLight(ref).error,
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
