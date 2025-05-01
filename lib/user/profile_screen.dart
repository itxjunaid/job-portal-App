import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job/constants/app_colors.dart';
import 'package:job/user/resume_upload_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3; // Profile tab selected
  File? _profileImage;
  File? _resumeFile;

  Future<void> _pickAndCropImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(
            ratioX: 1,
            ratioY: 1,
          ), // Square aspect ratio
          compressQuality: 85,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: AppColors.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: 'Crop Image',
              aspectRatioLockEnabled: true,
              aspectRatioPickerButtonHidden: true,
            ),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _profileImage = File(croppedFile.path);
          });
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Image Selection Error'),
              content: Text(
                'Could not select or crop image. Please try again.\nError: ${e.toString()}',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Hero(
          tag: 'app-logo',
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'UK',
                  style: TextStyle(
                    fontSize: height * 0.028,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  'Star',
                  style: TextStyle(
                    fontSize: height * 0.028,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                    letterSpacing: 1.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: height * 0.022,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  'Jobs',
                  style: TextStyle(
                    fontSize: height * 0.028,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Open settings
            },
            icon: Icon(Icons.settings_outlined, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildProfileHeader(height, width),
            _buildProfileMenu(height, width),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(double height, double width) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: height * 0.025),
          // Profile Image
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: height * 0.12,
                height: height * 0.12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(height * 0.12),
                  child:
                      _profileImage != null
                          ? Image.file(_profileImage!, fit: BoxFit.cover)
                          : Image.network(
                            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.blue.shade100,
                                  child: Center(
                                    child: Text(
                                      'MH',
                                      style: TextStyle(
                                        fontSize: height * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(height * 0.003),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: IconButton(
                  onPressed: _pickAndCropImage,
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.white,
                    size: height * 0.018,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.02),

          // Name
          Text(
            'Marian Hart',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: height * 0.005),

          // Job Title
          Text(
            'Director of Project Management',
            style: TextStyle(
              fontSize: height * 0.016,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: height * 0.005),

          // Company
          Text(
            'GoldenPhase Solar',
            style: TextStyle(
              fontSize: height * 0.016,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: height * 0.015),

          // Additional info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.07),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.textSecondary,
                  size: height * 0.016,
                ),
                SizedBox(width: width * 0.01),
                Text(
                  'Syracuse University - New York',
                  style: TextStyle(
                    fontSize: height * 0.014,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.008),

          // Connections
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                color: AppColors.textSecondary,
                size: height * 0.016,
              ),
              SizedBox(width: width * 0.01),
              Text(
                'Greater San Diego Area / 500+ connections',
                style: TextStyle(
                  fontSize: height * 0.014,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.025),

          // Profile completion
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile Completion',
                      style: TextStyle(
                        fontSize: height * 0.014,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '85%',
                      style: TextStyle(
                        fontSize: height * 0.014,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                ClipRRect(
                  borderRadius: BorderRadius.circular(height * 0.004),
                  child: LinearProgressIndicator(
                    value: 0.85,
                    backgroundColor: Colors.grey.shade200,
                    color: AppColors.primary,
                    minHeight: height * 0.008,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.025),

          // Actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.07),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Edit profile
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: height * 0.015),
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: height * 0.016,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.03),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Share profile
                    },
                    icon: Icon(
                      Icons.share_outlined,
                      color: AppColors.primary,
                      size: height * 0.025,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.025),
        ],
      ),
    );
  }

  Widget _buildProfileMenu(double height, double width) {
    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Highlights', height),
          SizedBox(height: height * 0.015),
          _buildHighlightCard(height, width),
          SizedBox(height: height * 0.025),
          _buildSectionTitle('Work Experience', height),
          SizedBox(height: height * 0.015),
          _buildExperienceSection(height, width),
          SizedBox(height: height * 0.025),
          _buildSectionTitle('Skills', height),
          SizedBox(height: height * 0.015),
          _buildSkillsSection(height, width),
          SizedBox(height: height * 0.025),
          _buildSectionTitle('Education', height),
          SizedBox(height: height * 0.015),
          _buildEducationSection(height, width),
          SizedBox(height: height * 0.025),
          _buildSectionTitle('Settings', height),
          SizedBox(height: height * 0.015),
          _buildSettingsMenu(height, width),
          SizedBox(height: height * 0.1),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, double height) {
    return Text(
      title,
      style: TextStyle(
        fontSize: height * 0.022,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildHighlightCard(double height, double width) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Row(
          children: [
            CircleAvatar(
              radius: height * 0.025,
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height * 0.025),
                child: Image.network(
                  'https://logo.clearbit.com/google.com',
                  width: height * 0.04,
                  height: height * 0.04,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(
                        Icons.business,
                        size: height * 0.025,
                        color: AppColors.primary,
                      ),
                ),
              ),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Marian has received Google Certification',
                    style: TextStyle(
                      fontSize: height * 0.015,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    'Google Project Management Certificate',
                    style: TextStyle(
                      fontSize: height * 0.014,
                      color: AppColors.textSecondary,
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

  Widget _buildExperienceSection(double height, double width) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          children: [
            _buildExperienceItem(
              title: 'Project Manager',
              company: 'GoldenPhase Solar',
              duration: 'Full-time • 10 months',
              isActive: true,
              height: height,
              width: width,
            ),
            _buildTimelineDivider(height),
            _buildExperienceItem(
              title: 'Junior Project Manager',
              company: 'GoldenPhase Solar',
              duration: 'Full-time • 1 year 2 months',
              isActive: false,
              height: height,
              width: width,
            ),
            _buildTimelineDivider(height),
            _buildExperienceItem(
              title: 'Project Manager Intern',
              company: 'GoldenPhase Solar',
              duration: 'Internship • 6 months',
              isActive: false,
              isLast: true,
              height: height,
              width: width,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceItem({
    required String title,
    required String company,
    required String duration,
    required bool isActive,
    required double height,
    required double width,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: width * 0.08,
              height: width * 0.08,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.grey.shade200,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  company.substring(0, 1),
                  style: TextStyle(
                    fontSize: height * 0.016,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 1,
                height: height * 0.05,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        SizedBox(width: width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: height * 0.016,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: height * 0.005),
              Text(
                duration,
                style: TextStyle(
                  fontSize: height * 0.014,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: isLast ? 0 : height * 0.015),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineDivider(double height) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: SizedBox(height: height * 0.02),
    );
  }

  Widget _buildSkillsSection(double height, double width) {
    List<String> skills = [
      'Project Management',
      'Team Leadership',
      'Agile Methodology',
      'Risk Assessment',
      'Budget Planning',
      'Resource Allocation',
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Wrap(
          spacing: width * 0.02,
          runSpacing: height * 0.01,
          children:
              skills.map((skill) => _buildSkillChip(skill, height)).toList(),
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill, double height) {
    return Chip(
      backgroundColor: AppColors.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      label: Text(
        skill,
        style: TextStyle(
          fontSize: height * 0.014,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildEducationSection(double height, double width) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          children: [
            _buildEducationItem(
              institution: 'Syracuse University',
              degree: 'Master of Business Administration',
              duration: '2020 - 2022',
              height: height,
              width: width,
            ),
            Divider(),
            _buildEducationItem(
              institution: 'University of California',
              degree: 'Bachelor of Science in Engineering',
              duration: '2016 - 2020',
              height: height,
              width: width,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationItem({
    required String institution,
    required String degree,
    required String duration,
    required double height,
    required double width,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width * 0.1,
          height: width * 0.1,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              Icons.school_outlined,
              color: AppColors.primary,
              size: height * 0.025,
            ),
          ),
        ),
        SizedBox(width: width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                institution,
                style: TextStyle(
                  fontSize: height * 0.016,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: height * 0.005),
              Text(
                degree,
                style: TextStyle(
                  fontSize: height * 0.014,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: height * 0.005),
              Text(
                duration,
                style: TextStyle(
                  fontSize: height * 0.013,
                  color: AppColors.textSecondary.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsMenu(double height, double width) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.insert_drive_file_outlined,
            title: 'My Resume',
            subtitle:
                _resumeFile != null ? 'Resume uploaded' : 'Update your CV',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ResumeUploadScreen()),
              );
            },
            height: height,
            width: width,
          ),
          Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            subtitle: 'Job alerts & messages',
            onTap: () {},
            height: height,
            width: width,
          ),
          Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.lock_outline,
            title: 'Privacy & Security',
            subtitle: 'Manage your account security',
            onTap: () {},
            height: height,
            width: width,
          ),
          Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.help_outline,
            title: 'Help Center',
            subtitle: 'Get support and feedback',
            onTap: () {},
            showDivider: false,
            height: height,
            width: width,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required double height,
    required double width,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.018,
        ),
        child: Row(
          children: [
            Container(
              width: width * 0.1,
              height: width * 0.1,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: height * 0.025),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: height * 0.016,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: height * 0.003),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: height * 0.013,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: height * 0.025,
            ),
          ],
        ),
      ),
    );
  }
}
