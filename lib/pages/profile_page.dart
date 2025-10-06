import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthService>().email ?? 'user@example.com';
    final saved = StorageService.savedCount();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(email),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Total Saved Jobs'),
              trailing: Text('$saved'),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About'),
              subtitle: Text('This is a demo profile using dummy data.'),
            ),
          ),
        ],
      ),
    );
  }
}
