import 'package:flutter/material.dart';

class MyFuture extends StatelessWidget {
  const MyFuture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: myFuture(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text("${snapshot.data}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future myFuture() => Future.delayed(
      Duration(seconds: 2), () => "This message displays lately");
}
