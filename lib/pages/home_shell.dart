import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'job_list_page.dart';
import 'saved_jobs_page.dart';
import 'profile_page.dart';
import '../pages/login_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _pages = const [
    JobListPage(),
    SavedJobsPage(),
    ProfilePage(),
  ];

  void _logout() {
    context.read<AuthService>().signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthService>().email ?? 'user@example.com';
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.work_outline),
            SizedBox(width: 8),
            Text('Job Portal'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: PopupMenuButton<String>(
              icon: const CircleAvatar(child: Icon(Icons.person)),
              onSelected: (v) {
                if (v == 'logout') _logout();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'email',
                  enabled: false,
                  child: Text(email),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 18),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 24, child: Icon(Icons.person)),
                    SizedBox(height: 12),
                    Text('Mini Job Portal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Find your next role'),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.list_alt),
                title: const Text('Jobs'),
                selected: _index == 0,
                onTap: () => setState(() => _index = 0),
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_added_outlined),
                title: const Text('Saved Jobs'),
                selected: _index == 1,
                onTap: () => setState(() => _index = 1),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                selected: _index == 2,
                onTap: () => setState(() => _index = 2),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.work), label: 'Jobs'),
          NavigationDestination(icon: Icon(Icons.bookmark), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
