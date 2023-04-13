import 'package:flutter/material.dart';
import 'package:gatemate_mobile/model/viewmodels/fields_view_model.dart';
import 'package:gatemate_mobile/view/ui_primatives/custom_input_field.dart';
import 'package:gatemate_mobile/model/fields_view_model.dart';
import 'package:gatemate_mobile/view/draw_field/draw_field.dart';
import 'package:provider/provider.dart';

// TODO: Consider replacing with an Enum
List<String> _notificationOptionsPlaceholder = ['Low', 'Med', 'High'];

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Change this to use GetIt instead of creating a new viewmodel
    return ChangeNotifierProvider(
      create: (context) => FieldsViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              FieldSelectionRow(),
              Divider(
                height: 40,
                thickness: 2,
                color: Colors.black,
              ),
              WaterLevelRow(),
              Divider(
                height: 40,
                thickness: 2,
                color: Colors.black,
              ),
              NotificationSettingsRow(),
              // TODO: User login options (sign out, etc.)
            ],
          ),
        ),
      ),
    );
  }
}

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
            const FieldSelectionDropdown(),
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                // TODO
                print('DEBUG: Add field button pressed!');
              },
            ),
          ],
        ),
      ],
    );
  }
}

class WaterLevelRow extends StatelessWidget {
  const WaterLevelRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          // TODO: Populate with remote data
          child: Row(
            children: const [
              Text(
                'Current Target Water Level: ',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '4.2 in',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              flex: 7,
              child: CustomInputField(
                inputController: TextEditingController(),
                hintText: 'Target water level (in)',
                keyboardType: TextInputType.number,
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  // TODO: Update remote data
                  print('DEBUG: Crop height update button pressed!');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NotificationSettingsRow extends StatelessWidget {
  const NotificationSettingsRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Notification Settings:',
          style: TextStyle(fontSize: 18),
        ),
        NotificationSettingDropdown(),
      ],
    );
  }
}

class FieldSelectionDropdown extends StatelessWidget {
  const FieldSelectionDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var fieldsViewModel = context.watch<FieldsViewModel>();

    return DropdownButton<String>(
      value: fieldsViewModel.currentFieldSelection,
      items: _mapSetToDropdownMenu(fieldsViewModel.fieldNamesPlaceholder),
      onChanged: (String? value) {
        if (value != null) {
          fieldsViewModel.selectField(value);
        }
      },
      iconSize: 28,
      underline: Container(
        height: 2,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class NotificationSettingDropdown extends StatefulWidget {
  const NotificationSettingDropdown({super.key});

  @override
  State<NotificationSettingDropdown> createState() =>
      _NotificationSettingDropdown();
}

class _NotificationSettingDropdown extends State<NotificationSettingDropdown> {
  String dropdownValue = _notificationOptionsPlaceholder.first;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return DropdownButton(
      value: dropdownValue,
      items: _mapListToDropdownMenu(_notificationOptionsPlaceholder),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value ?? _notificationOptionsPlaceholder.first;
        });
      },
      iconSize: 28,
      underline: Container(
        height: 2,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

// Takes a list of strings meant to be dropdown menu options and returns
// a list of dropdown menu items, which can be given as the `items` parameter
// to a `DropdownButton`.
List<DropdownMenuItem<String>> _mapListToDropdownMenu(List<String> items) {
  return items.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
}

List<DropdownMenuItem<String>> _mapSetToDropdownMenu(Set<String> items) {
  return items.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
}
