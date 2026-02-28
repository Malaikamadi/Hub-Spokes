import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/models/dashboard_models.dart';

class FacilityMapWidget extends StatelessWidget {
  final String selectedQuarter;

  const FacilityMapWidget({super.key, required this.selectedQuarter});

  // Mock coordinates for demonstration mapped to District / Facility Name
  Map<String, LatLng> _getFacilityCoordinates() {
    return {
      'Jembe CHC': const LatLng(8.2, -11.5),
      'JMB Paediatric Centre': const LatLng(8.48, -13.23), // Freetown area
      'Kagbere CHC': const LatLng(9.1, -12.5),
      'Kakua Static CHC': const LatLng(7.95, -11.73), // Bo area
      'Kamabai CHC': const LatLng(9.16, -11.95), // Bombali
      'Kamaranka CHC': const LatLng(8.35, -12.16),
      'Kenema Government Hospital Hub': const LatLng(7.87, -11.18),
      'Kingharman Road Hospital': const LatLng(8.48, -13.25),
      'Koribondo CHC': const LatLng(7.85, -11.66), // Bo
      'Kuntorloh CHC': const LatLng(8.46, -13.18),
      'Largo CHC': const LatLng(8.0, -11.2),
      'Levuma CHP': const LatLng(8.1, -11.3),
      'Mabella CHC': const LatLng(8.49, -13.22),
      'Makeni Government Hospital Hub': const LatLng(8.88, -12.04), // Makeni
      'Malama CHP': const LatLng(8.45, -13.20),
    };
  }

  @override
  Widget build(BuildContext context) {
    final quarter = selectedQuarter == 'All' ? 'Q1' : selectedQuarter;
    final facilities = MockData.facilityDistribution[quarter] ?? [];
    final coords = _getFacilityCoordinates();

    return Container(
      key: ValueKey('map_$selectedQuarter'),
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(8.4606, -11.7799), // Center of Sierra Leone
          initialZoom: 6.8,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.hub_spokes.app',
          ),
          MarkerLayer(
            markers: facilities.map((f) {
              final latLng = coords[f.facilityName] ?? const LatLng(8.46, -11.77);
              // Scale radius based on value to create a "Heatmap" bubble effect
              final double size = 20 + (f.value / 10);
              return Marker(
                point: latLng,
                width: size * 2,
                height: size * 2,
                child: Tooltip(
                  message: '${f.facilityName}\nValue: ${f.value.toInt()}',
                  textStyle: GoogleFonts.inter(color: Colors.white, fontSize: 12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: f.isHub
                          ? AppColors.chartHub.withValues(alpha: 0.7)
                          : AppColors.chartSpoke.withValues(alpha: 0.7),
                      border: Border.all(
                        color: f.isHub ? AppColors.chartHub : AppColors.chartSpoke,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (f.isHub ? AppColors.chartHub : AppColors.chartSpoke).withValues(alpha: 0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
