import 'package:material_ui/material_ui.dart';

import 'app_theme.dart';

class _OnboardPage {
  final IconData icon;
  final String title;
  final String body;
  const _OnboardPage(this.icon, this.title, this.body);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = [
    _OnboardPage(
      Icons.water_drop_rounded,
      'Find Clean Water Nearby',
      'Discover verified drinking water points across Shah Alam, '
          'from public parks to mosques and community halls.',
    ),
    _OnboardPage(
      Icons.map_rounded,
      'See Them on the Map',
      'Browse an interactive map of Shah Alam, filter by water type '
          'and get directions to the closest point.',
    ),
    _OnboardPage(
      Icons.volunteer_activism_rounded,
      'Help Your Community',
      'Report broken taps, share water quality updates and add new '
          'water points so everyone stays hydrated.',
    ),
  ];

  bool get _isLast => _index == _pages.length - 1;

  void _goToLogin() => Navigator.pushReplacementNamed(context, '/login');

  void _next() {
    if (_isLast) {
      _goToLogin();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _goToLogin,
                child: Text(_isLast ? '' : 'Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppTheme.secondary, AppTheme.primary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withAlpha(70),
                                blurRadius: 30,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Icon(p.icon, size: 88, color: Colors.white),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          p.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          p.body,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final active = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: active ? 26 : 8,
                  decoration: BoxDecoration(
                    color: active
                        ? AppTheme.primary
                        : AppTheme.primary.withAlpha(60),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: FilledButton(
                onPressed: _next,
                child: Text(_isLast ? 'Get Started' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}