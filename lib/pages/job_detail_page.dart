import 'package:flutter/material.dart';
import '../models/job.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class JobDetailPage extends StatefulWidget {
  final int jobId;
  const JobDetailPage({super.key, required this.jobId});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  late Future<Job> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchJobById(widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Details')),
      body: FutureBuilder<Job>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final job = snapshot.data!;
          final saved = StorageService.isJobSaved(job.id);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('${job.company} • ${job.location}'),
                const SizedBox(height: 12),
                Text('Salary: \$${job.salary}'),
                const Divider(height: 24),
                Expanded(child: SingleChildScrollView(child: Text(job.description))),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: saved ? null : () {
                    StorageService.saveJob(job);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to your jobs')));
                  },
                  icon: const Icon(Icons.send),
                  label: Text(saved ? 'Applied' : 'Apply'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
