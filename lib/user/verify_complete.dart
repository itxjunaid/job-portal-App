import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job/constants/app_colors.dart';
import 'package:job/user/login_Screen.dart';
import 'package:pinput/pinput.dart';

class CompleteVerification extends StatefulWidget {
  final String contact;
  final bool isPhone;

  const CompleteVerification({
    super.key,
    required this.contact,
    required this.isPhone,
  });

  @override
  State<CompleteVerification> createState() => _CompleteVerificationState();
}

class _CompleteVerificationState extends State<CompleteVerification> {
  late double height, width;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: width * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),
            Text(
              'Verification',
              style: TextStyle(
                fontSize: height * 0.035,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: height * 0.01),
            Text(
              'Code sent to ${widget.contact}',
              style: TextStyle(
                fontSize: height * 0.016,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: height * 0.05),

            // Verification Code
            Center(
              child: Pinput(
                length: 6,
                controller: _codeController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length != 6) {
                    return 'Please enter 6-digit code';
                  }
                  return null;
                },
                onCompleted: (pin) {},
                showCursor: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(height: height * 0.04),

            // Resend Code
            Center(
              child: TextButton(
                onPressed: () {
                  // Resend code logic
                },
                child: Text(
                  'Resend Code',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: height * 0.016,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.05),

            // New Password
            SizedBox(height: height * 0.05),

            // Reset Password Button
            Container(
              width: double.infinity,
              height: height * 0.065,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    _isLoading
                        ? null
                        : () {
                          // First check if PIN is complete (6 digits)
                          if (_codeController.text.length != 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please enter the complete 6-digit code',
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }

                          // Only navigate to next screen if PIN is complete
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                child:
                    _isLoading
                        ? SizedBox(
                          width: height * 0.025,
                          height: height * 0.025,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                        : Text(
                          'Verify Code',
                          style: TextStyle(
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
