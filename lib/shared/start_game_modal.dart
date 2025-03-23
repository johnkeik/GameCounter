import 'package:flutter/material.dart';
import 'package:game_counter/controllers/game_controller.dart';
import 'package:game_counter/controllers/navigation_controller.dart';
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
  // Initialize with 2 controllers instead of just 1
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController()
  ];
  final GameController controller = Get.put(GameController());
  final NavigationController navigationController =
      Get.put(NavigationController());
  double _numberOfTeams = 2;
  double _roundsTimer = 0;
  
  // Add a scroll controller for the teams list
  final ScrollController _teamsScrollController = ScrollController();

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _gameNameController.dispose();
    _teamsScrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  void _updateControllers(double newValue) {
    int currentCount = _controllers.length;
    int newCount = newValue.round();

    if (newCount > currentCount) {
      // Add controllers if the new count is higher
      for (int i = 0; i < newCount - currentCount; i++) {
        _controllers.add(TextEditingController());
      }
    } else if (newCount < currentCount) {
      // Remove controllers if the new count is lower, but dispose them first
      for (int i = currentCount - 1; i >= newCount; i--) {
        _controllers[i].dispose();
      }
      _controllers.removeRange(newCount, currentCount);
    }

    setState(() {
      _numberOfTeams = newValue;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final gameName = _gameNameController.text.trim();
      final teams = _controllers
          .where((controller) => controller.text.trim().isNotEmpty)
          .map((controller) => Team(name: controller.text.trim()))
          .toList();

      controller.createDummyGame(gameName, teams);
      Navigator.pop(context);
      navigationController.changePage(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle to drag the sheet
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Title
              Center(
                child: Text(
                  'Create New Game',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Game name card - more compact
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.videogame_asset, color: colorScheme.primary, size: 20),
                          const SizedBox(width: 8),
                          Text('Game Details', 
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _gameNameController,
                        decoration: InputDecoration(
                          labelText: 'Game Name',
                          hintText: 'Enter a name for your game',
                          filled: true,
                          fillColor: colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.edit),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Please enter a game name';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Settings card - more compact
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.settings, color: colorScheme.primary, size: 20),
                          const SizedBox(width: 8),
                          Text('Game Settings', 
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.group, size: 18, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text('Teams (${_numberOfTeams.round()})',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Expanded(
                            child: Slider(
                              value: _numberOfTeams,
                              min: 2,
                              max: 10,
                              divisions: 8,
                              label: _numberOfTeams.round().toString(),
                              activeColor: colorScheme.primary,
                              onChanged: (double value) {
                                _updateControllers(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      Row(
                        children: [
                          Icon(Icons.timer, size: 18, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text('Round Timer (${_roundsTimer.round()}s)', 
                              style: Theme.of(context).textTheme.bodyMedium),
                          Expanded(
                            child: Slider(
                              value: _roundsTimer,
                              max: 180,
                              divisions: 18,
                              label: _roundsTimer.round().toString(),
                              activeColor: colorScheme.primary,
                              onChanged: (double value) {
                                setState(() {
                                  _roundsTimer = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Teams section - scrollable with fixed height
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people, color: colorScheme.primary, size: 20),
                              const SizedBox(width: 8),
                              Text('Team Names', 
                                  style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          Text('${_numberOfTeams.round()} teams',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Scrollable container with fixed height
                      Container(
                        height: screenHeight * 0.2, // 20% of screen height
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Scrollbar(
                          controller: _teamsScrollController, // Connect the controller to the Scrollbar
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: ListView.builder(
                            controller: _teamsScrollController, // Connect the same controller to the ListView
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            itemCount: _controllers.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: TextFormField(
                                  controller: _controllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Team ${index + 1}',
                                    hintText: 'Enter team name',
                                    filled: true,
                                    fillColor: colorScheme.surface,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: const Icon(Icons.group),
                                    suffixIcon: index >= 2 ? IconButton(
                                      icon: const Icon(Icons.highlight_off, size: 18),
                                      onPressed: () {
                                        if (_controllers.length > 2) {
                                          setState(() {
                                            _controllers[index].dispose();
                                            _controllers.removeAt(index);
                                            _numberOfTeams = _controllers.length.toDouble();
                                          });
                                        }
                                      },
                                    ) : null,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  validator: (value) {
                                    if (value?.trim().isEmpty ?? true) {
                                      return 'Please enter a team name';
                                    }
                                    return null;
                                  },
                                ),
                              );
                            }
                          ),
                        ),
                      ),
                      
                      // Quick-add team button
                      if (_controllers.length < 10)
                        TextButton.icon(
                          onPressed: () {
                            if (_controllers.length < 10) {
                              setState(() {
                                _controllers.add(TextEditingController());
                                _numberOfTeams = _controllers.length.toDouble();
                              });
                            }
                          },
                          icon: const Icon(Icons.add_circle_outline, size: 18),
                          label: const Text('Add Team'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Start button
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow),
                    const SizedBox(width: 8),
                    Text(
                      'Start Game',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
