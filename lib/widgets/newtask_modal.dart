import 'package:flutter/material.dart';
import 'package:getsh_tdone/widgets/categorychoice_segmentedbutton.dart';
import 'package:getsh_tdone/widgets/datepicker_modal.dart';
import 'package:getsh_tdone/widgets/timepicker_modal.dart';

class NewTaskModal extends StatefulWidget {
  const NewTaskModal({
    super.key,
  });

  @override
  State<NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<NewTaskModal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create new sh_t to do',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 4,
            ),
            const SizedBox(height: 8.0),
            const TextField(
              decoration: InputDecoration(
                labelText: 'New TODO Title',
              ),
            ),
            const SizedBox(height: 8.0),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'New TODO Description',
              ),
            ),
            const SizedBox(height: 16.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: CategoryChoice()),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<Widget>(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      builder: (context) {
                        return const DatePickerModal();
                      },
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.edit_calendar_rounded),
                      SizedBox(width: 8.0),
                      Text('Add Due Date'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<Widget>(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      builder: (context) {
                        return const TimePickerModal();
                      },
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.alarm_rounded),
                      SizedBox(width: 8.0),
                      Text('Add Due Time'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
