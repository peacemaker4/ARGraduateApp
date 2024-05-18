import 'dart:typed_data';

import 'package:bouncing_button/bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ar_app/auth.dart';
import 'package:flutter_ar_app/pages/nav.dart';
import 'package:flutter_ar_app/utils/helpers/snackbar_helper.dart';
import 'package:flutter_ar_app/utils/widgets/gradient_background.dart';
import 'package:flutter_ar_app/values/app_colors.dart';
import 'package:flutter_ar_app/values/app_constants.dart';
import 'package:flutter_ar_app/values/app_regex.dart';
import 'package:flutter_ar_app/values/app_strings.dart';
import 'package:flutter_ar_app/values/app_theme.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sign_in_button/sign_in_button.dart';
import 'package:get/get.dart';

final User? user = Auth().currentUser;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.isLogin = true}) : super(key: key);

  bool isLogin;

  @override
  State<LoginPage> createState() => _LoginPageState(isLogin);
}

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    required this.textInputAction,
    required this.labelText,
    required this.keyboardType,
    required this.controller,
    super.key,
    this.onChanged,
    this.validator,
    this.obscureText,
    this.placeholderText,
    this.suffixIcon,
    this.onEditingComplete,
    this.autofocus,
    this.focusNode,
  });

  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String labelText;
  final String? placeholderText;
  final bool? autofocus;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onChanged: onChanged,
        autofocus: autofocus ?? false,
        validator: validator,
        obscureText: obscureText ?? false,
        obscuringCharacter: '*',
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(18, 24, 12, 16),
          suffixIcon: suffixIcon,
          labelText: labelText,
          labelStyle: TextStyle(fontFamily: "Montserrat",),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholderText,
          hintStyle: TextStyle(color: Color.fromARGB(255, 200, 200, 200),fontFamily: "Montserrat", fontSize: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(18))
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(18))
          ),
          
        ),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _LoginPageState extends State<LoginPage> {

  String? errorMsg = "";
  bool isLogin;

  _LoginPageState(this.isLogin){}

  late final TextEditingController _controllerEmail;
  late final TextEditingController _controllerUsername;
  late final TextEditingController _controllerPassword;
  late final TextEditingController _controllerConfirmPassword;

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> loginFieldValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> registerFieldValidNotifier = ValueNotifier(false);

  final _formKey = GlobalKey<FormState>();

  void initializeControllers() {
    _controllerEmail = TextEditingController()..addListener(controllerListener);
    _controllerUsername = TextEditingController()..addListener(controllerListener);
    _controllerPassword = TextEditingController()
      ..addListener(controllerListener);
    _controllerConfirmPassword = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    _controllerEmail.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPassword.dispose();
  }

  void controllerListener() {
    final email = _controllerEmail.text;
    final name = _controllerUsername.text;
    final password = _controllerPassword.text;
    final confirmPassword = _controllerConfirmPassword.text;

    if (name.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) return;

    if(isLogin){
      if (AppRegex.emailRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password)) {
        loginFieldValidNotifier.value = true;
      } else {
        loginFieldValidNotifier.value = false;
      }
    }
    else{
      if (AppRegex.emailRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password) &&
        AppRegex.passwordRegex.hasMatch(confirmPassword)) {
        registerFieldValidNotifier.value = true;
      } else {
        registerFieldValidNotifier.value = false;
      }
    }

    
  }

   @override
  void initState() {
    initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      SmartDialog.showLoading();
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text, 
        password: _controllerPassword.text,
      ).then((value){
        Navigator.pop(context);
        SmartDialog.dismiss();
      });
    } on FirebaseAuthException catch(e){
        SmartDialog.dismiss();
        setState(() {
          errorMsg = e.message;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${errorMsg}"),
            duration: Duration(seconds: 3),
        ));
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      SmartDialog.showLoading();
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        username: _controllerUsername.text
      ).then((value){
        SmartDialog.dismiss();
        Navigator.pop(context);
      });
    } on FirebaseAuthException catch (e) {
      SmartDialog.dismiss();
      setState(() {
          errorMsg = e.message;
        });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${errorMsg}"),
            duration: Duration(seconds: 3),
        ));
    }
  }

   Future<void> signInWithGoogle() async {
    try {
      SmartDialog.showLoading();
      await Auth().signInWithGoogle().then((value){
        Navigator.pop(context);
      });
    } on FirebaseAuthException catch(e){
        setState(() {
          errorMsg = e.message;
        });
    }
  }

  Widget _errorMessage(){
    return Text(errorMsg == '' ? '' : "Error: $errorMsg");
  }

  Widget _submitButton(){
    return ValueListenableBuilder(
      valueListenable: isLogin? loginFieldValidNotifier : registerFieldValidNotifier,
      builder: (_, isValid, __) {
        return FilledButton(
          onPressed: isValid? () {
            isLogin ? signInWithEmailAndPassword() : createUserWithEmailAndPassword();

            SnackbarHelper.showSnackBar(
              AppStrings.registrationComplete,
            );
            }
          : null,
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(AppColors.primaryColor),
            minimumSize: MaterialStateProperty.all(Size.fromHeight(40)),
          ),
          child: Text(isLogin? 'Sign in' : 'Sign up', style: TextStyle(fontFamily: "Montserrat",),),
        ); 
        // BouncingButton(
        //   upperBound: 0.1,
        //   duration: Duration(milliseconds: 100),
        //   onPressed: (){
        //     // if(isValid){
              

        //       isLogin ? signInWithEmailAndPassword() : createUserWithEmailAndPassword();

        //       SnackbarHelper.showSnackBar(
        //         AppStrings.registrationComplete,
        //       );
        //       // _controllerEmail.clear();
        //       // _controllerUsername.clear();
        //       // _controllerPassword.clear();
        //       // _controllerConfirmPassword.clear();

        //     // }

        //   },
        //   child: Container(
        //     height: 55,
        //     width: 370,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(15.0),
        //       color: AppColors.primaryColor,
        //     ),
        //     child: Center(
        //       child: Text(
        //         isLogin? 'Sign in' : 'Sign up',
        //         style: TextStyle(
        //           fontSize: 20.0,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.white,
        //         ),
        //       ),
        //     )),
        // );
      },
    );
  }

  Widget _loginOrRegisterLink(){
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLogin? AppStrings.doNotHaveAnAccount : AppStrings.iHaveAnAccount,
                style: AppTheme.bodySmall.copyWith(color: Colors.black, fontFamily: "Montserrat", fontSize: 12), 
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(isLogin? 'Register instead' : 'Login instead', style: TextStyle(fontFamily: "Montserrat", fontSize: 13),)
              )
            ],
          );
  }

  Widget _googleButton(){
    return SignInButton(
      Buttons.google,
      text: isLogin? "Sign in with Google" : "Sign up with Google",
      onPressed: () {
        signInWithGoogle();
      },
      padding: EdgeInsets.all(3),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(12))),
    );
  }

  Widget _pageTitle(){
    return GradientBackground(
            children: [
              Text(isLogin? AppStrings.signInToYourNAccount : AppStrings.register, style: AppTheme.titleLarge),
              SizedBox(height: 6),
              Text(isLogin? AppStrings.signInToYourAccount : AppStrings.createYourAccount, style: AppTheme.bodySmall),
            ],
            sizeFrac: isLogin? 100 : 50,
    );
  }

  Widget _emailField([bool visible=true]){
    if(visible){
      return AppTextFormField(
        autofocus: true,
        labelText: AppStrings.email,
        placeholderText: "Enter email",
        controller: _controllerEmail,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        onChanged: (_) => _formKey.currentState?.validate(),
        validator: (value) {
          if(!value!.isEmpty){
            if(AppConstants.emailRegex.hasMatch(value)){
              return null;
            }
            else{
              return AppStrings.invalidEmailAddress;
            }
          }
        },
      );
    }
    return SizedBox.shrink();
  }

  Widget _usernameField([bool visible=true]){
    if(visible){
      return AppTextFormField(
        labelText: AppStrings.name,
        placeholderText: "Enter username",
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        onChanged: (value) => _formKey.currentState?.validate(),
        validator: (value) {
          if(!value!.isEmpty){
            if(value.length < 4){
              return AppStrings.invalidName;
            }
            else{
              return null;
            }
          }
        },
        controller: _controllerUsername,
      );
    }
    return SizedBox.shrink();
  }

  Widget _passwordField([bool visible=true]){
    if(visible){
      return ValueListenableBuilder<bool>(
        valueListenable: passwordNotifier,
        builder: (_, passwordObscure, __) {
          return AppTextFormField(
            obscureText: passwordObscure,
            controller: _controllerPassword,
            labelText: AppStrings.password,
            placeholderText: "Enter password",
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (_) => _formKey.currentState?.validate(),
            validator: (value) {
              if(!value!.isEmpty){
                if(AppConstants.passwordRegex.hasMatch(value)){
                  return null;
                }
                else{
                  return AppStrings.invalidPassword;
                }
              }
            },
            suffixIcon: Focus(
              descendantsAreFocusable: false,
              child: IconButton(
                onPressed: () =>
                    passwordNotifier.value = !passwordObscure,
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(48),
                ),
                icon: Icon(
                  passwordObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      );
    }
    return SizedBox.shrink();
  }

  Widget _passwordConfirmField([bool visible=true]){
    if(visible){
      return ValueListenableBuilder(
        valueListenable: confirmPasswordNotifier,
        builder: (_, confirmPasswordObscure, __) {
          return AppTextFormField(
            labelText: AppStrings.confirmPassword,
            placeholderText: "Confirm password",
            controller: _controllerConfirmPassword,
            obscureText: confirmPasswordObscure,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (_) => _formKey.currentState?.validate(),
            validator: (value) {
              if(!value!.isEmpty){
                if(AppConstants.passwordRegex.hasMatch(value)){
                  if(_controllerPassword.text ==_controllerConfirmPassword.text){
                    return null;
                  }
                  else{
                    return AppStrings.passwordNotMatched;
                  }
                }
                else{
                    return AppStrings.invalidPassword;
                }
              }
            },
            suffixIcon: Focus(
              descendantsAreFocusable: false,
              child: IconButton(
                onPressed: () => confirmPasswordNotifier.value =
                    !confirmPasswordObscure,
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(48),
                ),
                icon: Icon(
                  confirmPasswordObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      );
    }
    return SizedBox.shrink();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _pageTitle(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _emailField(),
                  _usernameField(!isLogin),
                  _passwordField(),
                  _passwordConfirmField(!isLogin),
                  _submitButton(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade200)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          isLogin ? AppStrings.orLoginWith : "or Sign up with",
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade200)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Center(child: _googleButton(),)
                    ],
                  )
                ],
              ),
            ),
            
          ),
          _loginOrRegisterLink()
          
        ],
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         _title(),
    //         _entryField('email', _controllerEmail),
    //         _entryField('username', _controllerUsername, !isLogin),
    //         _entryField('password', _controllerPassword),
    //         _entryField('confirm_password', _controllerConfirmPassword, !isLogin),
    //         _errorMessage(),
    //         _bouncingSubmitButton(),
    //         _loginOrRegisterLink(),
    //         _googleButton(),
    //       ]
    //     )
    //   )
    // );
  }

}