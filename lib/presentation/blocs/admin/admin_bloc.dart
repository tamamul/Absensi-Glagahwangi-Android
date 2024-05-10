import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absensi_glagahwangi/data/repository/admin_repository.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _adminRepository;

  AdminBloc({required AdminRepository adminRepository})
      : _adminRepository = adminRepository,
        super(const AdminState());

  Stream<AdminState> mapEventToState(AdminEvent event) async* {
    if (event is AuthSignupRequested) {
      yield* _mapAuthSignupRequestedToState(event);
    }
  }

  Stream<AdminState> _mapAuthSignupRequestedToState(AuthSignupRequested event) async* {
    yield state.copyWith(status: AdminStatus.loading);
    try {
      await _adminRepository.signup(
        email: event.email,
        password: event.password,
        name: event.name,
        role: event.role,
      );
      await Future.delayed(const Duration(seconds: 2));
      yield state.copyWith(status: AdminStatus.loaded);
    } catch (e) {
      yield state.copyWith(status: AdminStatus.error, message: 'Error signing up: $e');
    }
  }
}