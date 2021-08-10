import 'dart:convert';

import 'package:flutter_ui/core/models/entity.dart';

@entity
class MessageAddModel {
  int thunderUserId;
  String messageValue;

  MessageAddModel(this.thunderUserId, this.messageValue);

  String toJson() {
    return json.encode({
      "thunderUserId": thunderUserId,
      "messageValue": messageValue,
    });
  }
}
