import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentViewerModal extends StatefulWidget {
  final Map<String, dynamic> document;

  const DocumentViewerModal({
    Key? key,
    required this.document,
  }) : super(key: key);

  @override
  State<DocumentViewerModal> createState() => _DocumentViewerModalState();
}

class _DocumentViewerModalState extends State<DocumentViewerModal> {
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.document['title'] as String,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareDocument,
            icon: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: _downloadDocument,
            icon: CustomIconWidget(
              iconName: 'download',
              color: Colors.white,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onScaleStart: (details) {
            _previousScale = _scale;
          },
          onScaleUpdate: (details) {
            setState(() {
              _scale = (_previousScale * details.scale).clamp(0.5, 3.0);
            });
          },
          child: Transform.scale(
            scale: _scale,
            child: Container(
              width: 90.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.document['imageUrl'] != null
                  ? CustomImageWidget(
                      imageUrl: widget.document['imageUrl'] as String,
                      width: 90.w,
                      height: 70.h,
                      fit: BoxFit.contain,
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'description',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 15.w,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Document Preview',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Tap to view full document',
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
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: EdgeInsets.all(4.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: 'note_add',
              label: 'Add Notes',
              onTap: _addNotes,
            ),
            _buildActionButton(
              icon: 'notifications',
              label: 'Set Reminder',
              onTap: _setReminder,
            ),
            _buildActionButton(
              icon: 'delete',
              label: 'Delete',
              onTap: _deleteDocument,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isDestructive
                  ? AppTheme.errorLight.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: isDestructive ? AppTheme.errorLight : Colors.white,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isDestructive ? AppTheme.errorLight : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _shareDocument() {
    // Share functionality implementation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${widget.document['title']}'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _downloadDocument() {
    // Download functionality implementation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${widget.document['title']}'),
        backgroundColor: AppTheme.secondaryLight,
      ),
    );
  }

  void _addNotes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Notes'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter your notes...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notes added successfully')),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _setReminder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Reminder'),
        content: Text('Choose when to be reminded about this document'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reminder set successfully')),
              );
            },
            child: Text('Set'),
          ),
        ],
      ),
    );
  }

  void _deleteDocument() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Document'),
        content: Text(
            'Are you sure you want to delete this document? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Document deleted successfully'),
                  backgroundColor: AppTheme.errorLight,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
