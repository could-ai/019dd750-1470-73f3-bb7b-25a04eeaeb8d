import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ppt_provider.dart';

class PptPreviewScreen extends StatelessWidget {
  const PptPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pptProvider = context.watch<PptProvider>();
    final draft = pptProvider.currentDraft;

    if (draft == null) return const Scaffold(body: Center(child: Text('No active draft')));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview & Export'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save to My Presentations',
            onPressed: () {
              pptProvider.saveCurrentProject();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved to My Presentations')),
              );
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Icon(Icons.slideshow, size: 64, color: Colors.deepPurple),
                      ),
                      const SizedBox(height: 24),
                      Text('Topic: ${draft['topic']}', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      Text('Template: ${draft['template']}'),
                      Text('Transitions: ${draft['transitions']}'),
                      Text('Style: ${draft['style']}'),
                      Text('Slides: ${draft['slideCount']}'),
                      Text('Intro Slide: ${draft['includeIntro'] ? "Yes" : "No"}'),
                      Text('Thank You Slide: ${draft['includeThankYou'] ? "Yes" : "No"}'),
                      const Spacer(),
                      const Center(
                        child: Text('Preview Mode: Layout is ready!', 
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Store functionality mocked')),
                      );
                    },
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Store to Cloud'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Downloading PPTX...')),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download .pptx'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
