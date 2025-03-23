import 'package:flutter/material.dart';
import 'package:game_counter/controllers/theme_controller.dart';
import 'package:get/get.dart';

class ThemeCustomizationScreen extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Theme'),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: GetBuilder<ThemeController>(
        builder: (controller) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Theme mode section
            Card(
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
                        Icon(Icons.brightness_4, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Theme Mode',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Radio buttons for theme mode
                    _buildThemeModeOption(
                      context: context,
                      title: 'Light',
                      icon: Icons.light_mode,
                      isSelected: controller.themeMode == ThemeMode.light,
                      onTap: () => controller.setThemeMode(ThemeMode.light),
                    ),
                    
                    _buildThemeModeOption(
                      context: context,
                      title: 'Dark',
                      icon: Icons.dark_mode,
                      isSelected: controller.themeMode == ThemeMode.dark,
                      onTap: () => controller.setThemeMode(ThemeMode.dark),
                    ),
                    
                    _buildThemeModeOption(
                      context: context,
                      title: 'System Default',
                      icon: Icons.settings_suggest,
                      isSelected: controller.themeMode == ThemeMode.system,
                      onTap: () => controller.setThemeMode(ThemeMode.system),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Theme color section
            Card(
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
                        Icon(Icons.color_lens, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Color Theme',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Color theme options
                    ...List.generate(controller.themeNames.length, (index) {
                      // Get the color scheme for preview
                      final previewColorScheme = controller.themes[index].colorScheme;
                      
                      return _buildColorThemeOption(
                        context: context,
                        title: controller.themeNames[index],
                        primaryColor: previewColorScheme.primary,
                        secondaryColor: previewColorScheme.secondary,
                        tertiaryColor: previewColorScheme.tertiary,
                        isSelected: controller.themeIndex == index,
                        onTap: () => controller.setThemeColor(index),
                      );
                    }),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Information card
            Card(
              elevation: 0,
              color: colorScheme.primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Theme changes are applied immediately and will be saved for your next visit.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget for theme mode option
  Widget _buildThemeModeOption({
    required BuildContext context, 
    required String title, 
    required IconData icon, 
    required bool isSelected, 
    required VoidCallback onTap
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
  
  // Widget for color theme option
  Widget _buildColorThemeOption({
    required BuildContext context,
    required String title,
    required Color primaryColor,
    required Color secondaryColor,
    required Color tertiaryColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            // Theme color preview
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: tertiaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
