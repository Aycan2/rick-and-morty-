import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../wiewmodels/favorite_view_model.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favVM = context.watch<FavoriteViewModel>();
    final favoriteCount = favVM.favorites.length;

    final speciesData = _calculateDistribution(
        favVM.favorites.map((c) => c.species));
    final statusData = _calculateDistribution(
        favVM.favorites.map((c) => c.status));

    return Scaffold(
      appBar: AppBar(title: Text('İstatistikler')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Favori Sayısı: $favoriteCount',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 30),

              Text(
                'Favorilerde Tür Dağılımı',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              SizedBox(height: 200, child: PieChart(_buildPieData(speciesData))),
              SizedBox(height: 16),
              _buildLegend(speciesData),

              SizedBox(height: 40),

              Text(
                'Favorilerde Durum Dağılımı',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              SizedBox(height: 200, child: PieChart(_buildPieData(statusData))),
              SizedBox(height: 16),
              _buildLegend(statusData),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, int> _calculateDistribution(Iterable<String> items) {
    final Map<String, int> distribution = {};
    for (var item in items) {
      final key = item.toLowerCase();
      distribution[key] = (distribution[key] ?? 0) + 1;
    }
    return distribution;
  }

  PieChartData _buildPieData(Map<String, int> data) {
    final sections = data.entries.map((entry) {
      return PieChartSectionData(
        color: _colorForLabel(entry.key),
        value: entry.value.toDouble(),
        showTitle: false,
        radius: 70,
      );
    }).toList();

    return PieChartData(
      sections: sections,
      sectionsSpace: 2,
      centerSpaceRadius: 40,
    );
  }

  Widget _buildLegend(Map<String, int> data) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: data.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              color: _colorForLabel(entry.key),
            ),
            SizedBox(width: 6),
            Text('${entry.key} (${entry.value})'),
          ],
        );
      }).toList(),
    );
  }

  Color _colorForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      case 'unknown':
        return Colors.grey;
      case 'human':
        return Colors.blue;
      case 'alien':
        return Colors.purple;
      case 'robot':
        return Colors.orange;
      case 'humanoid':
        return Colors.teal;
      case 'animal':
        return Colors.brown;
      default:
        return Colors.black54;
    }
  }
}
