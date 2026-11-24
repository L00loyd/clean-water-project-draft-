import 'package:material_ui/material_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'app_theme.dart';
import 'store.dart';
import 'water_point.dart';

class AddWaterPointScreen extends StatefulWidget {
  const AddWaterPointScreen({super.key});

  @override
  State<AddWaterPointScreen> createState() => _AddWaterPointScreenState();
}

class _AddWaterPointScreenState extends State<AddWaterPointScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _hoursCtrl = TextEditingController();

  WaterPointType _type = WaterPointType.publicTap;
  final Set<String> _facilities = {'Free'};
  LatLng? _picked;
  String? _locationError;
  bool _loading = false;

  static const _facilityOptions = [
    'Free',
    'Bottle refill',
    'Wheelchair access',
    'Covered area',
    'Chilled water',
  ];

  // Rough bounding box around Shah Alam (prototype check only).
  bool _inShahAlam(LatLng p) =>
      p.latitude >= 2.98 &&
      p.latitude <= 3.15 &&
      p.longitude >= 101.44 &&
      p.longitude <= 101.60;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _descCtrl.dispose();
    _hoursCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final formOk = _formKey.currentState!.validate();

    String? locError;
    if (_picked == null) {
      locError = 'Tap the map to mark the water point location';
    } else if (!_inShahAlam(_picked!)) {
      locError = 'Location must be within Shah Alam';
    }
    setState(() => _locationError = locError);
    if (!formOk || locError != null) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // fake network
    if (!mounted) return;

    PointsStore.add(
      WaterPoint(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameCtrl.text.trim(),
        type: _type,
        status: WaterStatus.working,
        address: _addressCtrl.text.trim(),
        location: _picked!,
        openingHours: _hoursCtrl.text.trim().isEmpty
            ? 'Not specified'
            : _hoursCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        waterQuality: 'Not yet tested',
        facilities: _facilities.toList(),
        lastVerified: 'Pending verification',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Water point added. Thank you!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Water Point')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Know a clean water point in Shah Alam that is not on the map? Add it here.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Name is required';
                    if (value.length < 3) return 'Name is too short';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<WaterPointType>(
                  initialValue: _type,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: [
                    for (final t in WaterPointType.values)
                      DropdownMenuItem(
                        value: t,
                        child: Text(t.label),
                      ),
                  ],
                  onChanged: (v) => setState(() => _type = v ?? _type),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Address / landmark',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                  validator: (v) => (v?.trim().isEmpty ?? true)
                      ? 'Address is required'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _hoursCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Opening hours (optional)',
                    hintText: 'e.g. Daily, 6:00 AM - 8:00 PM',
                    prefixIcon: Icon(Icons.schedule),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 44),
                      child: Icon(Icons.notes),
                    ),
                  ),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Description is required';
                    if (value.length < 10) return 'Add a little more detail';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text('Facilities',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final f in _facilityOptions)
                      FilterChip(
                        label: Text(f),
                        selected: _facilities.contains(f),
                        selectedColor: AppTheme.primary.withAlpha(50),
                        onSelected: (on) => setState(() {
                          on ? _facilities.add(f) : _facilities.remove(f);
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Location',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Tap the map to drop a pin.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.black54)),
                const SizedBox(height: 8),
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _locationError != null
                          ? theme.colorScheme.error
                          : AppTheme.primary.withAlpha(60),
                      width: _locationError != null ? 2 : 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: shahAlamCenter,
                      initialZoom: 12.5,
                      minZoom: 10,
                      maxZoom: 18,
                      onTap: (tapPosition, point) => setState(() {
                        _picked = point;
                        _locationError = null;
                      }),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.clean_water_map',
                      ),
                      if (_picked != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _picked!,
                              width: 44,
                              height: 44,
                              alignment: Alignment.topCenter,
                              child: const Icon(Icons.location_on,
                                  size: 44, color: AppTheme.primary),
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
                ),
                if (_locationError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      _locationError!,
                      style: TextStyle(
                          color: theme.colorScheme.error, fontSize: 12),
                    ),
                  ),
                if (_picked != null && _locationError == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      'Selected: ${_picked!.latitude.toStringAsFixed(5)}, '
                      '${_picked!.longitude.toStringAsFixed(5)}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.black54),
                    ),
                  ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Text('Submit Water Point'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
