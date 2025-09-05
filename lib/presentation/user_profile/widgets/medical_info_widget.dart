import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicalInfoWidget extends StatelessWidget {
  final Map<String, dynamic> medicalData;
  final bool isEditing;
  final VoidCallback onEditToggle;
  final Function(String, String) onFieldChanged;

  const MedicalInfoWidget({
    Key? key,
    required this.medicalData,
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
                'Medical Information',
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
          _buildExpandableCard(
            'Allergies',
            'allergies',
            Icons.warning,
            medicalData['allergies'] ?? '',
            'List any known allergies...',
          ),
          SizedBox(height: 2.h),
          _buildExpandableCard(
            'Chronic Conditions',
            'chronicConditions',
            Icons.medical_services,
            medicalData['chronicConditions'] ?? '',
            'List any chronic medical conditions...',
          ),
          SizedBox(height: 2.h),
          _buildExpandableCard(
            'Current Medications',
            'currentMedications',
            Icons.medication,
            medicalData['currentMedications'] ?? '',
            'List current medications and dosages...',
          ),
          SizedBox(height: 2.h),
          _buildExpandableCard(
            'Insurance Details',
            'insuranceDetails',
            Icons.security,
            medicalData['insuranceDetails'] ?? '',
            'Insurance provider and policy details...',
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableCard(
    String title,
    String fieldKey,
    IconData icon,
    String value,
    String hint,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: CustomIconWidget(
            iconName: icon.codePoint.toString(),
            color: AppTheme.lightTheme.primaryColor,
            size: 5.w,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: value.isEmpty
            ? Text(
                'Not provided',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              )
            : Text(
                value.length > 50 ? '${value.substring(0, 50)}...' : value,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (value.isNotEmpty && !isEditing)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Text(
                      value,
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                  ),
                if (isEditing)
                  TextFormField(
                    initialValue: value,
                    onChanged: (newValue) => onFieldChanged(fieldKey, newValue),
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: hint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.w),
                        borderSide: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(3.w),
                    ),
                    style: AppTheme.lightTheme.textTheme.bodyLarge,
                  ),
                if (value.isEmpty && !isEditing)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Text(
                      'No information provided',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
