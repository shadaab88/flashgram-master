import 'package:flutter/material.dart';

class CheckMail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verification email sent !",
          style: TextStyle(color: Colors.deepPurple),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 30.0),
        child: Container(
          height: 100.0,
          width: 400.0,
          child: Text(
            "Please check you email and follow the instructions to reset your password.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
