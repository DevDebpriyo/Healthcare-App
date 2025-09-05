import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class EmergencyContactsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> emergencyContacts;
  final bool isEditing;
  final VoidCallback onEditToggle;
  final Function(int, String, String) onContactChanged;

  const EmergencyContactsWidget({
    Key? key,
    required this.emergencyContacts,
    required this.isEditing,
    required this.onEditToggle,
    required this.onContactChanged,
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
                'Emergency Contacts',
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
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: emergencyContacts.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final contact = emergencyContacts[index];
              return _buildContactCard(context, contact, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
      BuildContext context, Map<String, dynamic> contact, int index) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: contact['type'] == 'Primary'
                      ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: contact['type'] == 'Primary' ? 'star' : 'person',
                  color: contact['type'] == 'Primary'
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.secondary,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${contact['type']} Contact',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    isEditing
                        ? TextFormField(
                            initialValue: contact['name'] ?? '',
                            onChanged: (value) =>
                                onContactChanged(index, 'name', value),
                            decoration: InputDecoration(
                              hintText: 'Contact Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.w),
                                borderSide: BorderSide(
                                  color: AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 1.h),
                              isDense: true,
                            ),
                            style: AppTheme.lightTheme.textTheme.bodyLarge,
                          )
                        : Text(
                            contact['name'] ?? 'Not provided',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ],
                ),
              ),
              if (!isEditing)
                GestureDetector(
                  onTap: () => _makePhoneCall(contact['phone'] ?? ''),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: CustomIconWidget(
                      iconName: 'call',
                      color: Colors.white,
                      size: 4.w,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: isEditing
                    ? TextFormField(
                        initialValue: contact['phone'] ?? '',
                        onChanged: (value) =>
                            onContactChanged(index, 'phone', value),
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1.w),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
                          isDense: true,
                        ),
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                        keyboardType: TextInputType.phone,
                      )
                    : Text(
                        contact['phone'] ?? 'Not provided',
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'family_restroom',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: isEditing
                    ? TextFormField(
                        initialValue: contact['relationship'] ?? '',
                        onChanged: (value) =>
                            onContactChanged(index, 'relationship', value),
                        decoration: InputDecoration(
                          hintText: 'Relationship',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1.w),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
                          isDense: true,
                        ),
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      )
                    : Text(
                        contact['relationship'] ?? 'Not specified',
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;

    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      // Handle error silently
    }
  }
}
