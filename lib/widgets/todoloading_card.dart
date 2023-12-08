import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/date_provider.dart';
import 'package:getsh_tdone/providers/time_provider.dart';
import 'package:getsh_tdone/theme/theme.dart';

class TodoLoadingCard extends ConsumerWidget {
  const TodoLoadingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 140.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: flexSchemeDark.tertiary,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 20.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
              ),
              color: flexSchemeDark.tertiary,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Loading...'),
                    subtitle: Text('Please wait...'),
                    trailing: CircularProgressIndicator(),
                  ),
                  const Divider(thickness: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(ref.watch(dueDateProvider)),
                      const SizedBox(width: 8.0),
                      Text(ref.watch(timeProvider)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}