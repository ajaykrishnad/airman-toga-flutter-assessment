import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:airman_toga_flutter_assessment/features/study/presentation/providers/study_provider.dart';
import 'package:airman_toga_flutter_assessment/features/study/data/models/study_subject_model.dart';
import 'package:go_router/go_router.dart';

class StudySubjectsPage extends ConsumerStatefulWidget {
  const StudySubjectsPage({super.key});

  @override
  ConsumerState<StudySubjectsPage> createState() => _StudySubjectsPageState();
}

class _StudySubjectsPageState extends ConsumerState<StudySubjectsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subjectsProvider.notifier).loadSubjects('user_arjun_menon');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subjectsState = ref.watch(subjectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Subjects'),
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFF0A1628),
        child: Column(
          children: [
            // Search Filter
            Container(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    const Icon(
                      Icons.search,
                      color: Colors.white54,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search subjects...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
            // Subject List
            Expanded(
              child: subjectsState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FC3F7)),
                      ),
                    )
                  : subjectsState.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xFFEF5350),
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load subjects',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                subjectsState.error!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(subjectsProvider.notifier).loadSubjects('user_arjun_menon');
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : subjectsState.subjects.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.book_outlined,
                                    color: Colors.white30,
                                    size: 64,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No subjects available',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Start your aviation journey',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _buildSubjectList(subjectsState.subjects),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectList(List<StudySubjectModel> subjects) {
    final filteredSubjects = _searchQuery.isEmpty
        ? subjects
        : subjects.where((subject) =>
            subject.title.toLowerCase().contains(_searchQuery) ||
            subject.code.toLowerCase().contains(_searchQuery) ||
            subject.category.toLowerCase().contains(_searchQuery)
          ).toList();

    if (filteredSubjects.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              color: Colors.white30,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'No subjects found',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: filteredSubjects.length,
      itemBuilder: (context, index) {
        final subject = filteredSubjects[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildSubjectCard(subject),
        );
      },
    );
  }

  Widget _buildSubjectCard(StudySubjectModel subject) {
    final statusColor = _getStatusColor(subject.status);
    
    return InkWell(
      onTap: () {
        context.push('/study/subjects/${subject.id}');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusColor.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getStatusIcon(subject.status),
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.code,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subject.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subject.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatusBadge(subject.status),
                const SizedBox(width: 8),
                _buildCategoryBadge(subject.category),
                const Spacer(),
                Text(
                  '${subject.progressPercentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: subject.progressPercentage / 100,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildProgressChip(
                  '${subject.completedChapters}/${subject.totalChapters}',
                  Icons.book,
                ),
                const SizedBox(width: 8),
                _buildProgressChip(
                  '${subject.completedHours.toStringAsFixed(1)}/${subject.requiredHours.toStringAsFixed(0)}h',
                  Icons.access_time,
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: statusColor,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(SubjectStatus status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        status.statusText,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProgressChip(String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white54, size: 12),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(SubjectStatus status) {
    switch (status) {
      case SubjectStatus.notStarted:
        return const Color(0xFF9E9E9E);
      case SubjectStatus.inProgress:
        return const Color(0xFF4FC3F7);
      case SubjectStatus.completed:
        return const Color(0xFF66BB6A);
      case SubjectStatus.onHold:
        return const Color(0xFFFFA726);
    }
  }

  IconData _getStatusIcon(SubjectStatus status) {
    switch (status) {
      case SubjectStatus.notStarted:
        return Icons.play_circle_outline;
      case SubjectStatus.inProgress:
        return Icons.play_circle_filled;
      case SubjectStatus.completed:
        return Icons.check_circle;
      case SubjectStatus.onHold:
        return Icons.pause_circle;
    }
  }
}
