import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/hospital_card_widget.dart';
import './widgets/hospital_map_widget.dart';
import './widgets/location_permission_dialog_widget.dart';

class EmergencyHospitalFinder extends StatefulWidget {
  const EmergencyHospitalFinder({Key? key}) : super(key: key);

  @override
  State<EmergencyHospitalFinder> createState() =>
      _EmergencyHospitalFinderState();
}

class _EmergencyHospitalFinderState extends State<EmergencyHospitalFinder>
    with TickerProviderStateMixin {
  bool _isMapView = true;
  bool _isLoading = true;
  bool _hasLocationPermission = false;
  LatLng _userLocation = const LatLng(28.6139, 77.2090); // Default to Delhi
  List<String> _selectedSpecialties = [];
  String _selectedSortOption = 'Distance';
  List<Map<String, dynamic>> _allHospitals = [];
  List<Map<String, dynamic>> _filteredHospitals = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _mockHospitals = [
    {
      "id": 1,
      "name": "Apollo Hospital",
      "address": "Sarita Vihar, New Delhi, 110076",
      "latitude": 28.5355,
      "longitude": 77.2730,
      "distance": 2.3,
      "travelTime": "8 mins",
      "availability": "Available",
      "phone": "+91-11-2692-5858",
      "specialties": ["Emergency", "Cardiology", "Neurology", "Orthopedic"],
      "rating": 4.5,
    },
    {
      "id": 2,
      "name": "Max Super Speciality Hospital",
      "address": "Press Enclave Road, Saket, New Delhi, 110017",
      "latitude": 28.5244,
      "longitude": 77.2066,
      "distance": 1.8,
      "travelTime": "6 mins",
      "availability": "Busy",
      "phone": "+91-11-2651-5050",
      "specialties": ["Emergency", "General", "Pediatrics", "Gynecology"],
      "rating": 4.3,
    },
    {
      "id": 3,
      "name": "Fortis Hospital",
      "address": "B-22, Sector 62, Noida, Uttar Pradesh 201301",
      "latitude": 28.6271,
      "longitude": 77.3716,
      "distance": 3.7,
      "travelTime": "12 mins",
      "availability": "Available",
      "phone": "+91-120-500-4444",
      "specialties": ["Emergency", "Cardiology", "Orthopedic", "Dermatology"],
      "rating": 4.4,
    },
    {
      "id": 4,
      "name": "AIIMS New Delhi",
      "address": "Sri Aurobindo Marg, Ansari Nagar, New Delhi, 110029",
      "latitude": 28.5672,
      "longitude": 77.2100,
      "distance": 4.2,
      "travelTime": "15 mins",
      "availability": "Full",
      "phone": "+91-11-2658-8500",
      "specialties": ["Emergency", "General", "Neurology", "Pediatrics"],
      "rating": 4.6,
    },
    {
      "id": 5,
      "name": "Medanta - The Medicity",
      "address": "Sector 38, Gurugram, Haryana 122001",
      "latitude": 28.4089,
      "longitude": 77.0424,
      "distance": 5.1,
      "travelTime": "18 mins",
      "availability": "Available",
      "phone": "+91-124-414-1414",
      "specialties": ["Emergency", "Cardiology", "Neurology", "Gynecology"],
      "rating": 4.7,
    },
    {
      "id": 6,
      "name": "BLK Super Speciality Hospital",
      "address": "Pusa Road, Rajinder Nagar, New Delhi, 110005",
      "latitude": 28.6448,
      "longitude": 77.1917,
      "distance": 3.9,
      "travelTime": "14 mins",
      "availability": "Busy",
      "phone": "+91-11-3040-3040",
      "specialties": ["Emergency", "General", "Orthopedic", "Dermatology"],
      "rating": 4.2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _initializeLocation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    try {
      if (kIsWeb) {
        // Web implementation
        await _requestLocationPermissionWeb();
      } else {
        // Mobile implementation
        await _requestLocationPermissionMobile();
      }
    } catch (e) {
      _loadMockData();
    }
  }

  Future<void> _requestLocationPermissionWeb() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _hasLocationPermission = true;
      });
      _loadMockData();
    } catch (e) {
      _showLocationPermissionDialog();
    }
  }

  Future<void> _requestLocationPermissionMobile() async {
    final permission = await Permission.location.request();
    if (permission.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
          _hasLocationPermission = true;
        });
        _loadMockData();
      } catch (e) {
        _loadMockData();
      }
    } else {
      _showLocationPermissionDialog();
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LocationPermissionDialogWidget(
        onAllowPressed: () {
          Navigator.pop(context);
          _requestLocationPermissionMobile();
        },
        onDenyPressed: () {
          Navigator.pop(context);
          _loadMockData();
        },
      ),
    );
  }

  void _loadMockData() {
    // Calculate distances and update mock data
    List<Map<String, dynamic>> updatedHospitals =
        _mockHospitals.map((hospital) {
      double distance = Geolocator.distanceBetween(
            _userLocation.latitude,
            _userLocation.longitude,
            hospital['latitude'] as double,
            hospital['longitude'] as double,
          ) /
          1000; // Convert to kilometers

      Map<String, dynamic> updatedHospital = Map.from(hospital);
      updatedHospital['distance'] = double.parse(distance.toStringAsFixed(1));
      updatedHospital['travelTime'] =
          '${(distance * 3).round()} mins'; // Rough estimate
      return updatedHospital;
    }).toList();

    setState(() {
      _allHospitals = updatedHospitals;
      _filteredHospitals = List.from(_allHospitals);
      _isLoading = false;
    });

    _animationController.forward();
    _sortHospitals();
  }

  void _sortHospitals() {
    setState(() {
      switch (_selectedSortOption) {
        case 'Distance':
          _filteredHospitals.sort((a, b) =>
              (a['distance'] as double).compareTo(b['distance'] as double));
          break;
        case 'Availability':
          _filteredHospitals.sort((a, b) {
            const availabilityOrder = {'Available': 0, 'Busy': 1, 'Full': 2};
            return (availabilityOrder[a['availability']] ?? 3)
                .compareTo(availabilityOrder[b['availability']] ?? 3);
          });
          break;
        case 'Rating':
          _filteredHospitals.sort((a, b) =>
              (b['rating'] as double).compareTo(a['rating'] as double));
          break;
      }
    });
  }

  void _applyFilters() {
    setState(() {
      if (_selectedSpecialties.isEmpty) {
        _filteredHospitals = List.from(_allHospitals);
      } else {
        _filteredHospitals = _allHospitals.where((hospital) {
          final hospitalSpecialties = hospital['specialties'] as List;
          return _selectedSpecialties.any((specialty) => hospitalSpecialties
              .any((hospitalSpecialty) => (hospitalSpecialty as String)
                  .toLowerCase()
                  .contains(specialty.toLowerCase())));
        }).toList();
      }
    });
    _sortHospitals();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        selectedSpecialties: _selectedSpecialties,
        selectedSortOption: _selectedSortOption,
        onFiltersApplied: (specialties, sortOption) {
          setState(() {
            _selectedSpecialties = specialties;
            _selectedSortOption = sortOption;
          });
          _applyFilters();
        },
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to make phone call')),
        );
      }
    }
  }

  Future<void> _navigateToHospital(Map<String, dynamic> hospital) async {
    final double lat = hospital['latitude'] as double;
    final double lng = hospital['longitude'] as double;

    if (kIsWeb) {
      final Uri launchUri = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
      try {
        if (await canLaunchUrl(launchUri)) {
          await launchUrl(launchUri);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to open navigation')),
          );
        }
      }
    } else {
      final Uri launchUri = Uri.parse('google.navigation:q=$lat,$lng&mode=d');
      try {
        if (await canLaunchUrl(launchUri)) {
          await launchUrl(launchUri);
        } else {
          // Fallback to Google Maps web
          final Uri webUri = Uri.parse(
              'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
          if (await canLaunchUrl(webUri)) {
            await launchUrl(webUri);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to open navigation')),
          );
        }
      }
    }
  }

  void _shareLocation(Map<String, dynamic> hospital) {
    // Placeholder for live location sharing
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing location to ${hospital['name']} with family...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _onHospitalTap(Map<String, dynamic> hospital) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital['name'] as String,
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      hospital['address'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${hospital['distance']} km away • ${hospital['travelTime']}',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'local_hospital',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Status: ${hospital['availability']}',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _makePhoneCall(hospital['phone'] as String);
                            },
                            icon: CustomIconWidget(
                              iconName: 'phone',
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text('Call Hospital'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme.lightTheme.colorScheme.secondary,
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _navigateToHospital(hospital);
                            },
                            icon: CustomIconWidget(
                              iconName: 'directions',
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text('Navigate'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text(
              'Emergency Mode',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'LIVE',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Finding nearest hospitals...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // View toggle and filter
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // View toggle
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isMapView = true;
                                  });
                                  HapticFeedback.selectionClick();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: _isMapView
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'map',
                                        color: _isMapView
                                            ? Colors.white
                                            : AppTheme
                                                .lightTheme.colorScheme.primary,
                                        size: 18,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        'Map',
                                        style: TextStyle(
                                          color: _isMapView
                                              ? Colors.white
                                              : AppTheme.lightTheme.colorScheme
                                                  .primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isMapView = false;
                                  });
                                  HapticFeedback.selectionClick();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: !_isMapView
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'list',
                                        color: !_isMapView
                                            ? Colors.white
                                            : AppTheme
                                                .lightTheme.colorScheme.primary,
                                        size: 18,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        'List',
                                        style: TextStyle(
                                          color: !_isMapView
                                              ? Colors.white
                                              : AppTheme.lightTheme.colorScheme
                                                  .primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Filter button
                        GestureDetector(
                          onTap: _showFilterBottomSheet,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: _selectedSpecialties.isNotEmpty
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomIconWidget(
                              iconName: 'tune',
                              color: _selectedSpecialties.isNotEmpty
                                  ? Colors.white
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: _isMapView
                        ? HospitalMapWidget(
                            userLocation: _userLocation,
                            hospitals: _filteredHospitals,
                            onHospitalTap: _onHospitalTap,
                          )
                        : _filteredHospitals.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'search_off',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 64,
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'No hospitals found',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'Try adjusting your filters',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                                itemCount: _filteredHospitals.length,
                                itemBuilder: (context, index) {
                                  final hospital = _filteredHospitals[index];
                                  return HospitalCardWidget(
                                    hospital: hospital,
                                    onCall: () => _makePhoneCall(
                                        hospital['phone'] as String),
                                    onNavigate: () =>
                                        _navigateToHospital(hospital),
                                    onShareLocation: () =>
                                        _shareLocation(hospital),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
    );
  }
}
