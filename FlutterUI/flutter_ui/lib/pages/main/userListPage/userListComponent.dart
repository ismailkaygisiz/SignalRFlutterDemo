import 'package:flutter_ui/core/models/user/userModel.dart';
import 'package:flutter_ui/core/utilities/component.dart';
import 'package:flutter_ui/core/utilities/dependencyResolver.dart';

class UserListComponent implements Component {
  List<UserModel> users;

  Future<void> getAllUsers() async {
    var response = await userService.getAll();
    if (!validationService.showErrors(response.jsonData)) {
      users = response.data;

      var user = await tokenService.getUserWithJWT();
      users.remove(users.firstWhere((element) => element.id == user.id));
    }

    whenComplete();
  }

  @override
  void whenComplete() {
    // TODO: implement whenComplete
  }
}
