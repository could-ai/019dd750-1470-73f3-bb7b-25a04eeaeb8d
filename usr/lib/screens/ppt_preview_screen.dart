import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ppt_provider.dart';

class PptPreviewScreen extends StatelessWidget {
  const PptPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PptProvider>();
    final draft = provider.currentDraft;

    if (draft == null) return const Scaffold();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Presentation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.slideshow, size: 100, color: Colors.deepPurple),
                    const SizedBox(height: 16),
                    Text(
                      draft['topic']?.isNotEmpty == true ? draft['topic'] : 'Untitled',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text('Template: ${draft['template']} | Style: ${draft['style']}'),
                    Text('${draft['slideCount']} Slides Generated'),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    provider.saveCurrentProject();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved to your presentations!'))
                    );
                    Navigator.popUntil(context, ModalRoute.withName('/home'));
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading PPTX... (Mock)'))
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
