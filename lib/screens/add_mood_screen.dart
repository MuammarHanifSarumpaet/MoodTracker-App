import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../database/database_helper.dart';
import '../models/mood.dart';

class AddMoodScreen extends StatefulWidget {
  const AddMoodScreen({super.key});

  @override
  State<AddMoodScreen> createState() => _AddMoodScreenState();
}

class _AddMoodScreenState extends State<AddMoodScreen> {
  String selectedMood = '😊';
  final TextEditingController categoryController = TextEditingController();
  File? _selectedImage;

  final List<String> moods = ['😡', '😢', '😐', '😊', '😍'];
  final Map<String, int> moodScores = {
    '😡': 1,
    '😢': 2,
    '😐': 3,
    '😊': 4,
    '😍': 5
  };

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');
      setState(() => _selectedImage = savedImage);
    }
  }

  void saveMood() async {
    if (categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Tulis catatan harimu')));
      return;
    }

    final moodEntry = Mood(
      mood: selectedMood,
      moodLevel: moodScores[selectedMood] ?? 3,
      category: categoryController.text,
      date: DateTime.now().toIso8601String(),
      imagePath: _selectedImage?.path,
    );

    await DatabaseHelper.instance.insertMood(moodEntry);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Mood')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              children: moods
                  .map((m) => ChoiceChip(
                        label: Text(m, style: const TextStyle(fontSize: 25)),
                        selected: selectedMood == m,
                        onSelected: (_) => setState(() => selectedMood = m),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 40, color: Colors.blue),
                          Text("Lampirkan Foto (Opsional)",
                              style: TextStyle(color: Colors.blue)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                  labelText: 'Catatan', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: saveMood, child: const Text('Simpan Jurnal')),
            ),
          ],
        ),
      ),
    );
  }
}
