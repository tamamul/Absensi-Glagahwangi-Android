import '../../data/model/dinas_model.dart';

class Dinas {
  final String id;
  final String uid;
  final String description;
  final String date;
  final String type;
  final String file;
  final String status;
  final bool checkedByAdmin;
  final DateTime createdTimestamp;

  const Dinas({
    required this.id,
    required this.uid,
    required this.description,
    required this.date,
    required this.type,
    required this.file,
    required this.status,
    required this.checkedByAdmin,
    required this.createdTimestamp,
  });

  factory Dinas.fromModel(DinasModel model) {
    return Dinas(
      id: model.id,
      uid: model.uid,
      description: model.description,
      date: model.date,
      type: model.type,
      file: model.file,
      status: model.status,
      checkedByAdmin: model.checkedByAdmin,
      createdTimestamp: model.createdTimestamp.toDate(),
    );
  }

  Dinas copyWith({
    String? uid,
    String? description,
    String? date,
    String? type,
    String? file,
    String? status,
    bool? checkedByAdmin,
    DateTime? createdTimestamp,
  }) {
    return Dinas(
      id: id,
      uid: uid ?? this.uid,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      file: file ?? this.file,
      status: status ?? this.status,
      checkedByAdmin: checkedByAdmin ?? this.checkedByAdmin,
      createdTimestamp: createdTimestamp ?? this.createdTimestamp,
    );
  }
}
