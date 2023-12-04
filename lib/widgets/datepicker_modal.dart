import 'package:flutter/material.dart';

class DatePickerModal extends StatefulWidget {
  const DatePickerModal({super.key});

  @override
  State<DatePickerModal> createState() {
    return DatePickerModalState();
  }
}

class DatePickerModalState extends State<DatePickerModal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: Column(
        children: [
          const Text(
            'Select a due date',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(thickness: 4.0),
          Expanded(
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.utc(2000),
              lastDate: DateTime.utc(2040),
              onDateChanged: (DateTime value) {},
            ),
          ),
        ],
      ),
    );
  }
}
