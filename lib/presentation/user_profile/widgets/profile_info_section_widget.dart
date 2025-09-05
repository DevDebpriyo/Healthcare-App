import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileInfoSectionWidget extends StatelessWidget {
  final Map<String, dynamic> profileData;
  final bool isEditing;
  final VoidCallback onEditToggle;
  final Function(String, String) onFieldChanged;

  const ProfileInfoSectionWidget({
    Key? key,
    required this.profileData,
    required this.isEditing,
    required this.onEditToggle,
    required this.onFieldChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal Information',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onEditToggle,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isEditing
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: isEditing ? 'save' : 'edit',
                        color: Colors.white,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        isEditing ? 'Save' : 'Edit',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildInfoField(
            'Full Name',
            profileData['fullName'] ?? '',
            'fullName',
            Icons.person,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildInfoField(
                  'Age',
                  profileData['age']?.toString() ?? '',
                  'age',
                  Icons.cake,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildDropdownField(
                  'Gender',
                  profileData['gender'] ?? '',
                  'gender',
                  Icons.wc,
                  ['Male', 'Female', 'Other'],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  'Blood Group',
                  profileData['bloodGroup'] ?? '',
                  'bloodGroup',
                  Icons.bloodtype,
                  ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildInfoField(
                  'Mobile',
                  profileData['mobile'] ?? '',
                  'mobile',
                  Icons.phone,
                  readOnly: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(
    String label,
    String value,
    String fieldKey,
    IconData icon, {
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: isEditing && !readOnly
                ? AppTheme.lightTheme.colorScheme.surface
                : AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: icon.codePoint.toString(),
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: isEditing && !readOnly
                    ? TextFormField(
                        initialValue: value,
                        onChanged: (newValue) =>
                            onFieldChanged(fieldKey, newValue),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      )
                    : Text(
                        value.isEmpty ? 'Not provided' : value,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: value.isEmpty
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              : AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
              ),
              if (readOnly && label == 'Mobile')
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Text(
                    'Verified',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    String fieldKey,
    IconData icon,
    List<String> options,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: isEditing
                ? AppTheme.lightTheme.colorScheme.surface
                : AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: icon.codePoint.toString(),
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: isEditing
                    ? DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: value.isEmpty ? null : value,
                          hint: Text(
                            'Select $label',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          isExpanded: true,
                          items: options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                style: AppTheme.lightTheme.textTheme.bodyLarge,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              onFieldChanged(fieldKey, newValue);
                            }
                          },
                        ),
                      )
                    : Text(
                        value.isEmpty ? 'Not selected' : value,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: value.isEmpty
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              : AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
