import 'package:flutter/material.dart';
import 'package:gatemate_mobile/model/action_center_view_model.dart';
import 'package:provider/provider.dart';

import '../model/data/to_do_item.dart';

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
            showDialog(
              context: context,
              builder: ((context) {
                return const NewActionDialog();
              }),
              barrierDismissible: true,
            );
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

class NewActionDialog extends StatefulWidget {
  const NewActionDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<NewActionDialog> createState() => _NewActionDialogState();
}

class _NewActionDialogState extends State<NewActionDialog> {
  final _inputTextController = TextEditingController();
  var _submitting = false;  // TODO: ?

  @override
  void dispose() {
    _inputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create new action:'),
      content: TextField(
        decoration: const InputDecoration(
          hintText: 'Enter description...',
        ),
        controller: _inputTextController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            createToDoItem(_inputTextController.text);
            setState(() {
              _submitting = true;
            });
            // TODO: Loading animation

            Navigator.pop(context);
          },
          child: const Text('Submit'),
        ),
      ],
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
    var actionItems = context.watch<ActionCenterViewModel>().actionItems;

    return FutureBuilder(
      future: actionItems,
      builder: (context, snapshot) {
        // Wait for data or error
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(snapshot.data![index].title, style: style),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          // TODO: Handle erros
          throw Exception('Action items data error!');
        }
        // While loading, show loading indicator
        return const Center(child: CircularProgressIndicator());
      }
    );

  }
}
