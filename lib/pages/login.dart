import 'package:bouncing_button/bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ar_app/auth.dart';

import 'package:sign_in_button/sign_in_button.dart';

final User? user = Auth().currentUser;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String? errorMsg = "";
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text, 
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch(e){
        setState(() {
          errorMsg = e.message;
        });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        username: _controllerUsername.text
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        
          errorMsg = e.message;
        });
    }
  }

   Future<void> signInWithGoogle() async {
    try {
      await Auth().signInWithGoogle();
    } on FirebaseAuthException catch(e){
        setState(() {
          errorMsg = e.message;
        });
    }
  }

  Widget _title(){
    return Text(isLogin? 'Sign In' : 'Register', style: TextStyle(fontSize: 20.0, fontFamily: "Poppers", fontWeight: FontWeight.w700),);
  }

  Widget _entryField(String title, TextEditingController controller, [bool visible=true]){
    if(visible){
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
        ),
      );
    }
    return SizedBox.shrink();
    
  }

  Widget _errorMessage(){
    return Text(errorMsg == '' ? '' : "Error: $errorMsg");
  }

  Widget _bouncingSubmitButton(){
    return BouncingButton(
              upperBound: 0.1,
              duration: Duration(milliseconds: 100),
              onPressed: (){
                isLogin ? signInWithEmailAndPassword() : createUserWithEmailAndPassword();
              },
              child: Container(
                height: 45,
                width: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Color.fromARGB(255, 57, 123, 255),
                ),
                child: const Center(
                  child: Text(
                    'Authorize',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )),
            );
  }

  Widget _loginOrRegisterLink(){
    return TextButton(
      onPressed: (){
        setState(() {
          isLogin = !isLogin;
          
        });
      },
      child: Text(isLogin? 'Register instead' : 'Login instead'));
  }

  Widget _googleButton(){
    return SignInButton(
      Buttons.google,
      onPressed: () {
        signInWithGoogle();
      },
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(5))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _title(),
            _entryField('email', _controllerEmail),
            _entryField('username', _controllerUsername, !isLogin),
            _entryField('password', _controllerPassword),
            _entryField('confirm_password', _controllerConfirmPassword, !isLogin),
            _errorMessage(),
            _bouncingSubmitButton(),
            _loginOrRegisterLink(),
            _googleButton(),
          ]
        )
      )
    );
  }

}