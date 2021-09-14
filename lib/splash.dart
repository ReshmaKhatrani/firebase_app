import 'package:fire_app/login.dart';
import 'package:fire_app/my_future.dart';
import 'package:fire_app/product_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      getPref();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool("IS_LOGGED_IN");
    if (isLoggedIn ?? false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    }
  }
}
