import 'package:material_ui/material_ui.dart';

import 'app_theme.dart';
import 'store.dart';
import 'water_point.dart';

class WaterPointDetailScreen extends StatefulWidget {
  final WaterPoint point;
  const WaterPointDetailScreen({super.key, required this.point});

  @override
  State<WaterPointDetailScreen> createState() =>
      _WaterPointDetailScreenState();
}

class _WaterPointDetailScreenState extends State<WaterPointDetailScreen> {
  WaterPoint get p => widget.point;

  bool get _saved => SavedStore.isSaved(p.id);

  void _snack(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _reportIssue() async {
    String? reason;
    final reasons = [
      'Tap is broken',
      'Water looks or tastes unclean',
      'Location is wrong',
      'No longer available',
    ];

    final submitted = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Report an issue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final r in reasons)
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(r),
                  value: r,
                  groupValue: reason,
                  onChanged: (v) => setLocal(() => reason = v),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(100, 44)),
              onPressed: reason == null ? null : () => Navigator.pop(ctx, true),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );

    if (submitted == true) _snack('Thanks! Your report was submitted.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                tooltip: _saved ? 'Remove from saved' : 'Save',
                icon: Icon(_saved ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  SavedStore.toggle(p.id);
                  setState(() {});
                  _snack(_saved ? 'Saved to favourites' : 'Removed from saved');
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                p.name,
                style: const TextStyle(fontSize: 16),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.secondary, AppTheme.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(p.type.icon,
                      size: 80, color: Colors.white.withAlpha(200)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        avatar: Icon(Icons.circle,
                            size: 12, color: p.status.color),
                        label: Text(p.status.label),
                        backgroundColor: Colors.white,
                      ),
                      Chip(
                        avatar: Icon(p.type.icon,
                            size: 16, color: AppTheme.primary),
                        label: Text(p.type.label),
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(p.description, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Column(
                      children: [
                        _InfoTile(
                            icon: Icons.place_outlined,
                            title: 'Address',
                            value: p.address),
                        const Divider(height: 1),
                        _InfoTile(
                            icon: Icons.schedule,
                            title: 'Opening hours',
                            value: p.openingHours),
                        const Divider(height: 1),
                        _InfoTile(
                            icon: Icons.water_drop_outlined,
                            title: 'Water quality',
                            value: p.waterQuality),
                        const Divider(height: 1),
                        _InfoTile(
                            icon: Icons.verified_outlined,
                            title: 'Last verified',
                            value: p.lastVerified),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Facilities',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final f in p.facilities)
                        Chip(
                          label: Text(f),
                          backgroundColor: AppTheme.primary.withAlpha(25),
                          side: BorderSide.none,
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: () => _snack(
                        'Directions coming soon (${p.location.latitude.toStringAsFixed(4)}, '
                        '${p.location.longitude.toStringAsFixed(4)})'),
                    icon: const Icon(Icons.directions),
                    label: const Text('Get Directions'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _reportIssue,
                    icon: const Icon(Icons.flag_outlined),
                    label: const Text('Report an Issue'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _InfoTile(
      {required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title,
          style: const TextStyle(fontSize: 13, color: Colors.black54)),
      subtitle: Text(value,
          style: const TextStyle(fontSize: 15, color: Colors.black87)),
    );
  }
}
