import 'package:material_ui/material_ui.dart';

import 'app_theme.dart';
import 'login_screen.dart';
import 'map_screen.dart';
import 'onboarding_screen.dart';
import 'register_screen.dart';
import 'store.dart';

void main() => runApp(const CleanWaterApp());

class CleanWaterApp extends StatelessWidget {
  const CleanWaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shah Alam Clean Water Map',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (_) => const OnboardingScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => UserStore.current.value == null
    ? const LoginScreen()
    : const MapScreen(),
      },
    );  
  }
}