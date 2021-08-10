import 'package:flutter/material.dart';
import 'package:flutter_ui/core/models/user/userModel.dart';
import 'package:flutter_ui/core/utilities/dependencyResolver.dart';
import 'package:flutter_ui/pages/main/homePage/homePageUI.dart';
import 'package:flutter_ui/pages/main/userDetailPage/userDetailUI.dart';
import 'package:flutter_ui/pages/main/userListPage/userListComponent.dart';

class UserListUI extends StatefulWidget {
  const UserListUI({Key key}) : super(key: key);

  @override
  _UserListUIState createState() => _UserListUIState();
}

class _UserListUIState extends State<UserListUI>
    with UserListComponent, WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;
  UserModel user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    getAllUsers();
    signalRService.start("myhub").then((value) {
      tokenService.getUserWithJWT().then((value) {
        user = value;
        if (mounted) setState(() {});
        signalRService.invoke("Connect", [user.id]);
      });
    });

    signalRService.on("connectedMessage", (arguments) {
      print(arguments.first);
    });

    signalRService.on("disconnectedMessage", (arguments) {
      print(arguments.first);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text("Kullanıcılar"),
            Text(user != null ? user.firstName : "")
          ],
        ),
        actions: [
          GestureDetector(
            child: Icon(Icons.logout),
            onTap: () async {
              await signalRService.invoke("Disconnect",
                  [signalRService.getHubConnection().connectionId]);
              await tokenService.removeToken();
              await tokenService.removeRefreshToken();

              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePageUI()),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: users != null
          ? SafeArea(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int indeks) {
                  return ListTile(
                    leading: Icon(Icons.person),
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserDetail(userId: users[indeks].id)));
                    },
                    trailing: Text(users[indeks].id.toString()),
                    title: Text(users[indeks].firstName),
                  );
                },
              ),
            )
          : Center(),
    );
  }

  @override
  void whenComplete() {
    if (mounted) {
      setState(() {});
    }
  }
}
