import '../../data/model/permission_model.dart';

class Permissions {
  final String id;
  final String uid;
  final String description;
  final String type;
  final String status;
  final String date;
  final String file;
  final bool checkedByAdmin;
  final DateTime createdTimestamp;

  const Permissions({
    required this.id,
    required this.uid,
    required this.description,
    required this.type,
    required this.status,
    required this.date,
    required this.file,
    required this.checkedByAdmin,
    required this.createdTimestamp,
  });

  factory Permissions.fromModel(PermissionsModel model) {
    return Permissions(
      id: model.id,
      uid: model.uid,
      description: model.description,
      type: model.type,
      status: model.status,
      date: model.date,
      file: model.file,
      checkedByAdmin: model.checkedByAdmin,
      createdTimestamp: model.createdTimestamp.toDate(),
    );
  }

  Permissions copyWith({
    String? uid,
    String? description,
    String? type,
    String? status,
    String? date,
    String? file,
    bool? checkedByAdmin,
    DateTime? createdTimestamp,
  }) {
    return Permissions(
      id: id,
      uid: uid ?? this.uid,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      date: date ?? this.date,
      file: file ?? this.file,
      checkedByAdmin: checkedByAdmin ?? this.checkedByAdmin,
      createdTimestamp: createdTimestamp ?? this.createdTimestamp,
    );
  }
}
