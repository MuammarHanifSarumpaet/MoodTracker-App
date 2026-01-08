import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/mood.dart';
import 'insight_screen.dart';

class CalendarHistoryScreen extends StatefulWidget {
  const CalendarHistoryScreen({super.key});

  @override
  State<CalendarHistoryScreen> createState() => _CalendarHistoryScreenState();
}

class _CalendarHistoryScreenState extends State<CalendarHistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Mood> _allMoods = [];
  List<Mood> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadMoods();
  }

  Future<void> _loadMoods() async {
    final data = await DatabaseHelper.instance.getAllMoods();
    setState(() {
      _allMoods = data;
      _selectedEvents = _allMoods
          .where((m) => isSameDay(DateTime.parse(m.date), _selectedDay))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalender Mood'), centerTitle: true),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _allMoods
                    .where(
                        (m) => isSameDay(DateTime.parse(m.date), selectedDay))
                    .toList();
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final dayMoods = _allMoods
                    .where((m) => isSameDay(DateTime.parse(m.date), date))
                    .toList();
                if (dayMoods.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: Text(dayMoods.first.mood,
                        style: const TextStyle(fontSize: 12)),
                  );
                }
                return null;
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        InsightScreen(selectedDate: _selectedDay),
                  ),
                );
              },
              icon: const Icon(Icons.bar_chart_rounded),
              label: Text(
                  "Lihat Analisis ${DateFormat('d MMMM').format(_selectedDay)}"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.blue.shade700,
              ),
            ),
          ),
          Expanded(
            child: _selectedEvents.isEmpty
                ? const Center(child: Text("Tidak ada catatan pada hari ini"))
                : ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      final m = _selectedEvents[index];
                      return ListTile(
                        leading:
                            Text(m.mood, style: const TextStyle(fontSize: 30)),
                        title: Text(m.category),
                        subtitle: Text(m.date.split('T')[1].substring(0, 5)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
