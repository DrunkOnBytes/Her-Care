import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../signin.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double wd, ht;

  void signIn() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Get.snackbar("", "",
            titleText: Row(
              children: [
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor),
                ),
                Text(
                  '    Logging In.....',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            messageText: Text(
              "               Please wait...",
              style: TextStyle(color: Colors.white),
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color(0xfff06292),
            duration: Duration(days: 1));
        try {
          signInWithGoogle(context).then((val) {
            if (val == "Signed In") {
              Get.back();
              Get.offNamed('/home');
            } else {
              Get.back();
              Get.snackbar("Unable to sign in now.", "Try Again Later.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2));
            }
          });
        } catch (e) {
          Get.back();
        }
      }
    } on SocketException catch (_) {
      Get.snackbar("No Internet Connection.", "Try Again Later.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2));
    }
  }

  void alreadySignedIn() async {
    if (await googleSignIn.isSignedIn()) {
      signIn();
    }
  }

  @override
  void initState() {
    alreadySignedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wd = MediaQuery.of(context).size.width;
    ht = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: ht,
            width: wd,
            color: Color(0xfffbdbf4),
          ),
          Positioned(
            top: ht * 0.1,
            child: Container(
              height: ht * 0.9,
              width: wd,
              color: Color(0xff009c96),
            ),
          ),
          Positioned(
            top: ht * 0.1,
            child: Image.asset(
              'images/background.png',
              width: wd,
            ),
          ),
          Positioned(
            bottom: ht*0.12,
            child: Container(
              width: wd,
              height: ht * 0.27,
              padding: EdgeInsets.fromLTRB(10,0,10,20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Her Care', style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),),
                      SizedBox(height:8,),
                      Text(
                        'The best protection any woman can have.....is courage.', style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),),
                    ],
                  ),
                  RaisedButton(
                    splashColor: Color(0xffff80ab),
                    color: Color(0xffffafef),
                    onPressed: () => signIn(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(color: Colors.black38, width: 0.5)),
                    highlightElevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "images/glogo.png",
                            height: 35,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600),
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
