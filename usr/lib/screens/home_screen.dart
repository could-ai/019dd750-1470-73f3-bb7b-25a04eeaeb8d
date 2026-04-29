import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/ppt_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final pptProvider = context.watch<PptProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Presentations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('User'),
              accountEmail: Text(authProvider.email ?? 'No email'),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                    ],
                  )
                );
                if (confirm == true && context.mounted) {
                  await context.read<AuthProvider>().deleteAccount();
                  if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
      body: pptProvider.projects.isEmpty
          ? const Center(child: Text('No presentations yet. Create one!'))
          : ListView.builder(
              itemCount: pptProvider.projects.length,
              itemBuilder: (context, index) {
                final project = pptProvider.projects[index];
                return ListTile(
                  leading: const Icon(Icons.slideshow),
                  title: Text(project.title),
                  subtitle: Text(project.createdAt.toString().split('.')[0]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => pptProvider.deleteProject(project.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<PptProvider>().startNewProject();
          Navigator.pushNamed(context, '/generate');
        },
        icon: const Icon(Icons.add),
        label: const Text('New PPT'),
      ),
    );
  }
}
