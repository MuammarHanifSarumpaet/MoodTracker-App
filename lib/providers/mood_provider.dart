import 'package:flutter/material.dart';
import '../models/mood.dart';

class MoodProvider with ChangeNotifier {
  final List<Mood> _moods = [];

  List<Mood> get moods => _moods;

  void addMood(Mood mood) {
    _moods.add(mood);
    notifyListeners();
  }
}
