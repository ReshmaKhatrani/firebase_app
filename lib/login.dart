import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_future.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
  ],
);

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      setPrefs();
      if (_currentUser != null) {
        print("$_currentUser");
      }
    });
    // _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() {
    return _googleSignIn.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _handleSignOut(),
              child: Text("Logout"),
            ),
            if (size.width > 700)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${_currentUser?.email}  "),
                  Text("${_currentUser?.displayName}"),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("${_currentUser?.email}"),
                  Text("${_currentUser?.displayName}"),
                ],
              ),
            GestureDetector(
              onTap: () => _handleSignIn(),
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: SvgPicture.asset(
                  'assets/google.svg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("IS_LOGGED_IN", true);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyFuture()));
  }
}
