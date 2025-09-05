import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final List<String> selectedSpecialties;
  final String selectedSortOption;
  final Function(List<String>, String) onFiltersApplied;

  const FilterBottomSheetWidget({
    Key? key,
    required this.selectedSpecialties,
    required this.selectedSortOption,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late List<String> _selectedSpecialties;
  late String _selectedSortOption;

  final List<String> _availableSpecialties = [
    'Emergency',
    'Cardiology',
    'Orthopedic',
    'General',
    'Neurology',
    'Pediatrics',
    'Gynecology',
    'Dermatology',
  ];

  final List<String> _sortOptions = [
    'Distance',
    'Availability',
    'Rating',
  ];

  @override
  void initState() {
    super.initState();
    _selectedSpecialties = List.from(widget.selectedSpecialties);
    _selectedSortOption = widget.selectedSortOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
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

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filter & Sort',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedSpecialties.clear();
                      _selectedSortOption = 'Distance';
                    });
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Specialties section
                  Text(
                    'Medical Specialties',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _availableSpecialties.map((specialty) {
                      final bool isSelected =
                          _selectedSpecialties.contains(specialty);
                      return FilterChip(
                        label: Text(specialty),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedSpecialties.add(specialty);
                            } else {
                              _selectedSpecialties.remove(specialty);
                            }
                          });
                        },
                        selectedColor: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 3.h),

                  // Sort section
                  Text(
                    'Sort By',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Column(
                    children: _sortOptions.map((option) {
                      return RadioListTile<String>(
                        title: Text(
                          option,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        value: option,
                        groupValue: _selectedSortOption,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _selectedSortOption = value;
                            });
                          }
                        },
                        activeColor: AppTheme.lightTheme.colorScheme.primary,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFiltersApplied(
                          _selectedSpecialties, _selectedSortOption);
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
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
