import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

enum NoteSyncStatus {
  synced,
  syncing,
  failed,
  offline,
}

class OfflineNotePage extends ConsumerStatefulWidget {
  final String? noteId;

  const OfflineNotePage({super.key, this.noteId});

  @override
  ConsumerState<OfflineNotePage> createState() => _OfflineNotePageState();
}

class _OfflineNotePageState extends ConsumerState<OfflineNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  
  NoteSyncStatus _syncStatus = NoteSyncStatus.offline;
  String? _syncError;
  
  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _loadNote() async {
    if (widget.noteId != null) {
      final box = await Hive.openBox('studyNotes');
      final note = box.get(widget.noteId);
      if (note != null) {
        setState(() {
          _titleController.text = note['title'] ?? '';
          _contentController.text = note['content'] ?? '';
          _tagsController.text = note['tags']?.join(', ') ?? '';
          _syncStatus = NoteSyncStatus.values.firstWhere(
            (s) => s.name == (note['syncStatus'] ?? 'offline'),
            orElse: () => NoteSyncStatus.offline,
          );
        });
      }
    }
  }

  Future<void> _saveNoteLocally() async {
    final box = await Hive.openBox('studyNotes');
    final noteId = widget.noteId ?? const Uuid().v4();
    
    await box.put(noteId, {
      'id': noteId,
      'title': _titleController.text,
      'content': _contentController.text,
      'tags': _tagsController.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
      'syncStatus': _syncStatus.name,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _syncNote() async {
    setState(() {
      _syncStatus = NoteSyncStatus.syncing;
      _syncError = null;
    });

    // Simulate network delay with randomized success/failure
    await Future.delayed(const Duration(seconds: 2));
    
    final randomSuccess = DateTime.now().millisecond % 3 != 0; // 2/3 chance of success
    
    if (randomSuccess) {
      setState(() {
        _syncStatus = NoteSyncStatus.synced;
        _syncError = null;
      });
      await _saveNoteLocally();
    } else {
      setState(() {
        _syncStatus = NoteSyncStatus.failed;
        _syncError = 'Network error: Unable to sync with server. Please check your connection and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Study Note'),
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_syncStatus == NoteSyncStatus.syncing)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FC3F7)),
                ),
              ),
            )
          else
            IconButton(
              icon: Icon(
                _syncStatus == NoteSyncStatus.synced 
                    ? Icons.cloud_done 
                    : Icons.cloud_upload,
                color: _syncStatus == NoteSyncStatus.synced 
                    ? const Color(0xFF66BB6A) 
                    : const Color(0xFF4FC3F7),
              ),
              onPressed: _syncNote,
              tooltip: 'Sync Now',
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(),
            tooltip: 'Delete',
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF0A1628),
        child: Column(
          children: [
            // Sync Status Banner
            if (_syncError != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF5350).withValues(alpha: 0.2),
                  border: const Border(
                    bottom: BorderSide(
                      color: Color(0xFFEF5350),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Color(0xFFEF5350),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _syncError!,
                        style: const TextStyle(
                          color: Color(0xFFEF5350),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFFEF5350), size: 18),
                      onPressed: () {
                        setState(() {
                          _syncError = null;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              )
            else if (_syncStatus == NoteSyncStatus.synced)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF66BB6A).withValues(alpha: 0.2),
                  border: const Border(
                    bottom: BorderSide(
                      color: Color(0xFF66BB6A),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF66BB6A),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Note synced successfully',
                      style: TextStyle(
                        color: Color(0xFF66BB6A),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else if (_syncStatus == NoteSyncStatus.offline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA726).withValues(alpha: 0.2),
                  border: const Border(
                    bottom: BorderSide(
                      color: Color(0xFFFFA726),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.cloud_off,
                      color: Color(0xFFFFA726),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Working offline. Changes will be saved locally.',
                        style: TextStyle(
                          color: Color(0xFFFFA726),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Note Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Field
                    const Text(
                      'Title',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Enter note title...',
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        onChanged: (_) => _saveNoteLocally(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Content Field
                    const Text(
                      'Content',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _contentController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 15,
                        decoration: const InputDecoration(
                          hintText: 'Write your study notes here...',
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        onChanged: (_) => _saveNoteLocally(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Tags Field
                    const Text(
                      'Tags (comma separated)',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _tagsController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'e.g., aerodynamics, lift, basics',
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        onChanged: (_) => _saveNoteLocally(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Sync Status Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getStatusIcon(),
                            color: _getStatusColor(),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getStatusText(),
                                  style: TextStyle(
                                    color: _getStatusColor(),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getStatusDescription(),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Manual Sync Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _syncStatus == NoteSyncStatus.syncing 
                            ? null 
                            : _syncNote,
                        icon: Icon(
                          _syncStatus == NoteSyncStatus.syncing 
                              ? Icons.sync 
                              : Icons.cloud_upload,
                          size: 20,
                        ),
                        label: Text(
                          _syncStatus == NoteSyncStatus.syncing 
                              ? 'Syncing...' 
                              : 'Sync Now',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getStatusColor(),
                          foregroundColor: const Color(0xFF0A1628),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: Colors.white24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (_syncStatus) {
      case NoteSyncStatus.synced:
        return Icons.cloud_done;
      case NoteSyncStatus.syncing:
        return Icons.sync;
      case NoteSyncStatus.failed:
        return Icons.cloud_off;
      case NoteSyncStatus.offline:
        return Icons.cloud_queue;
    }
  }

  Color _getStatusColor() {
    switch (_syncStatus) {
      case NoteSyncStatus.synced:
        return const Color(0xFF66BB6A);
      case NoteSyncStatus.syncing:
        return const Color(0xFF4FC3F7);
      case NoteSyncStatus.failed:
        return const Color(0xFFEF5350);
      case NoteSyncStatus.offline:
        return const Color(0xFFFFA726);
    }
  }

  String _getStatusText() {
    switch (_syncStatus) {
      case NoteSyncStatus.synced:
        return 'Synced';
      case NoteSyncStatus.syncing:
        return 'Syncing...';
      case NoteSyncStatus.failed:
        return 'Sync Failed';
      case NoteSyncStatus.offline:
        return 'Offline';
    }
  }

  String _getStatusDescription() {
    switch (_syncStatus) {
      case NoteSyncStatus.synced:
        return 'Your note is up to date with the server.';
      case NoteSyncStatus.syncing:
        return 'Uploading your note to the server...';
      case NoteSyncStatus.failed:
        return 'Last sync attempt failed. Tap to retry.';
      case NoteSyncStatus.offline:
        return 'Changes saved locally. Sync when online.';
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E3A5F),
        title: const Text(
          'Delete Note',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this note? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF4FC3F7)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (widget.noteId != null) {
                final box = await Hive.openBox('studyNotes');
                await box.delete(widget.noteId);
              }
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFEF5350)),
            ),
          ),
        ],
      ),
    );
  }
}
