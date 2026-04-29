import 'package:flutter/material.dart';

class PptProject {
  final String id;
  final String title;
  final DateTime createdAt;
  final Map<String, dynamic> config;

  PptProject({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.config,
  });
}

class PptProvider extends ChangeNotifier {
  final List<PptProject> _projects = [];
  Map<String, dynamic>? _currentDraft;

  List<PptProject> get projects => _projects;
  Map<String, dynamic>? get currentDraft => _currentDraft;

  void startNewProject() {
    _currentDraft = {
      'topic': '',
      'template': 'Professional',
      'transitions': 'Fade',
      'style': 'Modern',
      'slideCount': 5,
      'includeIntro': true,
      'includeThankYou': true,
    };
    notifyListeners();
  }

  void updateDraft(String key, dynamic value) {
    if (_currentDraft != null) {
      _currentDraft![key] = value;
      notifyListeners();
    }
  }

  Future<void> generatePpt() async {
    // Mock PPT generation time
    await Future.delayed(const Duration(seconds: 2));
  }

  void saveCurrentProject() {
    if (_currentDraft != null) {
      final newProject = PptProject(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _currentDraft!['topic']?.isNotEmpty == true 
            ? _currentDraft!['topic'] 
            : 'Untitled Presentation',
        createdAt: DateTime.now(),
        config: Map.from(_currentDraft!),
      );
      _projects.add(newProject);
      notifyListeners();
    }
  }

  void deleteProject(String id) {
    _projects.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
