import 'package:flutter/material.dart';

// TODO: Replace this with remote data
List<String> fieldNamesPlaceholder = ['Field 1', 'Field B', 'Field of Real Numbers'];
// TODO: Consider replacing with an Enum or Dart equivalent
List<String> _notificationOptionsPlaceholder = ['Low', 'Med', 'High'];

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: SettingsPageBody(),
      ),
    );
  }
}

class SettingsPageBody extends StatelessWidget {
  const SettingsPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        FieldSelectionRow(),
        SizedBox(height: 20),
        // TODO: The way this row is structured could be improved
        WaterLevel(),
        SizedBox(height: 20),
        NotificationSettingDropdown(),
      ],
    );
  }
}

class FieldSelectionRow extends StatelessWidget {
  const FieldSelectionRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FieldSelectionDropdown(),
        IconButton(
          icon: const Icon(Icons.add_rounded),
          onPressed: () {
            // TODO
            print('DEBUG: Add field button pressed!');
          },
        ),
      ],
    );
  }
}

class WaterLevel extends StatelessWidget {
  const WaterLevel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('4.2 in'), // TODO: Populate with remote data
        const SizedBox(width: 20),
        const SizedBox(
          width: 200,
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Desired water level...',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () {
            // TODO: Update remote data
            print('DEBUG: Crop height update button pressed!');
          },
        ),
      ],
    );
  }
}

class FieldSelectionDropdown extends StatefulWidget {
  const FieldSelectionDropdown({super.key});

  @override
  State<FieldSelectionDropdown> createState() => _FieldSelectionDropdown();
}

class _FieldSelectionDropdown extends State<FieldSelectionDropdown> {

  String dropdownValue = fieldNamesPlaceholder.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      items: _mapDropdownMenuItems(fieldNamesPlaceholder),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value ?? fieldNamesPlaceholder.first;
        });
      },
    );
  }
}

class NotificationSettingDropdown extends StatefulWidget {
  const NotificationSettingDropdown({super.key});

  @override
  State<NotificationSettingDropdown> createState() => _NotificationSettingDropdown();
}

class _NotificationSettingDropdown extends State<NotificationSettingDropdown> {

  String dropdownValue = _notificationOptionsPlaceholder.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropdownValue,
      items: _mapDropdownMenuItems(_notificationOptionsPlaceholder),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value ?? _notificationOptionsPlaceholder.first;
        });
      },
    );
  }
}

// Takes a list of strings meant to be dropdown menu options and returns
// a list of dropdown menu items, which can be given as the `items` parameter
// to a `DropdownButton`.
List<DropdownMenuItem<String>> _mapDropdownMenuItems(List<String> items) {
  return items.map<DropdownMenuItem<String>>(
    (String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }
  ).toList();
}
