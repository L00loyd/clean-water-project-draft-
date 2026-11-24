import 'package:material_ui/material_ui.dart';
import 'package:flutter_map/flutter_map.dart';

import 'app_theme.dart';
import 'add_water_point_screen.dart';
import 'profile_screen.dart';
import 'store.dart';
import 'water_point.dart';
import 'water_point_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();
  WaterPointType? _filter; // null = show all

  @override
  void initState() {
    super.initState();
    PointsStore.points.addListener(_onPointsChanged);
  }

  @override
  void dispose() {
    PointsStore.points.removeListener(_onPointsChanged);
    super.dispose();
  }

  void _onPointsChanged() {
    if (mounted) setState(() {});
  }

  List<WaterPoint> get _visiblePoints {
    final all = PointsStore.points.value;
    return _filter == null ? all : all.where((p) => p.type == _filter).toList();
  }

  void _openDetail(WaterPoint point) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WaterPointDetailScreen(point: point)),
    );
  }

  void _showPreview(WaterPoint point) {
    _mapController.move(point.location, 15);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primary.withAlpha(30),
                  child: Icon(point.type.icon, color: AppTheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    point.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.circle, size: 12, color: point.status.color),
                const SizedBox(width: 6),
                Text(point.status.label),
                const SizedBox(width: 16),
                const Icon(Icons.schedule, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    point.openingHours,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(point.address,
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _openDetail(point);
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final points = _visiblePoints;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shah Alam Water Map'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'My profile',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: shahAlamCenter,
              initialZoom: 12.5,
              minZoom: 10,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.clean_water_map',
              ),
              MarkerLayer(
                markers: [
                  for (final p in points)
                    Marker(
                      point: p.location,
                      width: 48,
                      height: 48,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () => _showPreview(p),
                        child: Icon(
                          Icons.location_on,
                          size: 48,
                          color: p.status == WaterStatus.working
                              ? AppTheme.primary
                              : Colors.orange,
                        ),
                      ),
                    ),
                ],
              ),
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ],
          ),

          // Filter chips
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _chip('All', null, Icons.apps),
                  for (final t in WaterPointType.values)
                    _chip(t.label, t, t.icon),
                ],
              ),
            ),
          ),

          // Legend
          Positioned(
            left: 12,
            bottom: 16,
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    _LegendRow(color: AppTheme.primary, text: 'Working'),
                    SizedBox(height: 4),
                    _LegendRow(color: Colors.orange, text: 'Needs repair'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'recenter',
            tooltip: 'Recenter on Shah Alam',
            onPressed: () => _mapController.move(shahAlamCenter, 12.5),
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'add',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddWaterPointScreen()),
            ),
            icon: const Icon(Icons.add_location_alt),
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, WaterPointType? type, IconData icon) {
    final selected = _filter == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        avatar: Icon(icon,
            size: 18, color: selected ? Colors.white : AppTheme.primary),
        label: Text(label),
        labelStyle: TextStyle(color: selected ? Colors.white : null),
        selected: selected,
        showCheckmark: false,
        selectedColor: AppTheme.primary,
        backgroundColor: Colors.white,
        onSelected: (_) => setState(() => _filter = type),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendRow({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_on, size: 18, color: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
