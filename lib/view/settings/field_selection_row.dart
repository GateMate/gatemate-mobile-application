import 'package:flutter/material.dart';

import '../draw_field/draw_field.dart';

class FieldSelectionRow extends StatelessWidget {
  const FieldSelectionRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Pass this to widget builders instead of doing this each time
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Field selection:',
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            // const FieldSelectionDropdown(),
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                // TODO
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddFieldRoute(),
                  ),
                );
                print('DEBUG: Add field button pressed!');
              },
            ),
          ],
        ),
      ],
    );
  }
}

// class FieldSelectionDropdown extends StatelessWidget {
//   const FieldSelectionDropdown({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var fieldsViewModel = context.watch<FieldsViewModel>();

//     return DropdownButton<String>(
//       value: fieldsViewModel.currentFieldSelection?.name ?? 'No field selected' ,
//       items: _mapSetToDropdownMenu(fieldsViewModel.allFields),
//       onChanged: (String? value) {
//         if (value != null) {
//           fieldsViewModel.selectField(value);
//         }
//       },
//       iconSize: 28,
//       underline: Container(
//         height: 2,
//         color: theme.colorScheme.primary,
//       ),
//     );
//   }
// }

List<DropdownMenuItem<String>> _mapSetToDropdownMenu(Set<String> items) {
  return items.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
}
