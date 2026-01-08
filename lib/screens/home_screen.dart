import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/mood.dart';
import 'add_mood_screen.dart';
import 'calendar_history_screen.dart';
import 'history_screen.dart';
import 'insight_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    final List<Mood> moods = await DatabaseHelper.instance.getAllMoods();
    if (moods.isEmpty) {
      setState(() => _streak = 0);
      return;
    }

    int streak = 0;
    DateTime today = DateTime.now();
    DateTime checkDate = DateTime(today.year, today.month, today.day);

    final dates = moods
        .map((m) => DateTime.parse(m.date))
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList();
    dates.sort((a, b) => b.compareTo(a));

    if (dates.first.isBefore(checkDate.subtract(const Duration(days: 1)))) {
      streak = 0;
    } else {
      for (int i = 0; i < dates.length; i++) {
        if (i == 0 ||
            dates[i] == dates[i - 1].subtract(const Duration(days: 1))) {
          streak++;
        } else {
          break;
        }
      }
    }
    setState(() => _streak = streak);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Tracker'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStreakCard(),
            const SizedBox(height: 20),
            _buildDailyInsightInfo(context),
            const SizedBox(height: 20),
            const Text("Menu Utama",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            _buildMenuButton(context, 'Tambah Mood', Icons.add_reaction,
                Colors.orange, const AddMoodScreen()),
            _buildMenuButton(context, 'Kalender & Detail', Icons.calendar_month,
                Colors.green, const CalendarHistoryScreen()),
            _buildMenuButton(context, 'Riwayat Lengkap', Icons.history,
                Colors.blue, const HistoryScreen()),
            _buildMenuButton(context, 'Insight & Statistik', Icons.insights,
                Colors.purple, const InsightScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(colors: [Colors.blueAccent, Colors.blue]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Icon(Icons.local_fire_department,
              color: Colors.orange, size: 50),
          Text(
            '$_streak Hari Beruntun!',
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyInsightInfo(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const InsightScreen())),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.purple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
        ),
        child: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.purple),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Insight Harian Aktif!",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Statistik harianmu akan ter-reset besok pagi.",
                      style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon,
      Color color, Widget screen) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
          _loadStreak();
        },
      ),
    );
  }
}
