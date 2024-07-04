import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../domain/entity/attendance.dart';


class AttendancePieChart extends StatefulWidget {
  final List<AttendanceEntity> attendanceList;

  const AttendancePieChart(this.attendanceList, {super.key});

  @override
  _AttendancePieChartState createState() => _AttendancePieChartState();
}

class _AttendancePieChartState extends State<AttendancePieChart> {
  int touchedIndex = -1;

  Map<String, int> _statusCount = {
    'absen': 0,
    'alfa': 0,
    'izin': 0,
    'dinas': 0,
  };

  String _selectedMonth = DateFormat.MMMM().format(DateTime.now());
  String _selectedYear = DateFormat.y().format(DateTime.now());

  final List<String> _months = List.generate(12, (index) => DateFormat.MMMM().format(DateTime(0, index + 1)));
  final List<String> _years = List.generate(10, (index) => (DateTime.now().year - index).toString());

  @override
  void initState() {
    super.initState();
    _filterAttendanceData();
  }

  void _filterAttendanceData() {
    _statusCount = {
      'absen': 0,
      'alfa': 0,
      'izin': 0,
      'dinas': 0,
    };

    for (var attendance in widget.attendanceList) {
      DateTime date = DateTime.parse(attendance.date);
      String month = DateFormat.MMMM().format(date);
      String year = DateFormat.y().format(date);

      if (month == _selectedMonth && year == _selectedYear) {
        if (_statusCount.containsKey(attendance.attendanceStatus)) {
          _statusCount[attendance.attendanceStatus] =
              _statusCount[attendance.attendanceStatus]! + 1;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int total = _statusCount.values.fold(0, (a, b) => a + b);

    return Container(
      height: 380,
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Bagan Kehadiran",
                style: TextStyle(
                  fontFamily: "Manrope",
                  color: ColorPalette.mainText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 20),
              DropdownButton<String>(
                value: _selectedMonth,
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                style: const TextStyle(
                  fontFamily: "Manrope",
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMonth = newValue!;
                    _filterAttendanceData();
                  });
                },
                items: _months.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedYear,
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                style: const TextStyle(
                  fontFamily: "Manrope",
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedYear = newValue!;
                    _filterAttendanceData();
                  });
                },
                items: _years.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 70,
                      sections: _showingSections(total),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildIndicators(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(int total) {
    final List<String> statusKeys = ['absen', 'alfa', 'izin', 'dinas'];
    final List<Color> colors = [
      ColorPalette.absen,
      ColorPalette.alfa,
      ColorPalette.izin,
      ColorPalette.dinas
    ];

    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 60.0 : 50.0;
      final double value = _statusCount[statusKeys[i]]!.toDouble();
      final double percentage = value / total * 100;

      return PieChartSectionData(
        color: colors[i],
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: const TextStyle(
          fontFamily: "Manrope",
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      );
    });
  }

  List<Widget> _buildIndicators() {
    final List<String> statusKeys = ['absen', 'alfa', 'izin', 'dinas'];
    final List<Color> colors = [
      ColorPalette.absen,
      ColorPalette.alfa,
      ColorPalette.izin,
      ColorPalette.dinas
    ];

    return List<Widget>.generate(4, (i) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Indicator(
          color: colors[i],
          text: statusKeys[i],
          count: _statusCount[statusKeys[i]]!,
          isSquare: true,
        ),
      );
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final int count;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.count,
    required this.isSquare,
    this.size = 42,
    this.textColor = const Color(0xff505050),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 2,
      height: size * 0.8,
      decoration: BoxDecoration(
        shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
        color: color.withAlpha(127),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontFamily: "Manrope",
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              count.toString(),
              style: TextStyle(
                fontFamily: "Manrope",
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
