import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ppt_provider.dart';

class PptGeneratorScreen extends StatefulWidget {
  const PptGeneratorScreen({super.key});

  @override
  State<PptGeneratorScreen> createState() => _PptGeneratorScreenState();
}

class _PptGeneratorScreenState extends State<PptGeneratorScreen> {
  final _topicController = TextEditingController();

  final List<String> _templates = ['Professional', 'Creative', 'Minimalist', 'Academic'];
  final List<String> _transitions = ['Fade', 'Slide', 'Zoom', 'None'];
  final List<String> _styles = ['Modern', 'Classic', 'Playful'];

  @override
  void initState() {
    super.initState();
    final draft = context.read<PptProvider>().currentDraft;
    if (draft != null) {
      _topicController.text = draft['topic'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pptProvider = context.watch<PptProvider>();
    final draft = pptProvider.currentDraft;

    if (draft == null) return const Scaffold(body: Center(child: Text('No active draft')));

    return Scaffold(
      appBar: AppBar(title: const Text('Configure Presentation')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _topicController,
            decoration: const InputDecoration(
              labelText: 'Topic / Details',
              hintText: 'E.g., Quarterly Financial Report Q3',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (val) => pptProvider.updateDraft('topic', val),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: draft['template'],
            decoration: const InputDecoration(labelText: 'Template', border: OutlineInputBorder()),
            items: _templates.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (val) => pptProvider.updateDraft('template', val),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: draft['transitions'],
            decoration: const InputDecoration(labelText: 'Transitions', border: OutlineInputBorder()),
            items: _transitions.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (val) => pptProvider.updateDraft('transitions', val),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: draft['style'],
            decoration: const InputDecoration(labelText: 'Style', border: OutlineInputBorder()),
            items: _styles.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (val) => pptProvider.updateDraft('style', val),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Number of Slides: '),
              Expanded(
                child: Slider(
                  value: (draft['slideCount'] as int).toDouble(),
                  min: 1,
                  max: 20,
                  divisions: 19,
                  label: draft['slideCount'].toString(),
                  onChanged: (val) => pptProvider.updateDraft('slideCount', val.toInt()),
                ),
              ),
              Text(draft['slideCount'].toString()),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Include Introduction Slide'),
            value: draft['includeIntro'] as bool,
            onChanged: (val) => pptProvider.updateDraft('includeIntro', val),
          ),
          SwitchListTile(
            title: const Text('Include Thank You Slide'),
            value: draft['includeThankYou'] as bool,
            onChanged: (val) => pptProvider.updateDraft('includeThankYou', val),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              if (_topicController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a topic or details')),
                );
                return;
              }
              
              showDialog(
                context: context, 
                barrierDismissible: false,
                builder: (c) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Generating your presentation...'),
                    ],
                  ),
                )
              );

              await pptProvider.generatePpt();
              
              if (mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pushNamed(context, '/preview');
              }
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate PPT'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
