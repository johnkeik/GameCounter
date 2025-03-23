import 'package:flutter/material.dart';
import 'package:game_counter/controllers/theme_controller.dart';
import 'package:game_counter/screens/profile/theme_customization.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Sample game stats - would come from your database
  final Map<String, dynamic> gameStats = {
    'gamesPlayed': 42,
    'gamesWon': 15,
    'favGame': 'Monopoly',
    'totalTime': '28h 15m',
  };

  // Theme mode state
  bool _isDarkMode = false;
  bool _useSystemTheme = true;

  // Notification settings
  bool _gameReminders = true;
  bool _friendActivity = false;
  bool _appUpdates = true;
  
  // Display name controller
  final TextEditingController _nameController = TextEditingController(text: 'John');

  // Get the theme controller
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Settings section widget builder
  Widget _buildSettingsSection(
    String title,
    IconData icon,
    List<Widget> children,
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  // Setting item with switch
  Widget _buildSwitchItem(
    String title,
    String? subtitle,
    bool value,
    Function(bool) onChanged,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  // Game stat item
  Widget _buildStatItem(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: topPadding + 16, left: 20, right: 20, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Center(
              child: Column(
                children: [
                  // Profile avatar
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: colorScheme.primary.withOpacity(0.2),
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: colorScheme.primary,
                        ),
                      ),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: colorScheme.primary,
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // User name
                  Text(
                    'John',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Board Game Enthusiast',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Game stats card
            Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              color: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bar_chart, color: colorScheme.onPrimary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Game Statistics',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Games Played', gameStats['gamesPlayed'].toString(), context),
                        _buildStatItem('Games Won', gameStats['gamesWon'].toString(), context),
                        _buildStatItem('Win Rate', '${((gameStats['gamesWon'] / gameStats['gamesPlayed']) * 100).round()}%', context),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    Divider(height: 1, color: colorScheme.onPrimary.withOpacity(0.2)),
                    const SizedBox(height: 16),
                    
                    // Favorite game and play time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Favorite Game',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimary.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              gameStats['favGame'],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.timer,
                              color: Colors.amber,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total Play Time',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimary.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              gameStats['totalTime'],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Personal settings section
            _buildSettingsSection(
              'Personal Settings',
              Icons.person_outline,
              [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      filled: true,
                      fillColor: colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.account_circle),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Save name logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile updated!')),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
              ],
              context,
            ),
            
            // Theme settings section
            _buildSettingsSection(
              'Appearance',
              Icons.palette_outlined,
              [
                GetBuilder<ThemeController>(
                  builder: (controller) => _buildSwitchItem(
                    'Use System Theme',
                    'Automatically match your device theme',
                    controller.themeMode == ThemeMode.system,
                    (value) {
                      controller.setThemeMode(value ? ThemeMode.system : 
                        (_isDarkMode ? ThemeMode.dark : ThemeMode.light));
                      setState(() => _useSystemTheme = value);
                    },
                    context,
                  ),
                ),
                
                if (!_useSystemTheme)
                  GetBuilder<ThemeController>(
                    builder: (controller) => _buildSwitchItem(
                      'Dark Mode',
                      'Use dark theme throughout the app',
                      controller.themeMode == ThemeMode.dark,
                      (value) {
                        controller.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                        setState(() => _isDarkMode = value);
                      },
                      context,
                    ),
                  ),
                
                const SizedBox(height: 8),
                
                OutlinedButton.icon(
                  onPressed: () {
                    Get.to(() => ThemeCustomizationScreen());
                  },
                  icon: const Icon(Icons.color_lens),
                  label: const Text('Customize Colors'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
              context,
            ),
            
            // Notification settings section
            _buildSettingsSection(
              'Notifications',
              Icons.notifications_outlined,
              [
                _buildSwitchItem(
                  'Game Reminders',
                  'Get notified about upcoming games',
                  _gameReminders,
                  (value) {
                    setState(() {
                      _gameReminders = value;
                    });
                  },
                  context,
                ),
                _buildSwitchItem(
                  'Friend Activity',
                  'Get notified when friends start a game',
                  _friendActivity,
                  (value) {
                    setState(() {
                      _friendActivity = value;
                    });
                  },
                  context,
                ),
                _buildSwitchItem(
                  'App Updates',
                  'Get notified about new features and updates',
                  _appUpdates,
                  (value) {
                    setState(() {
                      _appUpdates = value;
                    });
                  },
                  context,
                ),
              ],
              context,
            ),
            
            // About & Support
            _buildSettingsSection(
              'About & Support',
              Icons.help_outline,
              [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.info_outline, color: colorScheme.primary),
                  title: Text('App Version'),
                  subtitle: Text('v1.0.0'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.help_outline, color: colorScheme.primary),
                  title: Text('Help & Support'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.privacy_tip_outlined, color: colorScheme.primary),
                  title: Text('Privacy Policy'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
              context,
            ),
            
            // Sign out button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Sign out logic
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}