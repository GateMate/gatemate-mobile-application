import 'package:flutter/material.dart';

const actionItems = [
  'Severe weather alert',
  'Scheduled gate raise...',
  'Crop measurement reminder',
];

class ActionCenterRoute extends StatelessWidget {
  const ActionCenterRoute({super.key});

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    var style = theme.textTheme.titleLarge?.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Center'),
      ),
      body: Container(
        color: theme.colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: ListView.builder(
            itemCount: actionItems.length,
            itemBuilder: (context, index) {
              return Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(actionItems[index], style: style),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
