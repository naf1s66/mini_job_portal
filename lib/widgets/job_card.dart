import 'package:flutter/material.dart';
import '../models/job.dart';
import '../services/storage_service.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;
  const JobCard({super.key, required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSaved = StorageService.isJobSaved(job.id);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.business, size: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(job.company, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black12,
                    ),
                    child: Text(job.location, style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(job.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Salary: \$${job.salary}', style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: isSaved ? null : () {
                      StorageService.saveJob(job);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to your jobs')));
                    },
                    icon: const Icon(Icons.send),
                    label: Text(isSaved ? 'Applied' : 'Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
