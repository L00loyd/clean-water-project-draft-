import 'package:material_ui/material_ui.dart';
import 'package:latlong2/latlong.dart';

enum WaterPointType { publicTap, mosque, park, refillStation }

enum WaterStatus { working, needsRepair }

extension WaterPointTypeX on WaterPointType {
  String get label {
    switch (this) {
      case WaterPointType.publicTap:
        return 'Public Tap';
      case WaterPointType.mosque:
        return 'Mosque';
      case WaterPointType.park:
        return 'Park';
      case WaterPointType.refillStation:
        return 'Refill Station';
    }
  }

  IconData get icon {
    switch (this) {
      case WaterPointType.publicTap:
        return Icons.water_drop;
      case WaterPointType.mosque:
        return Icons.mosque;
      case WaterPointType.park:
        return Icons.park;
      case WaterPointType.refillStation:
        return Icons.local_drink;
    }
  }
}

extension WaterStatusX on WaterStatus {
  String get label =>
      this == WaterStatus.working ? 'Working' : 'Needs repair';
  Color get color =>
      this == WaterStatus.working ? Colors.green : Colors.orange;
}

class WaterPoint {
  final String id;
  final String name;
  final WaterPointType type;
  final WaterStatus status;
  final String address;
  final LatLng location;
  final String openingHours;
  final String description;
  final String waterQuality;
  final List<String> facilities;
  final String lastVerified;

  const WaterPoint({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.address,
    required this.location,
    required this.openingHours,
    required this.description,
    required this.waterQuality,
    required this.facilities,
    required this.lastVerified,
  });
}

/// Centre of Shah Alam, used as the initial map position.
const LatLng shahAlamCenter = LatLng(3.0738, 101.5183);

/// SAMPLE DATA for the prototype only.
/// Coordinates are approximate and details are placeholders; replace with
/// real, verified water points before presenting them as factual.
const List<WaterPoint> samplePoints = [
  WaterPoint(
    id: 'wp1',
    name: 'Sultan Salahuddin Abdul Aziz Shah Mosque',
    type: WaterPointType.mosque,
    status: WaterStatus.working,
    address: 'Persiaran Masjid, Seksyen 14, Shah Alam',
    location: LatLng(3.0785, 101.5214),
    openingHours: 'Daily, 5:00 AM - 10:00 PM',
    description:
        'Drinking water taps near the main ablution area, open to visitors.',
    waterQuality: 'Filtered tap water',
    facilities: ['Free', 'Wheelchair access', 'Covered area'],
    lastVerified: '10 Nov 2026',
  ),
  WaterPoint(
    id: 'wp2',
    name: 'Taman Tasik Shah Alam Water Station',
    type: WaterPointType.park,
    status: WaterStatus.working,
    address: 'Taman Tasik Shah Alam, Seksyen 14',
    location: LatLng(3.0640, 101.5320),
    openingHours: 'Daily, 6:00 AM - 8:00 PM',
    description:
        'Refill point beside the jogging track, popular with joggers and cyclists.',
    waterQuality: 'Filtered drinking water',
    facilities: ['Free', 'Bottle refill', 'Near toilets'],
    lastVerified: '12 Nov 2026',
  ),
  WaterPoint(
    id: 'wp3',
    name: 'Dataran Kemerdekaan Public Tap',
    type: WaterPointType.publicTap,
    status: WaterStatus.needsRepair,
    address: 'Dataran Kemerdekaan, Seksyen 14',
    location: LatLng(3.0752, 101.5160),
    openingHours: 'Open 24 hours',
    description: 'Public tap at the edge of the square. Low pressure reported.',
    waterQuality: 'Untreated mains water (boil before drinking)',
    facilities: ['Free', 'Open 24h'],
    lastVerified: '2 Nov 2026',
  ),
  WaterPoint(
    id: 'wp4',
    name: 'UiTM Shah Alam Library Refill Station',
    type: WaterPointType.refillStation,
    status: WaterStatus.working,
    address: 'Universiti Teknologi MARA, Seksyen 1',
    location: LatLng(3.0690, 101.5035),
    openingHours: 'Mon - Fri, 8:00 AM - 10:00 PM',
    description: 'Chilled and ambient water dispenser on the ground floor.',
    waterQuality: 'Multi-stage filtered',
    facilities: ['Free', 'Chilled', 'Bottle refill'],
    lastVerified: '15 Nov 2026',
  ),
  WaterPoint(
    id: 'wp5',
    name: 'Stadium Shah Alam Water Point',
    type: WaterPointType.publicTap,
    status: WaterStatus.working,
    address: 'Persiaran Sukan, Seksyen 13',
    location: LatLng(3.0830, 101.5410),
    openingHours: 'Daily, 7:00 AM - 9:00 PM',
    description: 'Water taps near the main entrance gate.',
    waterQuality: 'Filtered tap water',
    facilities: ['Free', 'Wheelchair access'],
    lastVerified: '8 Nov 2026',
  ),
  WaterPoint(
    id: 'wp6',
    name: 'i-City Community Refill Point',
    type: WaterPointType.refillStation,
    status: WaterStatus.working,
    address: 'i-City, Seksyen 7',
    location: LatLng(3.0660, 101.4855),
    openingHours: 'Daily, 10:00 AM - 10:00 PM',
    description: 'Self-service refill machine near the main walkway.',
    waterQuality: 'Reverse osmosis',
    facilities: ['Low fee', 'Bottle refill', 'Air-conditioned'],
    lastVerified: '14 Nov 2026',
  ),
  WaterPoint(
    id: 'wp7',
    name: 'Masjid Jamek Seksyen 7',
    type: WaterPointType.mosque,
    status: WaterStatus.working,
    address: 'Jalan Pahat, Seksyen 7, Shah Alam',
    location: LatLng(3.0765, 101.4970),
    openingHours: 'Daily, 5:00 AM - 10:00 PM',
    description: 'Drinking water dispenser outside the main prayer hall.',
    waterQuality: 'Filtered drinking water',
    facilities: ['Free', 'Covered area'],
    lastVerified: '9 Nov 2026',
  ),
];
