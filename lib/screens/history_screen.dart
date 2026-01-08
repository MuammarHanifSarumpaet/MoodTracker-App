import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/mood.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Mood> _allMoods = [];
  List<Mood> _filteredMoods = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedEmoji = 'Semua';

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final data = await DatabaseHelper.instance.getAllMoods();
    setState(() {
      _allMoods = data;
      _filteredMoods = data;
    });
  }

  void _filterLogs(String query) {
    setState(() {
      _filteredMoods = _allMoods.where((m) {
        final matchesSearch =
            m.category.toLowerCase().contains(query.toLowerCase());
        final matchesEmoji =
            _selectedEmoji == 'Semua' || m.mood == _selectedEmoji;
        return matchesSearch && matchesEmoji;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Jurnal')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                  hintText: 'Cari catatan...', prefixIcon: Icon(Icons.search)),
              onChanged: _filterLogs,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredMoods.length,
              itemBuilder: (context, index) {
                final m = _filteredMoods[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: m.imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(File(m.imagePath!),
                                width: 50, height: 50, fit: BoxFit.cover),
                          )
                        : CircleAvatar(child: Text(m.mood)),
                    title: Text(m.category),
                    subtitle: Text(m.date.split('T')[0]),
                    trailing: Text("Lvl: ${m.moodLevel}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
