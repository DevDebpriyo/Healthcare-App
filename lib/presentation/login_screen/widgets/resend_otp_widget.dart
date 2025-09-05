import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import for HapticFeedback
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ResendOtpWidget extends StatefulWidget {
  final VoidCallback onResend;
  final bool isEnabled;

  const ResendOtpWidget({
    Key? key,
    required this.onResend,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<ResendOtpWidget> createState() => _ResendOtpWidgetState();
}

class _ResendOtpWidgetState extends State<ResendOtpWidget> {
  Timer? _timer;
  int _countdown = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 30;
      _canResend = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          timer.cancel();
          // Haptic feedback when countdown completes
          HapticFeedback.lightImpact();
        }
      });
    });
  }

  void _handleResend() {
    if (_canResend && widget.isEnabled) {
      widget.onResend();
      _startCountdown();
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Didn\'t receive the code? ',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),
        GestureDetector(
          onTap: _handleResend,
          child: Text(
            _canResend ? 'Resend OTP' : 'Resend in ${_countdown}s',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: _canResend && widget.isEnabled
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
              decoration: _canResend && widget.isEnabled
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}