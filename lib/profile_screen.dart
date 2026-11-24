import 'package:material_ui/material_ui.dart';

import 'app_theme.dart';
import 'store.dart';
import 'water_point.dart';
import 'water_point_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;

  void _logout() {
    UserStore.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: SavedStore.ids,
        builder: (context, savedIds, _) {
          return ValueListenableBuilder<List<WaterPoint>>(
            valueListenable: PointsStore.points,
            builder: (context, allPoints, _) {
              final saved =
                  allPoints.where((p) => savedIds.contains(p.id)).toList();
              final addedCount = PointsStore.userAdded.length;

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Header
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: AppTheme.primary,
                        child: Icon(Icons.person,
                            size: 40, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ValueListenableBuilder<AppUser?>(
                          valueListenable: UserStore.current,
                          builder: (context, user, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user?.name ?? 'Guest User',
                                    style: theme.textTheme.titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(user?.email ?? 'Not logged in',
                                    style: const TextStyle(color: Colors.black54)),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats
                  Row(
                    children: [
                      Expanded(
                          child: _StatCard(
                              icon: Icons.favorite,
                              value: '${saved.length}',
                              label: 'Saved')),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _StatCard(
                              icon: Icons.add_location_alt,
                              value: '$addedCount',
                              label: 'Added by you')),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Saved list
                  Text('Saved Water Points',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (saved.isEmpty)
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: const [
                            Icon(Icons.favorite_border,
                                size: 40, color: Colors.black38),
                            SizedBox(height: 8),
                            Text(
                              'No saved water points yet.\nTap the heart on a water point to save it.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    for (final p in saved)
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primary.withAlpha(30),
                            child:
                                Icon(p.type.icon, color: AppTheme.primary),
                          ),
                          title: Text(p.name,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(
                              '${p.type.label} • ${p.status.label}'),
                          trailing: IconButton(
                            tooltip: 'Remove from saved',
                            icon: const Icon(Icons.favorite,
                                color: Colors.redAccent),
                            onPressed: () => SavedStore.toggle(p.id),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WaterPointDetailScreen(point: p),
                            ),
                          ),
                        ),
                      ),
                  const SizedBox(height: 24),

                  // Settings
                  Text('Settings',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Column(
                      children: [
                        SwitchListTile(
                          secondary: const Icon(Icons.notifications_outlined,
                              color: AppTheme.primary),
                          title: const Text('Nearby water alerts'),
                          value: _notifications,
                          onChanged: (v) =>
                              setState(() => _notifications = v),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.info_outline,
                              color: AppTheme.primary),
                          title: const Text('About this app'),
                          onTap: () => showAboutDialog(
                            context: context,
                            applicationName: 'Shah Alam Clean Water Map',
                            applicationVersion: '1.0.0 (prototype)',
                            applicationIcon: const Icon(
                                Icons.water_drop_rounded,
                                color: AppTheme.primary,
                                size: 40),
                            children: const [
                              Text(
                                  'Helping residents and visitors find clean drinking water in Shah Alam.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Log Out'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primary),
            const SizedBox(height: 6),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
