import 'package:flutter/material.dart';

class TimePickerAlert extends StatefulWidget {
  const TimePickerAlert({super.key});

  @override
  State<TimePickerAlert> createState() {
    return TimePickerAlertState();
  }
}

class TimePickerAlertState extends State<TimePickerAlert> {
  @override
  Widget build(BuildContext context) {
    return TimePickerDialog(
      initialTime: TimeOfDay.now(),
      confirmText: 'Save',
      onEntryModeChanged: (TimePickerEntryMode value) {
        // TODO(plotsklapps): implement onEntryModeChanged
      },
    );
  }
}
