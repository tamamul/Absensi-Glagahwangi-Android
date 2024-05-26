import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/event_repository.dart';
import '../../../domain/entity/event.dart';
part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;

  EventBloc({required this.eventRepository}) : super(EventInitial()) {
    on<FetchEvents>(_onFetchEvents);
  }

  void _onFetchEvents(FetchEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final events = await eventRepository.fetchEvents();
      emit(EventLoaded(events: events));
    } catch (e) {
      print('Error: $e');
      emit(EventError(message: e.toString()));
    }
  }
}
