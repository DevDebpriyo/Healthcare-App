import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AbhaIntegrationWidget extends StatelessWidget {
  final Map<String, dynamic> abhaData;
  final VoidCallback onSync;
  final VoidCallback onLink;

  const AbhaIntegrationWidget({
    Key? key,
    required this.abhaData,
    required this.onSync,
    required this.onLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLinked = abhaData['isLinked'] ?? false;
    final String lastSync = abhaData['lastSync'] ?? '';

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
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isLinked
                      ? AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: CustomIconWidget(
                  iconName: 'account_balance',
                  color: isLinked
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : AppTheme.lightTheme.primaryColor,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ABHA Integration',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Container(
                          width: 2.w,
                          height: 2.w,
                          decoration: BoxDecoration(
                            color: isLinked
                                ? AppTheme.lightTheme.colorScheme.secondary
                                : Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          isLinked ? 'Linked & Active' : 'Not Linked',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isLinked
                                ? AppTheme.lightTheme.colorScheme.secondary
                                : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          if (isLinked) ...[
            _buildInfoRow(
              'ABHA ID',
              abhaData['abhaId'] ?? 'Not available',
              Icons.badge,
            ),
            SizedBox(height: 2.h),
            _buildInfoRow(
              'Health ID',
              abhaData['healthId'] ?? 'Not available',
              Icons.medical_information,
            ),
            SizedBox(height: 2.h),
            _buildInfoRow(
              'Last Sync',
              lastSync.isEmpty ? 'Never synced' : lastSync,
              Icons.sync,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSync,
                    icon: CustomIconWidget(
                      iconName: 'sync',
                      color: Colors.white,
                      size: 4.w,
                    ),
                    label: Text(
                      'Sync Records',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'link_off',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 12.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Link your ABHA ID',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Connect your Ayushman Bharat Health Account to sync your health records and access government healthcare services.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 3.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onLink,
                      icon: CustomIconWidget(
                        iconName: 'link',
                        color: Colors.white,
                        size: 4.w,
                      ),
                      label: Text(
                        'Link ABHA ID',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon.codePoint.toString(),
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 4.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
