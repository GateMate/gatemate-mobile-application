import 'package:flutter/material.dart';
import 'package:gatemate_mobile/model/action_center_view_model.dart';
import 'package:provider/provider.dart';

class ActionCenterRoute extends StatelessWidget {
  const ActionCenterRoute({super.key});

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    var style = theme.textTheme.titleLarge?.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    return ChangeNotifierProvider(
      create: (context) => ActionCenterViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Action Center'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: NotificationsList(style: style),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Schedule action
          },
          child: Icon(
            Icons.add_rounded,
            color: theme.colorScheme.onTertiary,
            size: 36,
          ),
        ),
      ),
    );
  }
}

class NotificationsList extends StatelessWidget {
  const NotificationsList({
    Key? key,
    required this.style,
  }) : super(key: key);

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {

    var notifications = context.watch<ActionCenterViewModel>().actionItems;

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(notifications[index], style: style),
          ),
        );
      },
    );
  }
}
