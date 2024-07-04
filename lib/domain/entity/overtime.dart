import '../../data/model/overtime_model.dart';

class Overtime {
  final String id;
  final String uid;
  final String date;
  final String status;
  final String finish;
  final int duration;

  const Overtime({
    required this.id,
    required this.uid,
    required this.date,
    required this.status,
    required this.finish,
    required this.duration,
  });

  factory Overtime.fromModel(OvertimeModel model) {
    return Overtime(
      id: model.id,
      uid: model.uid,
      date: model.date,
      status: model.status,
      finish: model.finish,
      duration: model.duration,
    );
  }

  Overtime copyWith({
    String? uid,
    String? date,
    String? status,
    String? description,
    int? duration,
  }) {
    return Overtime(
      id: id,
      uid: uid ?? this.uid,
      date: date ?? this.date,
      status: status ?? this.status,
      finish: description ?? finish,
      duration: duration ?? this.duration,
    );
  }
}
