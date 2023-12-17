import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/theme/theme.dart';
import 'package:logger/logger.dart';

class TaskErrorCard extends ConsumerWidget {
  const TaskErrorCard(
    this.error,
    this.stackTrace, {
    super.key,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Logger().e(error, stackTrace: stackTrace);
    return Container(
      height: 140.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: flexSchemeDark(ref).tertiary,
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
              color: flexSchemeDark(ref).tertiary,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      error.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                    subtitle: const Text(
                      'Something went wrong...',
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                    ),
                    trailing: const FaIcon(
                      FontAwesomeIcons.triangleExclamation,
                    ),
                  ),
                  const Divider(thickness: 4.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('Created: ERROR'),
                          Text(
                            'Due: ERROR',
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
    );
  }
}