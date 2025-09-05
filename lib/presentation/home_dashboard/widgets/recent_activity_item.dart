import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityItem extends StatelessWidget {
  final Map<String, dynamic> activity;

  const RecentActivityItem({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: _getActivityColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _getActivityIcon(),
                color: _getActivityColor(),
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity["title"] as String,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  activity["description"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatDateTime(activity["timestamp"] as DateTime),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          if (activity["status"] != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getStatusColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                activity["status"] as String,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getActivityColor() {
    switch (activity["type"] as String) {
      case 'appointment':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'prescription':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'lab_result':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'medication':
        return Colors.purple;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getActivityIcon() {
    switch (activity["type"] as String) {
      case 'appointment':
        return 'event';
      case 'prescription':
        return 'receipt';
      case 'lab_result':
        return 'science';
      case 'medication':
        return 'medication';
      default:
        return 'info';
    }
  }

  Color _getStatusColor() {
    switch (activity["status"] as String?) {
      case 'Completed':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'Pending':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'Cancelled':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
