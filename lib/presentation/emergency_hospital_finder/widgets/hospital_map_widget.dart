import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class HospitalMapWidget extends StatefulWidget {
  final LatLng userLocation;
  final List<Map<String, dynamic>> hospitals;
  final Function(Map<String, dynamic>) onHospitalTap;

  const HospitalMapWidget({
    Key? key,
    required this.userLocation,
    required this.hospitals,
    required this.onHospitalTap,
  }) : super(key: key);

  @override
  State<HospitalMapWidget> createState() => _HospitalMapWidgetState();
}

class _HospitalMapWidgetState extends State<HospitalMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers.clear();
    _circles.clear();

    // Add user location marker
    _markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: widget.userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: 'Current position',
        ),
      ),
    );

    // Add radius circle around user location
    _circles.add(
      Circle(
        circleId: const CircleId('search_radius'),
        center: widget.userLocation,
        radius: 5000, // 5km radius
        fillColor:
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        strokeColor:
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        strokeWidth: 2,
      ),
    );

    // Add hospital markers
    for (var hospital in widget.hospitals) {
      final String availability = hospital['availability'] as String;
      BitmapDescriptor markerColor;

      switch (availability.toLowerCase()) {
        case 'available':
          markerColor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
          break;
        case 'busy':
          markerColor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
          break;
        case 'full':
          markerColor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          break;
        default:
          markerColor = BitmapDescriptor.defaultMarker;
      }

      _markers.add(
        Marker(
          markerId: MarkerId('hospital_${hospital['id']}'),
          position: LatLng(
            hospital['latitude'] as double,
            hospital['longitude'] as double,
          ),
          icon: markerColor,
          infoWindow: InfoWindow(
            title: hospital['name'] as String,
            snippet: '${hospital['distance']} km • ${hospital['availability']}',
            onTap: () => widget.onHospitalTap(hospital),
          ),
          onTap: () => widget.onHospitalTap(hospital),
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(HospitalMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hospitals != widget.hospitals ||
        oldWidget.userLocation != widget.userLocation) {
      _createMarkers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 100.w,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: widget.userLocation,
          zoom: 13.0,
        ),
        markers: _markers,
        circles: _circles,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        mapToolbarEnabled: false,
        compassEnabled: true,
        trafficEnabled: false,
        buildingsEnabled: true,
        indoorViewEnabled: false,
        mapType: MapType.normal,
        onTap: (LatLng position) {
          // Handle map tap if needed
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
