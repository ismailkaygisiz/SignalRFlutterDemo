import 'package:flutter/material.dart';
import 'package:flutter_ui/core/models/user/loginModel.dart';
import 'package:flutter_ui/environments/api.dart';
import 'package:flutter_ui/pages/main/homePage/homePageUI.dart';
import 'core/utilities/dependencyResolver.dart';
import 'environments/environment.development.dart';
import 'main.reflectable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();
  EnvironmentDev();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;
  String _lang;
  var connection = signalRService.getHubConnection();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getTranslates();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });

    if (_lastLifecycleState == AppLifecycleState.paused) {
      if (signalRService.getHubConnection() != null) {
        signalRService.invoke(
            "Disconnect", [signalRService.getHubConnection().connectionId]);
      }
    }
  }

  void _getTranslates() {
    sessionService.get("lang").then((value) {
      _lang = value;
      translateService.getTranslates(value).then((dynamic value) {
        TRANSLATES = value["data"];
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    sessionService.get("lang").then((value) {
      if (_lang != value) {
        _getTranslates();
      }
    });

    return TRANSLATES.values.length > 0
        ? HomePageUI()
        : Scaffold(
            appBar: AppBar(
              title: Text("Loading"),
              centerTitle: true,
            ),
            body: Center(),
          );
  }
}
