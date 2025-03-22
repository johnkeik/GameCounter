import 'package:flutter/material.dart';
import 'package:game_counter/controllers/game_controller.dart';
import 'package:game_counter/controllers/navigation_controller.dart';
import 'package:game_counter/shared/custom_snack_bar.dart';
import 'package:get/get.dart';

import '../models/team_model.dart';

class StartGameModal extends StatefulWidget {
  const StartGameModal({super.key});

  @override
  State<StartGameModal> createState() => _StartGameModalState();
}

class _StartGameModalState extends State<StartGameModal> {
  final _formKey = GlobalKey<FormState>();
  final _gameNameController = TextEditingController();
  final List<TextEditingController> _controllers = [TextEditingController()];
  final GameController controller = Get.put(GameController());
  final NavigationController navigationController = Get.put(NavigationController());
  static const int _minTeams = 2;
  static const int _maxTeams = 8;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _gameNameController.dispose();
    super.dispose();
  }

  void _addTextField() {
    if (_controllers.length < _maxTeams) {
      setState(() {
        _controllers.add(TextEditingController());
      });
    } else {
      CustomSnackBar.show(
        context: context,
        message: 'Maximum $_maxTeams teams allowed',
        type: SnackBarType.error,
      );
    }
  }

  void _removeTextField() {
    if (_controllers.length > _minTeams) {
      setState(() {
        _controllers.last.dispose();
        _controllers.removeLast();
      });
    } else {
      CustomSnackBar.show(
        context: context,
        message: 'Minimum $_minTeams teams required',
        type: SnackBarType.error,
      );
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final gameName = _gameNameController.text.trim();
      final teams = _controllers
          .where((controller) => controller.text.trim().isNotEmpty)
          .map((controller) => Team(name: controller.text.trim()))
          .toList();

      if (teams.length < _minTeams) {
        CustomSnackBar.show(
          context: context,
          message: 'Please add at least $_minTeams teams!',
          type: SnackBarType.error,
        );
        return;
      }

      controller.createDummyGame(gameName, teams);
      Navigator.pop(context);
      navigationController.changePage(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 
            MediaQuery.of(context).viewInsets.bottom + 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create New Game',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _gameNameController,
                decoration: InputDecoration(
                  labelText: 'Game Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Please enter a game name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Teams (${_controllers.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _removeTextField,
                        icon: Icon(Icons.remove_circle_outline),
                        color: _controllers.length > _minTeams 
                            ? Colors.red
                            : Colors.grey,
                      ),
                      IconButton(
                        onPressed: _addTextField,
                        icon: Icon(Icons.add_circle_outline),
                        color: _controllers.length < _maxTeams 
                            ? Colors.red 
                            : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              ...List.generate(_controllers.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      labelText: 'Team ${index + 1}',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter a team name';
                      }
                      return null;
                    },
                  ),
                );
              }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
