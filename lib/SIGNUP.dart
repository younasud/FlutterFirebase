import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class signup extends StatefulWidget
{
  @override
  _signup createState()=>_signup();
}
class _signup extends State<signup>
{
  String msg;
  String email,password;
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up Page"),
      ),
      body: Form(
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
                  labelText:'Email'
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
              onSaved:(input)
              {
                password=input;
              },
              decoration: InputDecoration(
                  labelText:'password'
              ),
            ),
            RaisedButton(
              onPressed:sign_up,
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sign_up() async
  {
    print(email);
    final formstate=_formkey.currentState;
    if (formstate.validate()) {
      print('form is valid');
    } else {
      print('form invalid');
    }
    if(formstate.validate())
    {
      formstate.save();
      try{
        FirebaseUser user=(await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
      }catch(e)
      {
        msg=e.message.toString();
        if(e.message=="The email address is already in use by another account.")
          {
            Fluttertoast.showToast(
                msg:"Email Already Exist",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        print(e.message);
      }
    }
  }
}