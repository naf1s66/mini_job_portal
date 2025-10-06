import 'package:flutter/material.dart';
import '../models/job.dart';
import '../services/api_service.dart';
import '../widgets/job_card.dart';
import 'job_detail_page.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({super.key});

  @override
  State<JobListPage> createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  late Future<List<Job>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final jobs = snapshot.data ?? [];
        if (jobs.isEmpty) {
          return const Center(child: Text('No jobs found.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, i) {
            final job = jobs[i];
            return JobCard(
              job: job,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => JobDetailPage(jobId: job.id)));
              },
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemCount: jobs.length,
        );
      },
    );
  }
}
