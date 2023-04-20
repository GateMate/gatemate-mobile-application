import 'package:flutter/material.dart';
import 'package:gatemate_mobile/model/viewmodels/fields_view_model.dart';
import 'package:gatemate_mobile/view/settings/water_level_row.dart';
import 'package:provider/provider.dart';

import 'field_selection_row.dart';
import 'notification_settings_row.dart';

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
