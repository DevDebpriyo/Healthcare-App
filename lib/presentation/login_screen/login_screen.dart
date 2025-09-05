import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/abha_link_widget.dart';
import './widgets/emergency_bypass_widget.dart';
import './widgets/mobile_input_widget.dart';
import './widgets/otp_input_widget.dart';
import './widgets/resend_otp_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _isMobileValid = false;
  String _enteredOtp = '';

  // Mock credentials for authentication
  final String _mockMobile = '9876543210';
  final String _mockOtp = '123456';

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _onMobileChanged(String value) {
    setState(() {
      _isMobileValid =
          value.length == 10 && RegExp(r'^[6-9][0-9]{9}$').hasMatch(value);
    });
  }

  Future<void> _sendOtp() async {
    if (!_isMobileValid) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate OTP sending delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isOtpSent = true;
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP sent to +91 ${_mobileController.text}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length != 6) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate OTP verification delay
    await Future.delayed(Duration(seconds: 2));

    // Check mock credentials
    if (_mobileController.text == _mockMobile && _enteredOtp == _mockOtp) {
      HapticFeedback.lightImpact();
      Navigator.pushNamedAndRemoveUntil(
          context, '/home-dashboard', (route) => false);
    } else {
      setState(() {
        _isLoading = false;
      });

      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid OTP. Please try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );
    }
  }

  void _onOtpCompleted(String otp) {
    setState(() {
      _enteredOtp = otp;
    });
    _verifyOtp();
  }

  void _resendOtp() {
    setState(() {
      _enteredOtp = '';
    });
    _sendOtp();
  }

  void _handleEmergencyAccess() {
    HapticFeedback.heavyImpact();
    Navigator.pushNamed(context, '/emergency-hospital-finder');
  }

  void _handleAbhaLink() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ABHA ID linking will be available soon'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void _handleBackPress() {
    if (_isOtpSent) {
      setState(() {
        _isOtpSent = false;
        _enteredOtp = '';
      });
    } else {
      Navigator.pushReplacementNamed(context, '/splash-screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),

                      // Back button
                      GestureDetector(
                        onTap: _handleBackPress,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // App logo (smaller)
                      Center(
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.3),
                                blurRadius: 20.0,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CustomIconWidget(
                            iconName: 'local_hospital',
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Welcome text
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Welcome to HealthCare Plus',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              _isOtpSent
                                  ? 'Verify your mobile number'
                                  : 'Sign in to access your health records',
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // Mobile input or OTP input
                      !_isOtpSent
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mobile Number',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                MobileInputWidget(
                                  controller: _mobileController,
                                  onChanged: _onMobileChanged,
                                  isEnabled: !_isLoading,
                                ),
                              ],
                            )
                          : OtpInputWidget(
                              onCompleted: _onOtpCompleted,
                              isEnabled: !_isLoading,
                            ),

                      SizedBox(height: 4.h),

                      // Send OTP or Verify button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : _isOtpSent
                                  ? (_enteredOtp.length == 6
                                      ? _verifyOtp
                                      : null)
                                  : (_isMobileValid ? _sendOtp : null),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  _isOtpSent ? 'Verify OTP' : 'Send OTP',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelLarge
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      // Resend OTP widget (only shown after OTP is sent)
                      _isOtpSent ? SizedBox(height: 3.h) : SizedBox.shrink(),
                      _isOtpSent
                          ? ResendOtpWidget(
                              onResend: _resendOtp,
                              isEnabled: !_isLoading,
                            )
                          : SizedBox.shrink(),

                      SizedBox(height: 6.h),

                      // ABHA ID linking (only shown after OTP is sent)
                      _isOtpSent
                          ? AbhaLinkWidget(
                              onAbhaLink: _handleAbhaLink,
                            )
                          : SizedBox.shrink(),

                      SizedBox(height: 4.h),

                      // Terms and privacy
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                            children: [
                              TextSpan(
                                  text: 'By continuing, you agree to our '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Emergency bypass button
          EmergencyBypassWidget(
            onEmergencyAccess: _handleEmergencyAccess,
          ),
        ],
      ),
    );
  }
}
