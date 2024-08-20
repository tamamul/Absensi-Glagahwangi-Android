import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import '../../blocs/attendance/overtime/overtime_data_bloc.dart';

class OvertimeDataWidget extends StatefulWidget {
  final OvertimeDataBloc overtimeDataBloc;
  final String id;

  const OvertimeDataWidget({
    super.key,
    required this.overtimeDataBloc,
    required this.id,
  });

  @override
  State<StatefulWidget> createState() => OvertimeDataWidgetState();
}

class OvertimeDataWidgetState extends State<OvertimeDataWidget> {
  String _selectedMonth = DateFormat.MMMM().format(DateTime.now());
  String _selectedYear = DateFormat.y().format(DateTime.now());

  final List<String> _months = List.generate(
      12, (index) => DateFormat.MMMM().format(DateTime(0, index + 1)));
  final List<String> _years = List.generate(10, (index) =>
      (DateTime.now().year - index).toString());

  @override
  void didUpdateWidget(covariant OvertimeDataWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OvertimeDataBloc, OvertimeDataState>(
      bloc: widget.overtimeDataBloc,
      builder: (context, state) {
        bool isLoading = state is OvertimeDataLoading;
        String duration = '0';
        if (state is OvertimeDurationFetched) {
          duration = state.duration.toString();
        }
        return Container(
          height: 140,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Jam Lembur Bulan",
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
                        _fetchOvertimeDuration();
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
                        _fetchOvertimeDuration();
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildOvertimeCircle(duration, isLoading),
                  const SizedBox(width: 10),
                  const Text(
                    "Jam Lembur Bulan Ini",
                    style: TextStyle(
                      fontFamily: "Manrope",
                      color: ColorPalette.mainText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOvertimeCircle(String duration, bool isLoading) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: ColorPalette.absen,
      ),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        )
            : Text(
          duration,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: "Manrope",
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _fetchOvertimeDuration() {
    final int monthIndex = _months.indexOf(_selectedMonth) + 1;
    final formattedMonth = monthIndex.toString().padLeft(2, '0');
    final formattedDate = '$_selectedYear-$formattedMonth';
    widget.overtimeDataBloc.add(GetOvertimeDurationForMonth(widget.id, formattedDate));
  }
}
