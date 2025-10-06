import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/job_card.dart';
import 'job_detail_page.dart';

class SavedJobsPage extends StatefulWidget {
  const SavedJobsPage({super.key});

  @override
  State<SavedJobsPage> createState() => _SavedJobsPageState();
}

class _SavedJobsPageState extends State<SavedJobsPage> {
  @override
  Widget build(BuildContext context) {
    final saved = StorageService.getSavedJobs();
    if (saved.isEmpty) {
      return const Center(child: Text('No saved jobs yet. Apply to save.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, i) {
        final job = saved[i];
        return Dismissible(
          key: ValueKey(job.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            StorageService.removeJob(job.id);
            setState(() {});
          },
          child: JobCard(
            job: job,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => JobDetailPage(jobId: job.id)));
            },
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: saved.length,
    );
  }
}
