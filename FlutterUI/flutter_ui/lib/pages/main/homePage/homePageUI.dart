import 'package:flutter/material.dart';
import 'package:flutter_ui/core/models/user/loginModel.dart';
import 'package:flutter_ui/core/utilities/dependencyResolver.dart';
import 'package:flutter_ui/environments/api.dart';
import 'package:flutter_ui/pages/main/homePage/homePageComponent.dart';
import 'package:flutter_ui/pages/main/userListPage/userListUI.dart';

class HomePageUI extends StatefulWidget {
  const HomePageUI({Key key}) : super(key: key);

  @override
  _HomePageUIState createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI> with HomePageComponent {
  var controller1 = TextEditingController();
  var controller2 = TextEditingController();
  bool value = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    value = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authService.isAuthenticated().then((value) {
      if (value) {
        print(value);
        this.value = false;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserListUI()),
          (route) => false,
        );
      }

      this.value = !value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    authService.isAuthenticated().then((value) {
      if (value) {
        print(value);
        this.value = false;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserListUI()),
          (route) => false,
        );
      }

      this.value = !value;
    });

    return value
        ? Scaffold(
            appBar: AppBar(
              title: Text("Giriş Yap"),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                      ),
                      controller: controller1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Şifre",
                      ),
                      controller: controller2,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                      child: SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () async {
                            var response = await authService.login(
                              LoginModel(controller1.text, controller2.text),
                            );

                            if (response.success) {
                              tokenService.setToken(response.data.token);
                              tokenService
                                  .setRefreshToken(response.data.refreshToken);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserListUI(),
                                  ),
                                  (route) => false);
                            } else {
                              print("HATA");
                            }
                          },
                          child: Text("Giriş Yap"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
        : Scaffold();
  }

  @override
  void whenComplete() {
    setState(() {});
  }
}
