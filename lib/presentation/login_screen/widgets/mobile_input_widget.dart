import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MobileInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool isEnabled;

  const MobileInputWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<MobileInputWidget> createState() => _MobileInputWidgetState();
}

class _MobileInputWidgetState extends State<MobileInputWidget> {
  bool _hasError = false;
  String _errorMessage = '';

  void _validateMobileNumber(String value) {
    setState(() {
      if (value.isEmpty) {
        _hasError = false;
        _errorMessage = '';
      } else if (value.length != 10 ||
          !RegExp(r'^[6-9][0-9]{9}$').hasMatch(value)) {
        _hasError = true;
        _errorMessage = 'Please enter a valid 10-digit mobile number';
      } else {
        _hasError = false;
        _errorMessage = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: _hasError
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.outline,
              width: _hasError ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.0),
                        child: CustomImageWidget(
                          imageUrl: "https://flagcdn.com/w40/in.png",
                          width: 6.w,
                          height: 4.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '+91',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 1,
                      height: 3.h,
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  enabled: widget.isEnabled,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: widget.isEnabled
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter mobile number',
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  ),
                  onChanged: (value) {
                    _validateMobileNumber(value);
                    widget.onChanged(value);
                  },
                ),
              ),
            ],
          ),
        ),
        _hasError ? SizedBox(height: 1.h) : SizedBox.shrink(),
        _hasError
            ? Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Text(
                  _errorMessage,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
