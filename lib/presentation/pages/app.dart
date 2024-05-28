import 'package:absensi_glagahwangi/data/repository/auth_repository.dart';
import 'package:absensi_glagahwangi/data/repository/event_repository.dart';
import 'package:absensi_glagahwangi/presentation/blocs/holiday/event_bloc.dart';
import 'package:absensi_glagahwangi/presentation/blocs/maps/maps_bloc.dart';
import 'package:absensi_glagahwangi/presentation/blocs/user/user_bloc.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/map_repository.dart';
import '../../data/repository/user_repository.dart';
import '../blocs/auth/auth_bloc.dart';
import '../config/routes.dart';

class App extends StatelessWidget {
  final AuthRepository _authRepository;
  final EventRepository _eventRepository;
  final UserRepository _userRepository;
  final MapRepository _mapRepository;

  const App({
    Key? key,
    required AuthRepository authRepository,
    required EventRepository eventRepository,
    required UserRepository userRepository,
    required MapRepository mapRepository,
  })  : _authRepository = authRepository,
        _eventRepository = eventRepository,
        _userRepository = userRepository,
        _mapRepository = mapRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _eventRepository),
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _mapRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: _authRepository),
          ),
          BlocProvider<EventBloc>(
            create: (context) => EventBloc(eventRepository: _eventRepository),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(userRepository: _userRepository),
          ),
          BlocProvider<MapsBloc>(
            create: (context) => MapsBloc(_mapRepository),
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
