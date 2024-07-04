import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/holiday_repository.dart';
import '../../blocs/holiday//holiday_bloc.dart';

class HolidayMenu extends StatelessWidget {
  const HolidayMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HolidayBloc(holidayRepository: HolidayRepository())..add(FetchHoliday()),
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
            "Hari Libur",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Manrope",
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: BlocBuilder<HolidayBloc, HolidayState>(
              builder: (context, state) {
                if (state is HolidayLoading) {
                  // ignore: prefer_const_constructors
                  return Center(child: CircularProgressIndicator());
                } else if (state is HolidayLoaded) {
                  return Column(
                    children: state.holidays.map((event) {
                      return Container(
                        width: double.infinity,
                        height: 70,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorPalette.strokeMenu),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                event.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Manrope",
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                event.date.toString(), // Format the date as needed
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                } else if (state is HolidayError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(child: Text('No events found'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
