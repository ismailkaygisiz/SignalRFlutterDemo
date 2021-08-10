import 'package:flutter/material.dart';
import 'package:flutter_ui/core/models/user/userModel.dart';
import 'package:flutter_ui/core/utilities/dependencyResolver.dart';
import 'package:flutter_ui/models/messageModel.dart';
import 'package:flutter_ui/pages/main/userDetailPage/userDetailComponent.dart';
import 'package:flutter_ui/pages/main/userListPage/userListUI.dart';

class UserDetail extends StatefulWidget {
  final userId;
  const UserDetail({Key key, this.userId}) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail>
    with UserDetailComponent, WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;
  var controller = TextEditingController();
  var scrollController = ScrollController();
  var txtController = TextEditingController();
  UserModel user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    getUser(widget.userId).then((value) {
      if (targetUser == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserListUI()),
          (route) => false,
        );
      }
    });

    tokenService.getUserWithJWT().then((value) {
      user = value;
      getUserMessages(widget.userId, user.id);
    });

    signalRService.on("connectedMessage", (arguments) {
      print(arguments.first);
    });

    signalRService.on("disconnectedMessage", (arguments) {
      print(arguments.first);
    });

    signalRService.on("receiveMessage", (arguments) async {
      await getUserMessages(widget.userId, user.id);

      setState(() {
        scrollController.jumpTo(scrollController.position.maxScrollExtent + 75);
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (mounted) {
      setState(() {
        _lastLifecycleState = state;
      });
    }

    if (_lastLifecycleState == AppLifecycleState.paused) {
      if (signalRService.getHubConnection() != null) {
        await signalRService.invoke(
          "Disconnect",
          [signalRService.getHubConnection().connectionId],
        );
      }
    }

    if (_lastLifecycleState == AppLifecycleState.resumed) {
      await signalRService.start("myhub");
      var tokenUser = await tokenService.getUserWithJWT();
      await signalRService.invoke("Connect", [tokenUser.id]);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return targetUser != null && messages != null
        ? Scaffold(
            appBar: AppBar(
              title: Text(targetUser.firstName),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  ListView.separated(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      bool poster =
                          messages[index].thunderUserId == targetUser.id;
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
                      return SizedBox();
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
