import 'package:flutter_ui/core/models/user/userModel.dart';
import 'package:flutter_ui/core/utilities/component.dart';
import 'package:flutter_ui/core/utilities/dependencyResolver.dart';
import 'package:flutter_ui/models/messageModel.dart';

class UserDetailComponent implements Component {
  UserModel user;
  List<MessageModel> messages;

  Future<void> getUser(int userId) async {
    var response = await userService.getById(userId);

    if (!validationService.showErrors(response.jsonData)) {
      user = response.data;
    }

    whenComplete();
  }

  Future<void> getUserMessages(int userId, int receiverId) async {
    var response =
        await messageService.getByUserAndReceiver(userId, receiverId);

    if (!validationService.showErrors(response.jsonData)) {
      print(response.jsonData);
      messages = response.data;
    }

    whenComplete();
  }

  @override
  void whenComplete() {
    // TODO: implement whenComplete
  }
}
