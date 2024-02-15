import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/theme/theme.dart';

class TaskLoadingCard extends ConsumerWidget {
  const TaskLoadingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = sIsDark.value;
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: isDarkMode
              ? cFlexSchemeDark().tertiary
              : cFlexSchemeLight().tertiary,
          width: 2.0,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                  color: isDarkMode
                      ? cFlexSchemeDark().tertiary
                      : cFlexSchemeLight().tertiary,
                ),
              ),
            ),
            const Expanded(
              flex: 15,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Loading...',
                          style: TextStyle(fontSize: 22.0),
                        ),
                        subtitle: Text(
                          'Please wait...',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        trailing: CircularProgressIndicator(),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Divider(thickness: 4.0),
                    SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Category: LOADING...'),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('Created: LOADING...'),
                            Text(
                              'Due: LOADING...',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
