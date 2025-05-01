import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job/constants/app_colors.dart';

class ResumeUploadScreen extends StatefulWidget {
  final File? initialResume;

  const ResumeUploadScreen({super.key, this.initialResume});

  @override
  State<ResumeUploadScreen> createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends State<ResumeUploadScreen> {
  File? _resumeFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _resumeFile = widget.initialResume;
  }

  Future<void> _pickResumeFile() async {
    try {
      setState(() {
        _isUploading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      setState(() {
        _isUploading = false;
      });

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        if (file.path != null) {
          setState(() {
            _resumeFile = File(file.path!);
          });
        }
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick resume: ${e.toString()}')),
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
        title: Text(
          'My Resume',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body:
          _isUploading
              ? _buildLoadingState(height)
              : _resumeFile == null
              ? _buildEmptyState(height, width)
              : _buildResumePreview(height, width),
    );
  }

  Widget _buildLoadingState(double height) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: height * 0.02),
          Text(
            'Processing your resume...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: height * 0.018,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(double height, double width) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width * 0.5,
              height: width * 0.5,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.description_outlined,
                size: width * 0.25,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: height * 0.03),
            Text(
              'No Resume Uploaded',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: height * 0.01),
            Text(
              'Upload your resume to showcase your skills and experience to potential employers',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: height * 0.016,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: height * 0.04),
            ElevatedButton.icon(
              onPressed: _pickResumeFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.1,
                  vertical: height * 0.018,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.upload_file, color: Colors.white),
              label: Text(
                'Upload Resume',
                style: TextStyle(
                  fontSize: height * 0.018,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumePreview(double height, double width) {
    final fileName = _resumeFile?.path.split('/').last ?? 'Unknown file';
    final extension = fileName.split('.').last.toLowerCase();

    return Center(
      child: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width * 0.6,
              height: height * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    extension == 'pdf'
                        ? Icons.picture_as_pdf
                        : extension == 'doc' || extension == 'docx'
                        ? Icons.article
                        : Icons.insert_drive_file,
                    size: height * 0.1,
                    color:
                        extension == 'pdf'
                            ? Colors.red
                            : extension == 'doc' || extension == 'docx'
                            ? Colors.blue
                            : AppColors.primary,
                  ),
                  SizedBox(height: height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Text(
                      fileName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: height * 0.018,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    'Resume Successfully Uploaded',
                    style: TextStyle(
                      fontSize: height * 0.016,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Open the resume file
                    // You would need a PDF viewer implementation here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening resume: $fileName')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.visibility, color: Colors.white),
                  label: Text(
                    'View',
                    style: TextStyle(
                      fontSize: height * 0.016,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: width * 0.03),
                OutlinedButton.icon(
                  onPressed: _pickResumeFile,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.upload_file, color: AppColors.primary),
                  label: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: height * 0.016,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _resumeFile = null;
                });
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Resume removed')));
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.015,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.delete_outline, color: Colors.red),
              label: Text(
                'Delete Resume',
                style: TextStyle(fontSize: height * 0.016, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
