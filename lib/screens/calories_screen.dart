import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CaloriesScreen extends StatelessWidget {
  const CaloriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calories")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔥 Calories Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text("Burned Today", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 10),
                  Text(
                    "480 kcal",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 📊 Graph
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),

                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: const [
                        FlSpot(0, 1),
                        FlSpot(1, 2),
                        FlSpot(2, 1.5),
                        FlSpot(3, 3),
                        FlSpot(4, 2.5),
                        FlSpot(5, 4),
                      ],
                      color: Colors.orange,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}