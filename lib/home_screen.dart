import 'package:material_ui/material_ui.dart';

import 'app_theme.dart';

/// Placeholder so login can navigate somewhere.
/// Replace with the real map screen in the next step.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shah Alam Water Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_rounded, size: 80, color: AppTheme.primary),
            SizedBox(height: 16),
            Text('Map screen coming next'),
          ],
        ),
      ),
    );
  }
}