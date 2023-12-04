import 'package:flutter/material.dart';

class DatePickerAlert extends StatefulWidget {
  const DatePickerAlert({super.key});

  @override
  State<DatePickerAlert> createState() {
    return DatePickerAlertState();
  }
}

class DatePickerAlertState extends State<DatePickerAlert> {
  @override
  Widget build(BuildContext context) {
    return DatePickerDialog(
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      confirmText: 'Save',
      onDatePickerModeChange: (DatePickerEntryMode value) {
        // TODO(plotsklapps): implement onDatePickerModeChange
      },
    );
  }
}
