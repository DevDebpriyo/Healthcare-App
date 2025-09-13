import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/abha_sync_section.dart';
import './widgets/document_viewer_modal.dart';
import './widgets/record_category_tabs.dart';
import './widgets/record_item_card.dart';
import './widgets/upload_document_modal.dart';

class HealthRecords extends StatefulWidget {
  const HealthRecords({Key? key}) : super(key: key);

  @override
  State<HealthRecords> createState() => _HealthRecordsState();
}

class _HealthRecordsState extends State<HealthRecords> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isAbhaConnected = true;
  String _lastSyncTime = '2 hours ago';

  List<Map<String, dynamic>> _healthRecords = [
    {
      'id': '1',
      'title': 'Blood Test Report',
      'type': 'lab_report',
      'doctorName': 'Manju Devi - Apollo Labs',
      'date': '28/08/2024',
      'imageUrl':
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=600&fit=crop',
      'synced': true,
    },
    {
      'id': '2',
      'title': 'Chest X-Ray',
      'type': 'scan',
      'doctorName': 'Dr. Rajesh Kumar - City Hospital',
      'date': '25/08/2024',
      'imageUrl':
          'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400&h=600&fit=crop',
      'synced': true,
    },
    {
      'id': '3',
      'title': 'Diabetes Medication',
      'type': 'prescription',
      'doctorName': 'Dr. Anita Verma - Max Healthcare',
      'date': '22/08/2024',
      'imageUrl':
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=600&fit=crop',
      'synced': false,
    },
    {
      'id': '4',
      'title': 'COVID-19 Vaccination',
      'type': 'vaccination',
      'doctorName': 'Government Health Center',
      'date': '15/08/2024',
      'imageUrl':
          'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400&h=600&fit=crop',
      'synced': true,
    },
    {
      'id': '5',
      'title': 'Lipid Profile',
      'type': 'lab_report',
      'doctorName': 'Dr. Suresh Patel - Fortis Labs',
      'date': '10/08/2024',
      'imageUrl':
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=600&fit=crop',
      'synced': true,
    },
    {
      'id': '6',
      'title': 'MRI Brain Scan',
      'type': 'scan',
      'doctorName': 'Dr. Meera Singh - AIIMS',
      'date': '05/08/2024',
      'imageUrl':
          'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400&h=600&fit=crop',
      'synced': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredRecords {
    List<Map<String, dynamic>> filtered = _healthRecords;

    // Filter by category
    if (_selectedCategoryIndex != 0) {
      final categories = [
        'all',
        'prescription',
        'lab_report',
        'scan',
        'vaccination'
      ];
      final selectedCategory = categories[_selectedCategoryIndex];
      filtered = filtered
          .where((record) => record['type'] == selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((record) {
        final title = (record['title'] as String).toLowerCase();
        final doctorName = (record['doctorName'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || doctorName.contains(query);
      }).toList();
    }

    // Sort by date (most recent first)
    filtered.sort((a, b) {
      final dateA = _parseDate(a['date'] as String);
      final dateB = _parseDate(b['date'] as String);
      return dateB.compareTo(dateA);
    });

    return filtered;
  }

  DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('/');
    if (parts.length == 3) {
      return DateTime(
        int.parse(parts[2]), // year
        int.parse(parts[1]), // month
        int.parse(parts[0]), // day
      );
    }
    return DateTime.now();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Health Records',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showUploadModal,
            icon: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: EdgeInsets.all(4.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search records, doctors, dates...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.lightTheme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Category tabs
          RecordCategoryTabs(
            selectedIndex: _selectedCategoryIndex,
            onTabChanged: (index) {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
          ),

          // ABHA sync section
          AbhaSyncSection(
            isConnected: _isAbhaConnected,
            lastSyncTime: _lastSyncTime,
            onRefresh: _refreshAbhaSync,
            onConnect: _connectAbha,
          ),

          SizedBox(height: 2.h),

          // Records list
          Expanded(
            child: _filteredRecords.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = _filteredRecords[index];
                      return RecordItemCard(
                        record: record,
                        onTap: () => _viewDocument(record),
                        onLongPress: () => _showContextMenu(record),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadModal,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'camera_alt',
          color: Colors.white,
          size: 6.w,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'folder_open',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20.w,
          ),
          SizedBox(height: 3.h),
          Text(
            _searchQuery.isNotEmpty
                ? 'No records found'
                : 'No health records yet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search terms'
                : 'Start by uploading your first document',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isEmpty) ...[
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: _showUploadModal,
              icon: CustomIconWidget(
                iconName: 'camera_alt',
                color: Colors.white,
                size: 5.w,
              ),
              label: Text('Upload Document'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _viewDocument(Map<String, dynamic> document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentViewerModal(document: document),
      ),
    );
  }

  void _showContextMenu(Map<String, dynamic> record) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem(
              icon: 'share',
              title: 'Share',
              onTap: () {
                Navigator.pop(context);
                _shareRecord(record);
              },
            ),
            _buildContextMenuItem(
              icon: 'note_add',
              title: 'Add Notes',
              onTap: () {
                Navigator.pop(context);
                _addNotesToRecord(record);
              },
            ),
            _buildContextMenuItem(
              icon: 'notifications',
              title: 'Set Reminder',
              onTap: () {
                Navigator.pop(context);
                _setReminderForRecord(record);
              },
            ),
            _buildContextMenuItem(
              icon: 'delete',
              title: 'Delete',
              onTap: () {
                Navigator.pop(context);
                _deleteRecord(record);
              },
              isDestructive: true,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? AppTheme.errorLight
            : AppTheme.lightTheme.colorScheme.onSurface,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive
              ? AppTheme.errorLight
              : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showUploadModal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadDocumentModal(
          onDocumentUploaded: (document) {
            setState(() {
              _healthRecords.insert(0, document);
            });
          },
        ),
      ),
    );
  }

  void _refreshAbhaSync() {
    setState(() {
      _lastSyncTime = 'Just now';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ABHA records synced successfully'),
        backgroundColor: AppTheme.secondaryLight,
      ),
    );
  }

  void _connectAbha() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connect ABHA ID'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'ABHA ID',
                hintText: 'Enter your 14-digit ABHA ID',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                hintText: 'Enter registered mobile number',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isAbhaConnected = true;
                _lastSyncTime = 'Just now';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('ABHA ID connected successfully'),
                  backgroundColor: AppTheme.secondaryLight,
                ),
              );
            },
            child: Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _shareRecord(Map<String, dynamic> record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${record['title']}'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _addNotesToRecord(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Notes'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter your notes for ${record['title']}...',
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

  void _setReminderForRecord(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Reminder'),
        content: Text('Set a reminder for ${record['title']}'),
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

  void _deleteRecord(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Record'),
        content: Text(
            'Are you sure you want to delete "${record['title']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _healthRecords.removeWhere((r) => r['id'] == record['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Record deleted successfully'),
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
