import 'package:flutter/material.dart';
import '../presentation/emergency_hospital_finder/emergency_hospital_finder.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/health_records/health_records.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/login_screen/login_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String emergencyHospitalFinder = '/emergency-hospital-finder';
  static const String splash = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String healthRecords = '/health-records';
  static const String userProfile = '/user-profile';
  static const String login = '/login-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    emergencyHospitalFinder: (context) => const EmergencyHospitalFinder(),
    splash: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    healthRecords: (context) => const HealthRecords(),
    userProfile: (context) => const UserProfile(),
    login: (context) => const LoginScreen(),
    // TODO: Add your other routes here
  };
}
