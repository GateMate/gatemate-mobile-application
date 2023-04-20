import 'package:flutter/material.dart';

import '../ui_primatives/custom_input_field.dart';

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