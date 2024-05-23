import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/event_repository.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;

  EventBloc({required this.eventRepository}) : super(EventInitial()) {
    on<FetchEvents>(_onFetchEvents);
  }

  void _onFetchEvents(FetchEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final events = await eventRepository.fetchEvents();
      for (var event in events) {
        print('EEEEEEEEEEEEEEEEEEEE: ${event.name}');
      }
      emit(EventLoaded(events: events));
    } catch (e) {
      print('Error: $e');
      emit(EventError(message: e.toString()));
    }
  }
}
