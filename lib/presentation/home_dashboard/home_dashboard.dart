import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/emergency_sos_button.dart';
import './widgets/greeting_header.dart';
import './widgets/health_summary_card.dart';
import './widgets/quick_action_tile.dart';
import './widgets/recent_activity_item.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentIndex = 0;
  bool _isRefreshing = false;

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Manju Devi",
    "age": 34,
    "bloodGroup": "O+",
    "abhaId": "12-3456-7890-1234",
  };

  // Mock health summary data
  final Map<String, dynamic> healthSummaryData = {
    "upcomingAppointments": 3,
    "lastBP": "120/80",
    "activeMedications": 2,
    "currentWeight": 65.5,
    "medicationReminders": [
      {"name": "Vitamin D3", "time": "09:00 AM", "dosage": "1 tablet"},
      {"name": "Omega-3", "time": "07:00 PM", "dosage": "2 capsules"}
    ]
  };

  // Mock recent activities data
  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "type": "appointment",
      "title": "Cardiology Consultation",
      "description": "Dr. Rajesh Kumar - Apollo Hospital",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "status": "Completed"
    },
    {
      "id": 2,
      "type": "lab_result",
      "title": "Blood Test Results",
      "description": "Complete Blood Count - All parameters normal",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "status": "Available"
    },
    {
      "id": 3,
      "type": "prescription",
      "title": "New Prescription",
      "description": "Hypertension medication - 30 days supply",
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "status": "Active"
    },
    {
      "id": 4,
      "type": "medication",
      "title": "Medication Reminder",
      "description": "Took morning dose of Lisinopril",
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "status": "Completed"
    },
    {
      "id": 5,
      "type": "appointment",
      "title": "Dental Checkup",
      "description": "Dr. Meera Patel - Smile Dental Clinic",
      "timestamp": DateTime.now().subtract(Duration(days: 5)),
      "status": "Cancelled"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Header
                GreetingHeader(userName: userData["name"] as String),

                // Emergency SOS Button
                EmergencySosButton(
                  onPressed: _handleEmergencyPress,
                ),

                // Health Summary Card
                HealthSummaryCard(healthData: healthSummaryData),

                SizedBox(height: 3.h),

                // Quick Action Tiles
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    'Quick Actions',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.w,
                    mainAxisSpacing: 2.h,
                    childAspectRatio: 1.1,
                    children: [
                      QuickActionTile(
                        title: 'Find Hospitals',
                        iconName: 'local_hospital',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        onTap: () => _navigateToHospitals(),
                        onLongPress: () => _showHospitalShortcuts(),
                      ),
                      QuickActionTile(
                        title: 'Book Appointment',
                        iconName: 'event',
                        badge: '3',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        onTap: () => _navigateToAppointments(),
                        onLongPress: () => _showAppointmentShortcuts(),
                      ),
                      QuickActionTile(
                        title: 'Health Records',
                        iconName: 'folder',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        onTap: () => _navigateToHealthRecords(),
                        onLongPress: () => _showRecordShortcuts(),
                      ),
                      QuickActionTile(
                        title: 'Emergency Contacts',
                        iconName: 'contact_phone',
                        color: Colors.purple,
                        onTap: () => _navigateToEmergencyContacts(),
                        onLongPress: () => _showContactShortcuts(),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Recent Activity Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _viewAllActivities(),
                        child: Text(
                          'View All',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 1.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recentActivities.length > 3
                        ? 3
                        : recentActivities.length,
                    itemBuilder: (context, index) {
                      return RecentActivityItem(
                        activity: recentActivities[index],
                      );
                    },
                  ),
                ),

                SizedBox(height: 10.h), // Bottom padding for navigation bar
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        elevation: 8.0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'local_hospital',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Hospitals',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'event',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'folder',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate data refresh
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Health data synced successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleEmergencyPress() {
    Navigator.pushNamed(context, '/emergency-hospital-finder');
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        _navigateToHospitals();
        break;
      case 2:
        _navigateToAppointments();
        break;
      case 3:
        _navigateToHealthRecords();
        break;
      case 4:
        _navigateToProfile();
        break;
    }
  }

  void _navigateToHospitals() {
    // Navigate to hospitals screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigating to Hospitals...')),
    );
  }

  void _navigateToAppointments() {
    // Navigate to appointments screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigating to Appointments...')),
    );
  }

  void _navigateToHealthRecords() {
    Navigator.pushNamed(context, '/health-records');
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/user-profile');
  }

  void _navigateToEmergencyContacts() {
    // Navigate to emergency contacts screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigating to Emergency Contacts...')),
    );
  }

  void _viewAllActivities() {
    // Navigate to all activities screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing all activities...')),
    );
  }

  void _showHospitalShortcuts() {
    _showQuickActionsBottomSheet(
      'Hospital Shortcuts',
      [
        {'title': 'Apollo Hospital', 'subtitle': '2.3 km away'},
        {'title': 'Max Healthcare', 'subtitle': '3.1 km away'},
        {'title': 'Fortis Hospital', 'subtitle': '4.5 km away'},
      ],
    );
  }

  void _showAppointmentShortcuts() {
    _showQuickActionsBottomSheet(
      'Quick Appointments',
      [
        {
          'title': 'Dr. Rajesh Kumar',
          'subtitle': 'Cardiologist - Tomorrow 10:00 AM'
        },
        {'title': 'Dr. Meera Patel', 'subtitle': 'Dentist - Available today'},
        {'title': 'Dr. Amit Singh', 'subtitle': 'General Physician - Online'},
      ],
    );
  }

  void _showRecordShortcuts() {
    _showQuickActionsBottomSheet(
      'Recent Records',
      [
        {'title': 'Blood Test Report', 'subtitle': 'Downloaded yesterday'},
        {'title': 'X-Ray Chest', 'subtitle': '3 days ago'},
        {'title': 'Prescription', 'subtitle': 'Last week'},
      ],
    );
  }

  void _showContactShortcuts() {
    _showQuickActionsBottomSheet(
      'Emergency Contacts',
      [
        {'title': 'Ambulance', 'subtitle': '108 - National Emergency'},
        {'title': 'Dr. Rajesh Kumar', 'subtitle': '+91 98765 43210'},
        {'title': 'Family Doctor', 'subtitle': '+91 87654 32109'},
      ],
    );
  }

  void _showQuickActionsBottomSheet(
      String title, List<Map<String, String>> items) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              ...items
                  .map((item) => ListTile(
                        title: Text(item['title']!),
                        subtitle: Text(item['subtitle']!),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Selected: ${item['title']}')),
                          );
                        },
                      ))
                  .toList(),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }
}
