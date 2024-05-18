import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/auth.dart';
import 'package:flutter_ar_app/pages/login.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:sign_in_button/sign_in_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  static String id = 'home_screen';

  Future<void> signInWithGoogle() async {
    try {
      SmartDialog.showLoading();
      await Auth().signInWithGoogle();
    } on FirebaseAuthException catch(e){
    }
  }

  Widget _googleButton(){
    return SignInButton(
      Buttons.google,
      onPressed: () {
        signInWithGoogle();
      },
      padding: EdgeInsets.all(3),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(12))),
    );
  }

  Widget _screenImage(path){
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(path),
            ),
          ),
        ),
      );
    }

  Widget _screenTitle(title){
      return Text(
        title,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          fontFamily: "Montserrat",
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _screenImage('assets/images/welcome.jpg'),
              Padding(
                  padding:
                    const EdgeInsets.only(right: 15, left: 15, bottom: 65),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _screenTitle('Hello'),
                      const Text(
                        'Welcome to ARGraduateApp, where you relive your memories',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Hero(
                        tag: 'login_btn',
                        child: CustomButton(
                          buttonText: 'Login',
                          color: Color.fromARGB(255, 57, 123, 255),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Hero(
                        tag: 'signup_btn',
                        child: CustomButton(
                          buttonText: 'Sign Up',
                          isOutlined: true,
                          color: Color.fromARGB(255, 57, 123, 255),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage(isLogin: false,)),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        'Sign in using',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _googleButton()
                        ],
                      ),
                      )
                      
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.buttonText,
      this.isOutlined = false,
      required this.onPressed,
      this.width = 280,
      this.color = Colors.blue
      });

  final String buttonText;
  final bool isOutlined;
  final Function onPressed;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      upperBound: 0.1,
      duration: Duration(milliseconds: 100),
      onPressed: (){
        onPressed();
      },
      child: Material(
        borderRadius: BorderRadius.circular(30),
        elevation: 4,
        child: Container(
          width: width,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: isOutlined ? Colors.white : color,
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: "Montserrat",
                color: isOutlined ? color : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}