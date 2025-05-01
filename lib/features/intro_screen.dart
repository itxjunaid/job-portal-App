import 'package:flutter/material.dart';
import 'package:job/constants/app_colors.dart';
import 'package:job/user/signup_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late double height, width;
  late double defaultPadding;
  late double iconSize;
  late double titleFontSize;
  late double descriptionFontSize;
  late double buttonFontSize;
  late double logoFontSize;
  late double cardElevation;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // Responsive sizing calculations
    defaultPadding = height * 0.025;
    iconSize = height * 0.05;
    titleFontSize = height * 0.022;
    descriptionFontSize = height * 0.018;
    buttonFontSize = height * 0.02;
    logoFontSize = height * 0.04;
    cardElevation = height * 0.005;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              // Header with responsive logo
              Hero(
                tag: 'app-logo',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    'Jobify',
                    style: TextStyle(
                      fontSize: logoFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: width * 0.002,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.025),

              // Company Intro Cards
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildIntroCard(
                        icon: Icons.work_outline,
                        title: 'Thousands of Jobs',
                        description:
                            'Access to thousands of job opportunities from top companies worldwide',
                      ),
                      SizedBox(height: height * 0.02),
                      _buildIntroCard(
                        icon: Icons.verified_user_outlined,
                        title: 'Verified Employers',
                        description:
                            'All companies are thoroughly vetted to ensure job authenticity',
                      ),
                      SizedBox(height: height * 0.02),
                      _buildIntroCard(
                        icon: Icons.track_changes_outlined,
                        title: 'Track Applications',
                        description:
                            'Easily track all your job applications in one place',
                      ),
                    ],
                  ),
                ),
              ),

              // Responsive Get Started Button
              SizedBox(
                width: width * 0.9,
                height: height * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: height * 0.005,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(height * 0.015),
                    ),
                    shadowColor: AppColors.primary.withOpacity(0.3),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Let\'s Get Started',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(height * 0.015),
      ),
      margin: EdgeInsets.symmetric(vertical: height * 0.005),
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(height * 0.008),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: iconSize, color: AppColors.primary),
            ),
            SizedBox(width: width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  SizedBox(height: height * 0.008),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      color: AppColors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
