import 'package:absensi_glagahwangi/data/repository/event_repository.dart';
import 'package:absensi_glagahwangi/presentation/blocs/AppBlocObserver.dart';
import 'package:absensi_glagahwangi/presentation/pages/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repository/auth_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authRepository = AuthRepository();
  final eventRepository = EventRepository();
  await authRepository.user.first;

  runApp(App(
    authRepository: authRepository, eventRepository: eventRepository,
  ));
}
