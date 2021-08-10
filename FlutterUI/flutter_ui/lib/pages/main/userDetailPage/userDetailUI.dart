import 'package:flutter/material.dart';
import 'package:flutter_ui/core/models/user/userModel.dart';
import 'package:flutter_ui/core/utilities/dependencyResolver.dart';
import 'package:flutter_ui/models/messageModel.dart';
import 'package:flutter_ui/pages/main/userDetailPage/userDetailComponent.dart';
import 'package:flutter_ui/pages/main/userListPage/userListUI.dart';
import 'package:http/http.dart';

class UserDetail extends StatefulWidget {
  final userId;
  const UserDetail({Key key, this.userId}) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> with UserDetailComponent {
  var controller = TextEditingController();
  String message = "";
  UserModel user1;
  var scrollController = ScrollController();
  var txtController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser(widget.userId).then((value) {
      if (user == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => UserListUI()),
            (route) => false);
      }
    });

    tokenService.getUserWithJWT().then((value) {
      user1 = value;
      getUserMessages(widget.userId, user1.id);
    });

    signalRService.on("receiveMessage", (arguments) async {
      await getUserMessages(widget.userId, user1.id);
      messages.forEach((element) {
        print(element.messageValue);
      });

      print(messages);
      print("I");
      scrollController.jumpTo(scrollController.position.maxScrollExtent + 75);
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return user != null && messages != null
        ? Scaffold(
            appBar: AppBar(
              title: Text(user.firstName),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  ListView.separated(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      bool poster = messages[index].thunderUserId == user.id;
                      return Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: poster
                              ? Alignment.topLeft
                              : Alignment.topRight, // (SingleLineIf)
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: poster
                                    ? Colors.grey.shade200
                                    : Colors.blue[200] // (SingleLineIf)
                                ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              messages[index].messageValue,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, i) {
                      return Divider(
                        thickness: 2,
                      );
                    },
                  ),

                  //

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 10, 30),
                      child: Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 50,
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Mesajınızı Girin",
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: ElevatedButton(
                              onPressed: () async {
                                var message = controller.text;
                                if (message != "") {
                                  var user =
                                      await tokenService.getUserWithJWT();

                                  await signalRService.invoke("SendMessage",
                                      [user.id, widget.userId, message]);

                                  await getUserMessages(widget.userId, user.id);
                                  controller.text = "";
                                }
                              },
                              child: Text("Gönder"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : Scaffold();
  }

  @override
  void whenComplete() {
    if (mounted) {
      setState(() {});
    }
  }
}
