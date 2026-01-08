import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class InsightScreen extends StatefulWidget {
  final DateTime? selectedDate; // Parameter opsional dari kalender
  const InsightScreen({super.key, this.selectedDate});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String targetDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Jika ada tanggal dari kalender, gunakan itu. Jika tidak, gunakan hari ini.
    DateTime dateToUse = widget.selectedDate ?? DateTime.now();
    targetDate = DateFormat('yyyy-MM-dd').format(dateToUse);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis Mood'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Hari Ini"),
            Tab(text: "seluruh mood"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatView(targetDate), // Berdasarkan tanggal pilihan/hari ini
          _buildStatView(null), // Seluruh data permanen
        ],
      ),
    );
  }

  Widget _buildStatView(String? dateFilter) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dateFilter != null
          ? DatabaseHelper.instance.getMoodStatsByDate(dateFilter)
          : DatabaseHelper.instance.getMoodStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(dateFilter != null);
        }

        final stats = snapshot.data!;
        // Perbaikan Warning: Variabel total sekarang digunakan di dalam UI
        int total = stats.fold(0, (sum, item) => sum + (item['total'] as int));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                dateFilter != null
                    ? "Analisis untuk Tanggal: $dateFilter"
                    : "Analisis Seluruh Jurnal",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Penggunaan variabel 'total' untuk menghilangkan warning
              Text(
                "Total: $total Catatan Mood",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sections: _buildChartSections(stats),
                    centerSpaceRadius: 50,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Rincian Mood:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              ...stats.map((item) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Text(item['mood'],
                          style: const TextStyle(fontSize: 24)),
                      title: Text("Mood ${item['mood']}"),
                      trailing: Text("${item['total']}x",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isFiltered) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.query_stats, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text(
            isFiltered
                ? "Tidak ada data mood pada tanggal ini"
                : "Database jurnal masih kosong",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(
      List<Map<String, dynamic>> stats) {
    final List<Color> colors = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.redAccent,
      Colors.purpleAccent
    ];

    return List.generate(stats.length, (i) {
      final value = (stats[i]['total'] as int).toDouble();
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: value,
        title: stats[i]['mood'],
        radius: 60,
        titleStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });
  }
}
