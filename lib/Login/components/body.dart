import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart' as fl;
import 'package:flutter_svg/svg.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_layout_builder/responsive_layout_builder.dart';
import 'package:techstagram/Login/components/background.dart';
import 'package:techstagram/Signup/components/or_divider.dart';
import 'package:techstagram/Signup/components/social_icon.dart';
import 'package:techstagram/Signup/signup_screen.dart';
import 'package:techstagram/components/already_have_an_account_acheck.dart';
import 'package:techstagram/components/rounded_button.dart';
import 'package:techstagram/components/text_field_container.dart';
import 'package:techstagram/resources/googlesignin.dart';
import 'package:techstagram/ui/HomePage.dart';

import '../../constants.dart';
import '../../forgotpassword.dart';

class Body extends StatefulWidget {
  final IconData icon;

  const Body({
    Key key,
    this.icon = Icons.email,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  bool _obscureText = true;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  bool success = false;

  final FocusNode _email = FocusNode();
  final FocusNode _pwd = FocusNode();

  final FirebaseAuth auth = FirebaseAuth.instance;
  fl.FacebookLogin fbLogin = new fl.FacebookLogin();
  bool isFacebookLoginIn = false;
  String errorMessage = '';
  String successMessage = '';

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  //twitter Login method

  Future<FirebaseUser> loginWithTwitter(BuildContext context) async {
    FirebaseUser currentUser;
    var twitterLogin = new TwitterLogin(
      consumerKey: '5A5BOBPJhlu1PcymNvWYo7PST',
      consumerSecret: 'iKMjVT371WTyZ2nzmbW1YM59uAfIPobWOf1HSxvUHTflaeqdhu',
    );


    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {

      case TwitterLoginStatus.loggedIn:
        var session = result.session;
        final AuthCredential credential = TwitterAuthProvider.getCredential(
            authToken: session.token,
            authTokenSecret: session.secret
        );

        final AuthResult user = await auth.signInWithCredential(credential);
        assert(user.user.email == null);
        assert(user.user.displayName != null);
        assert(!user.user.isAnonymous);
        assert(await user.user.getIdToken() != null);
        currentUser = await auth.currentUser();
        assert(user.user.uid == currentUser.uid);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage(title:

                  "huhu",
                    uid: "h",
                  )),);
        return currentUser;

        break;
      case TwitterLoginStatus.cancelledByUser:
        break;
      case TwitterLoginStatus.error:
        break;
    }
  }

  //facebook login method

  Future<FirebaseUser> facebookLogin(BuildContext context) async {
    FirebaseUser currentUser;
    // fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    // if you remove above comment then facebook login will take username and pasword for login in Webview
    try {
      final FacebookLoginResult facebookLoginResult =
      await fbLogin.logIn(['email']);
      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        FacebookAccessToken facebookAccessToken =
            facebookLoginResult.accessToken;
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: facebookAccessToken.token);
        final AuthResult user = await auth.signInWithCredential(credential);
        assert(user.user.email != null);
        assert(user.user.displayName != null);
        assert(!user.user.isAnonymous);
        assert(await user.user.getIdToken() != null);
        currentUser = await auth.currentUser();
        assert(user.user.uid == currentUser.uid);
        return currentUser;
      }
    } catch (e) {
      print(e);
    }
    return currentUser;
  }

  //facebook logout method

  Future<bool> facebookLoginout() async {
    await auth.signOut();
    await fbLogin.logOut();
    return true;
  }

  //Password padlock toggle

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  @override
  Widget build(BuildContext context) {
    bool loginfail = false;
    Size size = MediaQuery
        .of(context)
        .size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: ResponsiveLayoutBuilder(
          builder: (context, size) =>
              Background(
                child: SingleChildScrollView(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        SvgPicture.asset(
                          "assets/icons/login.svg",
                          height: 300.0,
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            height: 70.0,
                            child: new Theme(
                              data: new ThemeData(
                                primaryColor: Colors.deepPurple,
                              ),
                              child: TextFieldContainer(
                                child: TextFormField(
                                  cursorColor: kPrimaryColor,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _email,
                                  onFieldSubmitted: (term) {
                                    _fieldFocusChange(context, _email, _pwd);
                                  },

                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        widget.icon,
                                        color: kPrimaryColor,
                                      ),
                                      fillColor: Colors.deepPurple.shade50,
                                      filled: true,
                                      hintText: "Email"),
                                  controller: emailInputController,
//                                keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: 70.0,
                            child: new Theme(
                              data: new ThemeData(
                                primaryColor: Colors.deepPurple,
                              ),
                              child: TextFieldContainer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      errorBorder:
                                      OutlineInputBorder(borderSide: BorderSide(
                                          color: Colors.red)),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          _toggle();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0),
                                          child: new Icon(
                                            _obscureText ? FontAwesomeIcons
                                                .eyeSlash : FontAwesomeIcons
                                                .solidEyeSlash, size: 15.0,
                                            color: Colors.deepPurple,),

                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.lock,
                                        color: kPrimaryColor,
                                      ),
                                      border: InputBorder.none,
                                      fillColor: Colors.deepPurple.shade50,
                                      errorText: loginfail
                                          ? 'password not match'
                                          : null,
                                      filled: true,
                                      hintText: "Password"),
                                  controller: pwdInputController,
                                  obscureText: _obscureText,
                                  focusNode: _pwd,
                                  onFieldSubmitted: (value) {
                                    _pwd.unfocus();
                                    RoundedButton;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),


                        RoundedButton(
                            text: "LOGIN",
                            press: () {
                              if (_loginFormKey.currentState.validate()) {
                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: pwdInputController.text)
                                    .then((authResult) =>
                                    Firestore.instance
                                        .collection("users")
                                        .document(authResult.user.uid)
                                        .get()
                                        .then((DocumentSnapshot result) =>
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage(
                                                      title: "hello",
                                                      uid: authResult.user.uid,
                                                    ))))
                                        .catchError((err) => print(err)))
                                    .catchError((err) => print(err));
                              }
                            }),


                        SizedBox(height: 20.0),

                        AlreadyHaveAnAccountCheck(
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignUpScreen();
                                },
                              ),
                            );
                          },
                        ),


                        Padding(
                          padding: EdgeInsets.only(right: 0.0, top: 10.0),
                          child: Container(
                            width: double.infinity,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ForgotScreen()));
                              },
                              child: Text(
                                "Forgot password ?",
                                style: TextStyle(color: Color(0xFF6F35A5)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        OrDivider(),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SocalIcon(
                                iconSrc: "assets/icons/google-icon.svg",
                                press: () {
                                  signInWithGoogle(success).whenComplete(() {
//                            if (success == true)
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return HomePage(
//                                    title: "Welcome",
                                          );
                                        },
                                      ),
                                    );
                                  });
                                }),

                            SocalIcon(
                              iconSrc: "assets/icons/facebook.svg",
                              press: () {
                                facebookLogin(context).then((user) {
                                  print('Logged in successfully.');

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePage(title:

                                              "huhu",
                                                uid: "h",
                                              )),
                                          (_) => false);

                                  setState(() {
                                    isFacebookLoginIn = true;
                                    successMessage =
                                    'Logged in successfully.\nEmail : ${user
                                        .email}\nYou can now navigate to Home Page.';
                                  });
                                },);
                              },
                            ),

                            SocalIcon(
                              iconSrc: "assets/icons/twitter.svg",
                              press: () {
                                loginWithTwitter(context).then((user) {
                                  print('Logged in successfully.');
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}


_fieldFocusChange(BuildContext context, FocusNode currentFocus,
    FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}