import 'package:flutter/material.dart';

class TimePickerModal extends StatefulWidget {
  const TimePickerModal({super.key});

  @override
  State<TimePickerModal> createState() {
    return TimePickerModalState();
  }
}

class TimePickerModalState extends State<TimePickerModal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: Column(
        children: [
          const Text(
            'Select a due time',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(thickness: 4.0),
          Expanded(
            child: TimePickerDialog(
              initialTime: TimeOfDay.now(),
            ),
          ),
        ],
      ),
    );
  }
}
