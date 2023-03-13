import 'package:flutter/material.dart';
import 'package:gatemate_mobile/model/viewmodels/action_center_view_model.dart';
import 'package:get_it/get_it.dart';

class ActionCenterView extends StatelessWidget {
  const ActionCenterView({super.key});

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
  var _submitting = false;

  @override
  void dispose() {
    _inputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create new action:'),
      content: _getDialogBody(),
      actions: [
        _getCancelButton(),
        _getSubmitButton(),
      ],
    );
  }

  // Returns a text field if nothing has been submitted
  // Otherwise, returns a loading progress indicator
  Widget _getDialogBody() {
    if (_submitting) {
      return const CircularProgressIndicator();
    } else {
      return TextField(
        decoration: const InputDecoration(
          hintText: 'Enter description...',
        ),
        controller: _inputTextController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
      );
    }
  }

  // Returns a normal button if nothing has been submitted
  // Otherwise, returns a disabled button
  Widget _getCancelButton() {
    void Function()? onCancel;
    if (!_submitting) {
      onCancel = () => Navigator.pop(context);
    }

    return TextButton(
      onPressed: onCancel,
      child: const Text('Cancel'),
    );
  }

  // Returns a normal button if nothing has been submitted
  // Otherwise, returns a disabled button
  Widget _getSubmitButton() {
    void Function()? onSubmit;
    if (!_submitting) {
      onSubmit = () {
        if (_inputTextController.text.trim().isNotEmpty) {
          createToDoItem(_inputTextController.text);
          setState(() {
            _submitting = true;
          });
          // TODO: Loading animation
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Content empty: nothing saved!'),
          ));
        }

        // Don't need to use set state here since nothing needs to be redrawn
        _submitting = false;
        Navigator.pop(context);
      };
    }

    return ElevatedButton(
      onPressed: onSubmit,
      child: const Text('Submit'),
    );
  }
}

class NotificationsList extends StatefulWidget {
  const NotificationsList({
    Key? key,
    required this.style,
  }) : super(key: key);

  final TextStyle? style;

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  final _viewModel = GetIt.I<ActionCenterViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_updateNotificationsList);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_updateNotificationsList);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var actionItems = _viewModel.actionItems;

    return FutureBuilder(
      future: actionItems,
      builder: (context, snapshot) {
        // Wait for data or error
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(snapshot.data![index].title, style: widget.style),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          // TODO: Handle errors
          throw Exception('Error from server: ${snapshot.error}');
        }
        // While loading, show loading indicator
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _updateNotificationsList() {
    setState(() {});
  }
}
