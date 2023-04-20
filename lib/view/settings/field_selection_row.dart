import 'package:flutter/material.dart';
import 'package:gatemate_mobile/model/viewmodels/fields_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../model/data/field.dart';
import '../draw_field/draw_field.dart';

class FieldSelectionRow extends StatelessWidget {
  const FieldSelectionRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            const FieldSelectionDropdown(),
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
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

class FieldSelectionDropdown extends StatefulWidget {
  const FieldSelectionDropdown({super.key});

  @override
  State<FieldSelectionDropdown> createState() => _FieldSelectionDropdownState();
}

class _FieldSelectionDropdownState extends State<FieldSelectionDropdown> {
  final _viewModel = GetIt.I<FieldsViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_updateFieldDropdown);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_updateFieldDropdown);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder(
      future: _viewModel.allFields,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownButton<String>(
            value: _viewModel.currentFieldSelection?.id,
            items: _mapFieldsToDropdown(snapshot.data!),
            onChanged: (String? value) {
              if (value != null) {
                _viewModel.selectField(value);
              }
            },
            iconSize: 28,
            underline: Container(
              height: 2,
              color: theme.colorScheme.primary,
            ),
          );
        } else if (snapshot.hasError) {
          final errorMessage =
              'Error accessing viewmodel in fields selection dropdown:\n'
              '${snapshot.error}';

          Logger().e(errorMessage);
          throw Exception(errorMessage);
        }

        return const CircularProgressIndicator();
      },
    );
  }

  void _updateFieldDropdown() {
    setState(() {});
  }
}

List<DropdownMenuItem<String>> _mapFieldsToDropdown(Map<String, Field> fields) {
  List<DropdownMenuItem<String>> menuItems = [];

  fields.forEach((key, value) {
    menuItems.add(
      DropdownMenuItem(
        value: value.id,
        child: Text(value.name),
      ),
    );
  });

  return menuItems;
}
