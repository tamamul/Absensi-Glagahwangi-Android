part of 'admin_bloc.dart';

enum AdminStatus { initial, loading, loaded, error }

class AdminState extends Equatable {
  final AdminStatus status;
  final String message;

  const AdminState({
    this.status = AdminStatus.initial,
    this.message = '',
  });

  AdminState copyWith({
    AdminStatus? status,
    String? message,
  }) {
    return AdminState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
