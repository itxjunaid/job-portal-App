import 'package:flutter/material.dart';
import 'package:job/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job/user/login_Screen.dart';
import 'package:job/user/verification_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late double height, width;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.07),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.05),
                Hero(
                  tag: 'app-logo',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Jobify',
                      style: TextStyle(
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),

                // Header
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: height * 0.03,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  'Fill your information below or register\nwith your social account',
                  style: TextStyle(
                    fontSize: height * 0.014,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: height * 0.03),

                // Name Field
                _buildInputField(
                  label: 'Full Name',
                  hint: 'John Doe',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  prefixIcon: Icons.person_outline,
                ),
                SizedBox(height: height * 0.025),

                // Email Field
                _buildInputField(
                  label: 'Email Address',
                  hint: 'example@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  prefixIcon: Icons.email_outlined,
                ),
                SizedBox(height: height * 0.025),

                // Phone Field
                _buildInputField(
                  label: 'Phone Number',
                  hint: '+1 234 567 890',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  prefixIcon: Icons.phone_outlined,
                ),
                SizedBox(height: height * 0.025),

                // Password Field
                _buildInputField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                SizedBox(height: height * 0.03),

                // Sign Up Button
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
                                // Simulate login
                                Future.delayed(const Duration(seconds: 2), () {
                                  if (mounted) {
                                    setState(() => _isLoading = false);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => VerificationScreen(),
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
                              'Signup',
                              style: TextStyle(
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: height * 0.04),

                // Or Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.borderColor)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: Text(
                        'Or with',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: height * 0.016,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.borderColor)),
                  ],
                ),
                SizedBox(height: height * 0.03),

                // Social Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      iconPath: 'assets/google-icon-logo-svgrepo-com.svg',
                      color: AppColors.googleRed,
                      onPressed: () {},
                    ),
                    SizedBox(width: width * 0.05),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(height * 0.01),
                      child: Container(
                        width: width * 0.18,
                        height: height * 0.065,
                        decoration: BoxDecoration(
                          color: AppColors.facebookBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(height * 0.01),
                          border: Border.all(
                            color: AppColors.facebookBlue.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.facebook,
                            size: 50,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.04),

                // Already have account
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: height * 0.016,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: TextStyle(
              fontSize: height * 0.016,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              labelStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: height * 0.016,
              ),
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: height * 0.016,
              ),
              prefixIcon:
                  prefixIcon != null
                      ? Icon(prefixIcon, color: AppColors.textSecondary)
                      : null,
              suffixIcon: suffixIcon,
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
      ],
    );
  }

  Widget _buildSocialButton({
    required String iconPath,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(height * 0.01),
      child: Container(
        width: width * 0.18,
        height: height * 0.065,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(height * 0.01),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        ),
        child: Center(child: SvgPicture.asset(iconPath, width: height * 0.03)),
      ),
    );
  }
}
