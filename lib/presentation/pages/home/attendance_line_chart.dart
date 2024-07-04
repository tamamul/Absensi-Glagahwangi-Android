import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import '../../../domain/entity/attendance.dart';

class AttendanceLineChart extends StatefulWidget {
  final List<AttendanceEntity> attendanceList;

  const AttendanceLineChart(this.attendanceList, {super.key});

  @override
  State<StatefulWidget> createState() => AttendanceLineChartState();
}

class AttendanceLineChartState extends State<AttendanceLineChart> {
  String _selectedYear = DateFormat.y().format(DateTime.now());

  final List<String> _years = List.generate(5, (index) => (DateTime.now().year - index).toString());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bagan Perbandingan",
                style: TextStyle(
                  fontFamily: "Manrope",
                  color: ColorPalette.mainText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _buildYearPicker(),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                maxX: 12,
                maxY: 25,
                minX: 1,
                minY: 0,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 5,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Colors.black, width: 1),
                    bottom: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateSpots('absen'),
                    isCurved: true,
                    barWidth: 4,
                    color: ColorPalette.absen,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: _generateSpots('alfa'),
                    isCurved: true,
                    barWidth: 4,
                    color: ColorPalette.alfa,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: _generateSpots('izin'),
                    isCurved: true,
                    barWidth: 4,
                    color: ColorPalette.izin,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: _generateSpots('dinas'),
                    isCurved: true,
                    barWidth: 4,
                    color: ColorPalette.dinas,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearPicker() {
    return DropdownButton<String>(
      value: _selectedYear,
      onChanged: (String? newValue) {
        setState(() {
          _selectedYear = newValue!;
        });
      },
      items: _years.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: "Manrope",
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
      dropdownColor: Colors.white,
      style: const TextStyle(
        fontFamily: "Manrope",
        color: Colors.black,
        fontSize: 16,
      ),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      isExpanded: false,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 5) {
      text = '5';
    } else if (value == 10) {
      text = '10';
    } else if (value == 15) {
      text = '15';
    } else if (value == 20) {
      text = '20';
    } else if (value == 25) {
      text = '25';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final Widget text = Text(
      months[value.toInt() - 1],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4, // margin top
      child: text,
    );
  }

  List<FlSpot> _generateSpots(String status) {
    List<AttendanceEntity> attendanceList = widget.attendanceList;

    Map<int, double> monthlyCounts = {};

    for (var attendance in attendanceList) {
      DateTime date = DateTime.parse(attendance.date);
      int month = date.month;
      String year = DateFormat.y().format(date);

      if (year == _selectedYear && attendance.attendanceStatus == status) {
        monthlyCounts[month] = (monthlyCounts[month] ?? 0) + 1;
      }
    }

    List<FlSpot> spots = [];
    for (int i = 1; i <= 12; i++) {
      spots.add(FlSpot(i.toDouble(), monthlyCounts[i] ?? 0));
    }

    return spots;
  }
}
