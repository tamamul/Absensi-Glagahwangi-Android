import 'package:absensi_glagahwangi/presentation/blocs/holiday/event_event.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/event_repository.dart';
import '../../blocs/holiday/event_bloc.dart';
import '../../blocs/holiday/event_state.dart';

class Holiday extends StatelessWidget {
  const Holiday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventBloc(eventRepository: EventRepository())..add(FetchEvents()),
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
            child: BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is EventLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is EventLoaded) {
                  return Column(
                    children: state.events.map((event) {
                      return Container(
                        width: double.infinity,
                        height: 70,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorPalette.stroke_menu),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                event.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Manrope",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                event.date.toString(), // Format the date as needed
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Manrope",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                } else if (state is EventError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return Center(child: Text('No events found'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
