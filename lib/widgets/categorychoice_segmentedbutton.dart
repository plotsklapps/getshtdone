import 'package:flutter/material.dart';

enum Categories { study, work, personal }

class CategoryChoice extends StatefulWidget {
  const CategoryChoice({super.key});

  @override
  State<CategoryChoice> createState() {
    return CategoryChoiceState();
  }
}

class CategoryChoiceState extends State<CategoryChoice> {
  Set<Categories> selection = <Categories>{};

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Categories>(
      selected: selection,
      onSelectionChanged: (Set<Categories> newSelection) {
        setState(() {
          selection = newSelection;
        });
      },
      emptySelectionAllowed: true,
      multiSelectionEnabled: true,
      segments: const <ButtonSegment<Categories>>[
        ButtonSegment<Categories>(
          value: Categories.study,
          label: Text('Study'),
        ),
        ButtonSegment<Categories>(
          value: Categories.work,
          label: Text('Work'),
        ),
        ButtonSegment<Categories>(
          value: Categories.personal,
          label: Text('personal'),
        ),
      ],
    );
  }
}
