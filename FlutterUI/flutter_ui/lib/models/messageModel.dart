import 'package:flutter_ui/core/models/entity.dart';

@entity
class MessageModel {
  int id;
  int thunderUserId;
  int receiverId;
  String messageValue;
  DateTime messageDate;

  MessageModel(
    this.id,
    this.thunderUserId,
    this.receiverId,
    this.messageValue,
    this.messageDate,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      json["id"] as int,
      json["thunderUserId"] as int,
      json["receiverId"] as int,
      json["messageValue"] as String,
      DateTime.parse(json["messageDate"] as String),
    );
  }
}
