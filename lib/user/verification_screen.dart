import 'package:flutter/material.dart';
import 'package:job/constants/app_colors.dart';
import 'package:job/user/reset_pass_screen.dart';
import 'package:job/user/verify_complete.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late double height, width;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  bool _usePhone = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

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
              'Enter your ${_usePhone ? 'phone number' : 'email'} for verification',
              style: TextStyle(
                fontSize: height * 0.016,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: height * 0.05),

            // Toggle between email/phone
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text('Email'),
                  selected: !_usePhone,
                  onSelected: (selected) {
                    setState(() => _usePhone = !selected);
                  },
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: !_usePhone ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: width * 0.05),
                ChoiceChip(
                  label: Text('Phone'),
                  selected: _usePhone,
                  onSelected: (selected) {
                    setState(() => _usePhone = selected);
                  },
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: _usePhone ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.04),

            // Email/Phone Input
            Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType:
                      _usePhone
                          ? TextInputType.phone
                          : TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ${_usePhone ? 'phone number' : 'email'}';
                    }
                    if (!_usePhone &&
                        !RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: _usePhone ? 'Phone Number' : 'Email Address',
                    labelStyle: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: height * 0.016,
                    ),
                    prefixIcon: Icon(
                      _usePhone ? Icons.phone : Icons.email_outlined,
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: height * 0.02,
                      horizontal: width * 0.04,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.05),

            // Send Code Button
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
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            // Simulate sending code
                            Future.delayed(const Duration(seconds: 1), () {
                              if (mounted) {
                                setState(() => _isLoading = false);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => CompleteVerification(
                                          contact: _emailController.text,
                                          isPhone: _usePhone,
                                        ),
                                  ),
                                );
                              }
                            });
                          }
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
                          'Send Code',
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
