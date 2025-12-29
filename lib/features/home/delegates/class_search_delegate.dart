import 'package:flutter/material.dart';
import '../../classes/services/student_class_service.dart';

class ClassSearchDelegate extends SearchDelegate<StudentClassModel?> {
  final List<StudentClassModel> classes;

  ClassSearchDelegate(this.classes);

  @override
  String get searchFieldLabel => 'Cari kelas atau dosen...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final filteredClasses = classes.where((classItem) {
      final queryLower = query.toLowerCase();
      final nameLower = classItem.name.toLowerCase();
      final teacherLower = classItem.teacherName.toLowerCase();
      return nameLower.contains(queryLower) ||
          teacherLower.contains(queryLower);
    }).toList();

    if (filteredClasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Tidak ada kelas ditemukan',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredClasses.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final classItem = filteredClasses[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Icon(Icons.class_outlined, color: Colors.blue.shade700),
          ),
          title: Text(
            classItem.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(classItem.teacherName),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            close(context, classItem);
            Navigator.pushNamed(
              context,
              '/student/class/detail',
              arguments: classItem.id,
            );
          },
        );
      },
    );
  }
}
