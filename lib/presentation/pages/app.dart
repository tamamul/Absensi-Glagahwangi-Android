import 'package:absensi_glagahwangi/data/repository/auth_repository.dart';
import 'package:absensi_glagahwangi/data/repository/event_repository.dart';
import 'package:absensi_glagahwangi/presentation/blocs/holiday/event_bloc.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../config/routes.dart';

class App extends StatelessWidget {
  final AuthRepository _authRepository;
  final EventRepository _eventRepository;

  const App({
    Key? key,
    required AuthRepository authRepository,
    required EventRepository eventRepository,
  })  : _authRepository = authRepository,
        _eventRepository = eventRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _eventRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: _authRepository),
          ),
          BlocProvider<EventBloc>(
            create: (context) => EventBloc(eventRepository: _eventRepository),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlowBuilder<AuthStatus>(
        state: context.select((AuthBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
