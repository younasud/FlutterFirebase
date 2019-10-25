import 'package:firebase_authentication/Phone_No.dart';
import 'package:firebase_authentication/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'SIGNUP.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

    void main()
    {
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: homepage(),
      ));
    }
  class homepage extends StatefulWidget
  {
    @override
    _homepage createState()=>_homepage();
  }
  class _homepage extends State<homepage>
  {
    String email,password;
    final facebookLogin = FacebookLogin();

    String phoneno,smscode,verificationid;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
    FacebookLogin fblogin=new FacebookLogin();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("AUthentication"),
      ),
      body:
      ListView(
        children: <Widget>[
          Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator:(input)
                  {
                    if(input.isEmpty)
                    {
                      return 'Please Enter an email';
                    }
                  },
                  onSaved:(input)
                  {
                    email=input;
                  },
                  decoration: InputDecoration(
                      labelText:'password'
                  ),
                ),
                TextFormField(
                  validator:(input)
                  {
                    if(input.length<6)
                    {
                      return 'Please provided Password is atleast of 6 characters';
                    }
                  },
                  obscureText: true,
                  onSaved:(input)
                  {
                    password=input;
                  },
                  decoration: InputDecoration(
                      labelText:'Password'
                  ),
                ),
                RaisedButton(
                  onPressed: SIGNIN,
                  child: Text("Sign in"),
                ),
                RaisedButton(
                  onPressed: ()
                  {
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context)=>new signup()
                    );
                    Navigator.of(context).push(route);
                  },
                  child: Text("Sign Up"),
                ),
                TextFormField(
                  obscureText: true,
                  onSaved:(input)
                  {
                    phoneno=input;
                  },
                  decoration: InputDecoration(
                      labelText:'Contact NO'
                  ),
                ),
                RaisedButton(
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>phone()));
                  },
                  child: Text("Sign up contact"),
                ),
                Container(
                  width: 205,
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Color(0xffffffff),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.google,color: Color(0xffCE107C),),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text("Sign in with google",style: TextStyle(color: Colors.black),),
                        ],
                      ),
                      onPressed: ()
                      {
                        _handleSignIn()
                            .then((FirebaseUser user) => print(user))
                            .catchError((e) => print(e));
                      },
                    ),
                  ),
                ),
                Container(
                  width: 205,
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Color(0xffffffff),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.facebook,color: Colors.blue,),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text("Sign in with Facebook",style: TextStyle(color: Colors.black),),
                        ],
                      ),
                      onPressed: () async
                      {
                        final result = await facebookLogin.logIn(['email']);
                        switch (result.status) {
                          case FacebookLoginStatus.loggedIn:
                            FacebookAccessToken myToken = result.accessToken;
                            AuthCredential credential =
                            FacebookAuthProvider.getCredential(accessToken: myToken.token);
                            var user = await FirebaseAuth.instance.signInWithCredential(credential);
                            break;
                          case FacebookLoginStatus.cancelledByUser:
                            break;
                          case FacebookLoginStatus.error:
                            print("error found");
                            break;
                        }
//                    var result =
//                    await fblogin.logInWithReadPermissions(['email', 'public_profile']);
//                    if (result.status == FacebookLoginStatus.loggedIn) {
//                      FacebookAccessToken myToken = result.accessToken;
//                      AuthCredential credential =
//                      FacebookAuthProvider.getCredential(accessToken: myToken.token);
//                      var user = await FirebaseAuth.instance.signInWithCredential(credential);
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),

    );
  }
//Facebook Login
  Future<FirebaseUser> FBlogin() async
  {
    var result =
    await fblogin.logIn(['email']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      FacebookAccessToken myToken = result.accessToken;
      AuthCredential credential =
      FacebookAuthProvider.getCredential(accessToken: myToken.token);
      var user = await FirebaseAuth.instance.signInWithCredential(credential);
    }
//    final facebookLoginResult = await fblogin.logIn(['email', 'public_profile']);
//    FacebookAccessToken myToken = facebookLoginResult.accessToken;
//
//    ///assuming sucess in FacebookLoginStatus.loggedIn
//    /// we use FacebookAuthProvider class to get a credential from accessToken
//    /// this will return an AuthCredential object that we will use to auth in firebase
//    AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: myToken.token);
//
//// this line do auth in firebase with your facebook credential.
////    FirebaseUser firebaseUser = (
////        await FirebaseAuth.instance.signInWithCredential(credential)
////    ).user;
  }
  //simple email and password signed in
  Future<void> SIGNIN()  async
{
  print(email);
  final formstate=_formkey.currentState;
  if (formstate.validate()) {
    print('form is valid');
  } else {
    print('Sorry your email or password is not correct');
  }
  String msg;
  if(formstate.validate())
    {
      formstate.save();
      try{
        FirebaseUser user=(await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
      }catch(e)
  {
    msg=e.message;
    if(e.message=="The password is invalid or the user does not have a password.")
    {
      Fluttertoast.showToast(
          msg:"Email or Password is Incorrect",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    print("feed back $msg");
    print(e.message);
  }
    }
}
//Google Sign_up
Future<FirebaseUser> _handleSignIn() async {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      Fluttertoast.showToast(
          msg:user.displayName,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print("signed in " + user.displayName);
      return user;
    }

//Future<FirebaseUser> _signin(BuildContext context)
//async
//{
//  final GoogleSignInAccount googleuser=(await googleSignIn.signIn());
//  final GoogleSignInAuthentication googleauth=await googleuser.authentication;
//  final AuthCredential credential=GoogleAuthProvider.getCredential(idToken: googleauth.idToken, accessToken: googleauth.accessToken);
//  FirebaseUser userdetail=(await users.signInWithCredential(credential)).user;
//  ProviderDetails
//}
  }