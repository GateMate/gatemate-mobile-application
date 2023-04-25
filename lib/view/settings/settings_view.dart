import 'package:flutter/material.dart';
import 'package:gatemate_mobile/model/firebase/gatemate_auth.dart';
import 'package:gatemate_mobile/model/viewmodels/fields_view_model.dart';
import 'package:gatemate_mobile/view/settings/water_level_row.dart';
import 'package:gatemate_mobile/view/ui_primatives/horizontal_divider.dart';
import 'package:get_it/get_it.dart';
import 'package:workmanager/workmanager.dart';

import '../ui_primatives/confirmation_button.dart';
import '../ui_primatives/custom_input_field.dart';
import 'field_selection_row.dart';
import 'notification_settings_row.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const HorizontalDivider(),
            const Text(
              'Developer Tools (DEBUGGING ONLY)',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),
            TriggerDebugRow(),
          ],
        ),
      ),
    );
  }
}

class TriggerDebugRow extends StatefulWidget {
  const TriggerDebugRow({
    super.key,
  });

  @override
  State<TriggerDebugRow> createState() => _TriggerDebugRowState();
}

class _TriggerDebugRowState extends State<TriggerDebugRow> {
  final _latController = TextEditingController();
  final _longController = TextEditingController();

  @override
  void dispose() {
    _latController.dispose();
    _longController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomInputField(
                inputController: _latController,
                hintText: 'Latitude',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomInputField(
                inputController: _longController,
                hintText: 'Longitude',
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            Workmanager().registerOneOffTask(
              'DEBUG',
              'weather-fetcher',
              inputData: {
                'latitude': double.parse(_latController.text),
                'longitude': double.parse(_longController.text),
              },
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Weather Alert Debug'),
          ),
        ),
      ],
    );
  }
}
