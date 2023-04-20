import 'package:flutter/material.dart';

// TODO: Consider replacing with an Enum
final _notificationOptionsPlaceholder = ['Low', 'Med', 'High'];

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

/// Takes a list of strings meant to be dropdown menu options and returns
/// a list of dropdown menu items, which can be given as the `items` parameter
/// to a `DropdownButton`.
List<DropdownMenuItem<String>> _mapListToDropdownMenu(List<String> items) {
  return items.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
}