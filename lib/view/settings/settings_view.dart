import 'package:flutter/material.dart';
import 'package:gatemate_mobile/model/firebase/gatemate_auth.dart';
import 'package:gatemate_mobile/model/viewmodels/fields_view_model.dart';
import 'package:gatemate_mobile/view/settings/water_level_row.dart';
import 'package:gatemate_mobile/view/ui_primatives/horizontal_divider.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../ui_primatives/confirmation_button.dart';
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
          actions: [
            IconButton(
              onPressed: () {
                GetIt.I<FieldsViewModel>().refresh();
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FieldSelectionRow(),
              const HorizontalDivider(),
              const WaterLevelRow(),
              const HorizontalDivider(),
              const NotificationSettingsRow(),
              const HorizontalDivider(),
              ConfirmationButton(
                onPressed: () {
                  GetIt.I<GateMateAuth>().signOut();
                  Navigator.pop(context);
                },
                buttonText: 'Sign Out',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
