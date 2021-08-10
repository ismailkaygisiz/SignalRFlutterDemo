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
    // TODO: implement initState
    super.initState();
    getAllUsers();
    WidgetsBinding.instance.addObserver(this);
    signalRService.start("myhub").then((value) {
      tokenService.getUserWithJWT().then((value) {
        if (mounted) {
          setState(() {
            user = value;
          });
        }
        signalRService.invoke("Connect", [value.id]).then((value) {});
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lastLifecycleState = state;
    if (mounted) {
      setState(() {});
    }

    if (_lastLifecycleState == AppLifecycleState.paused) {
      print(_lastLifecycleState);
      if (signalRService.getHubConnection() != null) {
        signalRService.invoke(
            "Disconnect", [signalRService.getHubConnection().connectionId]);
      }
    }

    if (_lastLifecycleState == AppLifecycleState.resumed) {
      signalRService.start("myhub").then((value) {
        tokenService.getUserWithJWT().then((value) {
          signalRService.invoke("Connect", [value.id]).then((value) {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    signalRService.on("connectedMessage", (arguments) {
      print(arguments[0]);
    });

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
                    onTap: () {
                      Navigator.push(
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
    // TODO: implement whenComplete
    if (mounted) {
      setState(() {});
    }
  }
}
