import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UploadDocumentModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onDocumentUploaded;

  const UploadDocumentModal({
    Key? key,
    required this.onDocumentUploaded,
  }) : super(key: key);

  @override
  State<UploadDocumentModal> createState() => _UploadDocumentModalState();
}

class _UploadDocumentModalState extends State<UploadDocumentModal> {
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  XFile? _capturedImage;
  bool _isCameraInitialized = false;
  bool _isUploading = false;
  String _selectedCategory = 'prescription';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  final List<Map<String, String>> _categories = [
    {'value': 'prescription', 'label': 'Prescription'},
    {'value': 'lab_report', 'label': 'Lab Report'},
    {'value': 'scan', 'label': 'Medical Scan'},
    {'value': 'vaccination', 'label': 'Vaccination'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _titleController.dispose();
    _doctorController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (!kIsWeb && await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras != null && _cameras!.isNotEmpty) {
          final camera = kIsWeb
              ? _cameras!.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.front,
                  orElse: () => _cameras!.first)
              : _cameras!.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.back,
                  orElse: () => _cameras!.first);

          _cameraController = CameraController(
              camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

          await _cameraController!.initialize();
          await _applySettings();

          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        }
      }
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;
    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          print('Flash mode not supported: $e');
        }
      }
    } catch (e) {
      print('Camera settings error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = photo;
      });
    } catch (e) {
      print('Photo capture error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to capture photo'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
        });
      }
    } catch (e) {
      print('Gallery picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image from gallery'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    }
  }

  Future<void> _uploadDocument() async {
    if (_capturedImage == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please capture/select an image and enter a title'),
          backgroundColor: AppTheme.warningLight,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Simulate upload process
      await Future.delayed(Duration(seconds: 2));

      final newDocument = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text,
        'type': _selectedCategory,
        'doctorName':
            _doctorController.text.isEmpty ? 'Unknown' : _doctorController.text,
        'date':
            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        'imageUrl':
            'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=600&fit=crop',
        'synced': false,
      };

      widget.onDocumentUploaded(newDocument);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Document uploaded successfully'),
          backgroundColor: AppTheme.secondaryLight,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload document'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Document'),
        actions: [
          if (_capturedImage != null)
            TextButton(
              onPressed: _isUploading ? null : _uploadDocument,
              child: _isUploading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Upload'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Camera/Image section
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: _capturedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.network(
                              _capturedImage!.path,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : CustomImageWidget(
                              imageUrl: _capturedImage!.path,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    )
                  : _isCameraInitialized && _cameraController != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CameraPreview(_cameraController!),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'camera_alt',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 15.w,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Camera not available',
                                style:
                                    AppTheme.lightTheme.textTheme.titleMedium,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Use gallery to select image',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),

            SizedBox(height: 3.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isCameraInitialized ? _capturePhoto : null,
                    icon: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: Colors.white,
                      size: 5.w,
                    ),
                    label: Text('Capture'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: CustomIconWidget(
                      iconName: 'photo_library',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 5.w,
                    ),
                    label: Text('Gallery'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.lightTheme.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // Document details form
            Text(
              'Document Details',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 2.h),

            // Category dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'category',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['value'],
                  child: Text(category['label']!),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),

            SizedBox(height: 2.h),

            // Title field
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Document Title *',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'title',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Doctor name field
            TextFormField(
              controller: _doctorController,
              decoration: InputDecoration(
                labelText: 'Doctor/Lab Name',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
