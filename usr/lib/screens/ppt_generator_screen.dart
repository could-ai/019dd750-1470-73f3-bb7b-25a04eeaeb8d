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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PptProvider>();
    final draft = provider.currentDraft;

    if (draft == null) return const Scaffold();

    return Scaffold(
      appBar: AppBar(title: const Text('Design Your PPT')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(
                labelText: 'Presentation Topic / Details',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => provider.updateDraft('topic', val),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            
            _buildDropdown(
              'Template', 
              draft['template'], 
              ['Professional', 'Creative', 'Minimalist', 'Academic'],
              (val) => provider.updateDraft('template', val)
            ),
            
            _buildDropdown(
              'Transitions', 
              draft['transitions'], 
              ['Fade', 'Slide', 'Zoom', 'None'],
              (val) => provider.updateDraft('transitions', val)
            ),

            _buildDropdown(
              'Style / Effects', 
              draft['style'], 
              ['Modern', 'Classic', 'Playful', 'Corporate'],
              (val) => provider.updateDraft('style', val)
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
                    onChanged: (val) => provider.updateDraft('slideCount', val.toInt()),
                  ),
                ),
                Text(draft['slideCount'].toString()),
              ],
            ),

            SwitchListTile(
              title: const Text('Include Introduction Slide'),
              value: draft['includeIntro'] as bool,
              onChanged: (val) => provider.updateDraft('includeIntro', val),
            ),

            SwitchListTile(
              title: const Text('Include Thank You Slide'),
              value: draft['includeThankYou'] as bool,
              onChanged: (val) => provider.updateDraft('includeThankYou', val),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (_topicController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a topic or details'))
                    );
                    return;
                  }
                  
                  showDialog(
                    context: context, 
                    barrierDismissible: false,
                    builder: (c) => const Center(child: CircularProgressIndicator())
                  );
                  
                  await provider.generatePpt();
                  
                  if (context.mounted) {
                    Navigator.pop(context); // close dialog
                    Navigator.pushNamed(context, '/preview');
                  }
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate Presentation'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String currentValue, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        value: currentValue,
        items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
