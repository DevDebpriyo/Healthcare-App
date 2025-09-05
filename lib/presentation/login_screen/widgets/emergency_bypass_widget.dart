import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyBypassWidget extends StatelessWidget {
  final VoidCallback onEmergencyAccess;

  const EmergencyBypassWidget({
    Key? key,
    required this.onEmergencyAccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 6.h,
      right: 4.w,
      child: SafeArea(
        child: GestureDetector(
          onTap: onEmergencyAccess,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.error,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.3),
                  blurRadius: 8.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'local_hospital',
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Emergency',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
