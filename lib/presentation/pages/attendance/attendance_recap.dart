import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart'; // Add this import
import 'dart:io'; // Add this import for File

import '../../../data/repository/attendance_repository.dart';
import '../../../utils/color_palette.dart';
import '../../blocs/attendance/attendance_data/attendance_data_bloc.dart';

class AttendanceRecap extends StatelessWidget {
  final String uid;

  const AttendanceRecap({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceDataBloc(context.read<AttendanceRepository>())
        ..add(FetchAttendanceList(uid)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Rekap Absen",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Manrope",
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.print),
              color: Colors.black,
              onPressed: () async {
                try {
                  final directory = await getExternalStorageDirectory();
                  if (directory != null) {
                    final downloadPath = Directory('/storage/emulated/0/Download');
                    final filePath = '${downloadPath.path}/attendance_recap.csv';
                    await context.read<AttendanceRepository>().exportAttendanceToCsv(uid, filePath);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('CSV exported successfully to $filePath')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Unable to access storage directory')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to export CSV: $e')),
                  );
                }
              },
            ),
          ],
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: BlocBuilder<AttendanceDataBloc, AttendanceDataState>(
            builder: (context, state) {
              if (state is AttendanceDataLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AttendanceListFetched) {
                return SingleChildScrollView(
                  child: Column(
                    children: state.attendanceList.map((attendanceData) {
                      return _buildAttendanceCard(attendanceData);
                    }).toList(),
                  ),
                );
              } else if (state is AttendanceDataFailure) {
                return Center(child: Text(state.error));
              } else {
                return const Center(child: Text("No data available."));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> attendanceData) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalette.stroke_menu),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDateCircle(attendanceData['date']),
          const VerticalDivider(
            indent: 10,
            endIndent: 10,
            color: Colors.black,
            thickness: 0.2,
          ),
          _buildInInfo(attendanceData['in']),
          const VerticalDivider(
            indent: 10,
            endIndent: 10,
            color: Colors.black,
            thickness: 0.2,
          ),
          _buildOutInfo(attendanceData['out']),
        ],
      ),
    );
  }

  Widget _buildDateCircle(String date) {
    final parts = date.split('-');
    final day = parts[2];
    final month = _getMonthName(int.parse(parts[1]));

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorPalette.circle_menu,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: "Manrope",
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              month,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: "Manrope",
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildInInfo(Map<String, dynamic> inData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 35,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorPalette.circle_menu,
              ),
              child: Icon(
                Icons.input_rounded,
                size: 20,
                color: ColorPalette.main_green,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Masuk",
              style: TextStyle(
                color: ColorPalette.secondary_text,
                fontFamily: "Manrope",
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Text(
          inData['time'],
          style: const TextStyle(
            color: Colors.black,
            fontFamily: "Manrope",
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          inData['status'],
          style: const TextStyle(
            color: Colors.black,
            fontFamily: "Manrope",
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }

  Widget _buildOutInfo(Map<String, dynamic> outData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 35,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorPalette.circle_menu,
              ),
              child: Icon(
                Icons.output_rounded,
                size: 20,
                color: ColorPalette.main_green,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Keluar",
              style: TextStyle(
                color: ColorPalette.secondary_text,
                fontFamily: "Manrope",
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Text(
          outData['time'],
          style: const TextStyle(
            color: Colors.black,
            fontFamily: "Manrope",
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Text(
          "Pulang",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Manrope",
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}
