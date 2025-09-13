import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/abha_integration_widget.dart';
import './widgets/emergency_contacts_widget.dart';
import './widgets/medical_info_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_info_section_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ImagePicker _imagePicker = ImagePicker();

  // Edit states
  bool _isEditingProfile = false;
  bool _isEditingContacts = false;
  bool _isEditingMedical = false;

  // Mock user data
  Map<String, dynamic> _profileData = {
    'fullName': 'Manju Devi',
    'age': 32,
    'gender': 'Female',
    'bloodGroup': 'O+',
    'mobile': '+91 98765 43210',
    'profileImage':
        'https://imgs.search.brave.com/iWiQrVwhoG6cpWdSSzYCkXH1Q_xuEEDpqD-d8wBfceU/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvMTMx/NDM4MTg4MS9waG90/by9pbmRpYW4td29t/YW4tc2hvd2luZy1t/b2JpbGUtcGhvbmUu/anBnP3M9NjEyeDYx/MiZ3PTAmaz0yMCZj/PVdCbVFnTmFtcHE1/c2wxVUxpaHQ5Q256/NGNyWnoxMXMyX2xn/ekpXQWwwc1k9',
  };

  List<Map<String, dynamic>> _emergencyContacts = [
    {
      'type': 'Primary',
      'name': 'Rajesh Sharma',
      'phone': '+91 98765 43211',
      'relationship': 'Husband',
    },
    {
      'type': 'Secondary',
      'name': 'Meera Sharma',
      'phone': '+91 98765 43212',
      'relationship': 'Mother',
    },
  ];

  Map<String, dynamic> _medicalData = {
    'allergies': 'Penicillin, Shellfish',
    'chronicConditions': 'Hypertension, Diabetes Type 2',
    'currentMedications':
        'Metformin 500mg twice daily, Lisinopril 10mg once daily',
    'insuranceDetails':
        'Star Health Insurance - Policy No: SH123456789, Valid till: Dec 2024',
  };

  Map<String, dynamic> _abhaData = {
    'isLinked': true,
    'abhaId': '12-3456-7890-1234',
    'healthId': 'manju.devi@abha',
    'lastSync': '04 Sep 2025, 07:30 AM',
  };

  Map<String, dynamic> _settingsData = {
    'language': 'English',
    'darkMode': false,
    'appointmentReminders': true,
    'healthAlerts': true,
    'emergencyNotifications': true,
    'shareDataWithDoctors': true,
    'anonymousAnalytics': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderWidget(
              userName: _profileData['fullName'] ?? 'User',
              abhaId: _abhaData['abhaId'] ?? 'Not Linked',
              profileImageUrl: _profileData['profileImage'],
              onImageTap: _handleImageUpdate,
            ),
            ProfileInfoSectionWidget(
              profileData: _profileData,
              isEditing: _isEditingProfile,
              onEditToggle: _toggleProfileEdit,
              onFieldChanged: _updateProfileField,
            ),
            EmergencyContactsWidget(
              emergencyContacts: _emergencyContacts,
              isEditing: _isEditingContacts,
              onEditToggle: _toggleContactsEdit,
              onContactChanged: _updateEmergencyContact,
            ),
            MedicalInfoWidget(
              medicalData: _medicalData,
              isEditing: _isEditingMedical,
              onEditToggle: _toggleMedicalEdit,
              onFieldChanged: _updateMedicalField,
            ),
            AbhaIntegrationWidget(
              abhaData: _abhaData,
              onSync: _syncAbhaRecords,
              onLink: _linkAbhaId,
            ),
            SettingsSectionWidget(
              settingsData: _settingsData,
              onSettingChanged: _updateSetting,
              onLogout: _handleLogout,
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  void _handleImageUpdate() async {
    try {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
        ),
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Update Profile Photo',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageOption(
                      'Camera',
                      Icons.camera_alt,
                      () => _pickImage(ImageSource.camera),
                    ),
                    _buildImageOption(
                      'Gallery',
                      Icons.photo_library,
                      () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
              ],
            ),
          );
        },
      );
    } catch (e) {
      _showToast('Unable to update photo at the moment');
    }
  }

  Widget _buildImageOption(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon.codePoint.toString(),
              color: AppTheme.lightTheme.primaryColor,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      Navigator.pop(context);
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _profileData['profileImage'] = image.path;
        });
        _showToast('Profile photo updated successfully');
      }
    } catch (e) {
      _showToast('Failed to update profile photo');
    }
  }

  void _toggleProfileEdit() {
    setState(() {
      _isEditingProfile = !_isEditingProfile;
    });
    if (!_isEditingProfile) {
      _showToast('Profile information saved');
    }
  }

  void _toggleContactsEdit() {
    setState(() {
      _isEditingContacts = !_isEditingContacts;
    });
    if (!_isEditingContacts) {
      _showToast('Emergency contacts saved');
    }
  }

  void _toggleMedicalEdit() {
    setState(() {
      _isEditingMedical = !_isEditingMedical;
    });
    if (!_isEditingMedical) {
      _showToast('Medical information saved');
    }
  }

  void _updateProfileField(String field, String value) {
    setState(() {
      if (field == 'age') {
        _profileData[field] = int.tryParse(value) ?? _profileData[field];
      } else {
        _profileData[field] = value;
      }
    });
  }

  void _updateEmergencyContact(int index, String field, String value) {
    if (index < _emergencyContacts.length) {
      setState(() {
        _emergencyContacts[index][field] = value;
      });
    }
  }

  void _updateMedicalField(String field, String value) {
    setState(() {
      _medicalData[field] = value;
    });
  }

  void _updateSetting(String key, dynamic value) {
    setState(() {
      _settingsData[key] = value;
    });
    _showToast('Setting updated');
  }

  void _syncAbhaRecords() {
    setState(() {
      _abhaData['lastSync'] =
          '04 Sep 2025, ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}';
    });
    _showToast('ABHA records synced successfully');
  }

  void _linkAbhaId() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          title: Text(
            'Link ABHA ID',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'You will be redirected to the official ABHA portal to link your health account. This will enable seamless access to your health records across all healthcare providers.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _abhaData['isLinked'] = true;
                  _abhaData['abhaId'] = '12-3456-7890-1234';
                  _abhaData['healthId'] = 'manju.devi@abha';
                  _abhaData['lastSync'] = 'Just now';
                });
                _showToast('ABHA ID linked successfully');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: Text(
                'Continue',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          title: Text(
            'Logout',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to logout? You will need to login again to access your health records.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login-screen',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: Text(
                'Logout',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      textColor: AppTheme.lightTheme.colorScheme.onSurface,
      fontSize: 14.sp,
    );
  }
}
