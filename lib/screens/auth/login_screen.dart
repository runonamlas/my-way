import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/auth_bloc/auth.dart';
import 'package:my_way/bloc/login_bloc/login_bloc.dart';
import 'package:my_way/bloc/register_bloc/register_bloc.dart';
import 'package:my_way/components/password_form_field.dart';
import 'package:my_way/components/rounded_button.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/repositories/user_repository.dart';
import 'package:my_way/components/switch_between_screens_text.dart';
import 'package:my_way/components/google_facebook_apple.dart';
import 'package:my_way/components/login_or_sign_up_with.dart';
import 'package:my_way/components/text_form_field.dart';
import 'package:my_way/components/initial_text.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository userRepository;

  LoginScreen({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState(userRepository);
}

class _LoginScreenState extends State<LoginScreen> {
  final UserRepository userRepository;
  _LoginScreenState(this.userRepository);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();
  final _registerUsernameController = TextEditingController();
  final _registerCallNumberController = TextEditingController();
  bool clicked = false;

  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();

  void showRegister() {
    setState(() {
      clicked = true;
    });
  }

  Future<bool> _backButton() async {
    if (!clicked) {
      return true;
    }
    showLogin();
    return false;
  }

  void showLogin() {
    setState(() {
      clicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _backButton,
      child: clicked
          ? Scaffold(
              backgroundColor: kPrimaryColor,
              body: BlocProvider(
                create: (context) {
                  return RegisterBloc(
                    userRepository: userRepository,
                    authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                  );
                },
                child: BlocListener<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterFailure) {
                      log('register : ${state.error}');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Register Failed.'),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  child: BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                      return SafeArea(
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: GestureDetector(
                            onTap: () {
                              var currentFocus = FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              ;
                            },
                            child: Container(
                              height: size.height,
                              color: kPrimaryColor,
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: InitialText(
                                        text1: 'Create Account',
                                        text2: 'Sign Up',
                                      )),
                                  Expanded(
                                    flex: 16,
                                    child: Container(
                                      padding: EdgeInsets.all(24.0),
                                      margin: EdgeInsets.only(left: 22.0, right: 22.0),
                                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(10.0)),
                                      child: Form(
                                        key: _registerKey,
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Center(
                                              child: ConstTextFormField(
                                                text: 'Username',
                                                icon1: Icons.person,
                                                controller: _registerUsernameController,
                                                validator: (String value) {
                                                  if (value.isEmpty) {
                                                    return 'Please enter username';
                                                  }
                                                  return null;
                                                },
                                                obscureText: false,
                                              ),
                                            )),
                                            Expanded(
                                                child: Center(
                                              child: ConstTextFormField(
                                                text: 'Email',
                                                icon1: Icons.email,
                                                validator: (String value) {
                                                  if (value.isEmpty) {
                                                    return 'Please a enter';
                                                  }
                                                  if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(value)) {
                                                    return 'Please a valid Email';
                                                  }
                                                  return null;
                                                },
                                                controller: _registerEmailController,
                                                obscureText: false,
                                              ),
                                            )),
                                            Expanded(
                                                child: Center(
                                              child: ConstTextFormField(
                                                text: 'Phone Number',
                                                icon1: Icons.phone_iphone,
                                                controller: _registerCallNumberController,
                                                obscureText: false,
                                                validator: (String value) {
                                                  if (value.isEmpty) {
                                                    return 'Please enter phone no ';
                                                  } else if (value.length < 10) {
                                                    return 'Min 10 Character';
                                                  }
                                                  return null;
                                                },
                                                keyboardType: TextInputType.number,
                                              ),
                                            )),
                                            Expanded(
                                                child: Center(
                                              child: PasswordFormField(
                                                text: 'Password',
                                                icon1: Icons.lock,
                                                icon2: Icons.visibility,
                                                icon3: Icons.visibility_off,
                                                controller: _registerPasswordController,
                                                obscureText: true,
                                                validator: (String value) {
                                                  if (value.isEmpty) {
                                                    return 'Please a enter';
                                                  } else if (value.length < 6) {
                                                    return 'Password should be at least 6 characters';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )),
                                            Expanded(
                                              child: Center(
                                                child: PasswordFormField(
                                                  text: 'Confirm Password',
                                                  icon1: Icons.lock,
                                                  icon2: Icons.visibility,
                                                  icon3: Icons.visibility_off,
                                                  controller: _registerConfirmPasswordController,
                                                  obscureText: true,
                                                  validator: (String value) {
                                                    if (value.isEmpty) {
                                                      return 'Please a enter';
                                                    } else if (_registerPasswordController.text != _registerConfirmPasswordController.text) {
                                                      return 'Password do not match';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: state is RegisterLoading
                                                    ? CupertinoActivityIndicator()
                                                    : Center(
                                                        child: RoundedButton(
                                                          text: 'Sign Up',
                                                          press: () {
                                                            if (_registerKey.currentState.validate()) {
                                                              BlocProvider.of<RegisterBloc>(context).add(RegisterButtonPressed(
                                                                  username: _registerUsernameController.text,
                                                                  callNumber: _registerCallNumberController.text,
                                                                  email: _registerEmailController.text,
                                                                  password: _registerPasswordController.text));
                                                            } else {
                                                              print('unsuccessfull');
                                                            }
                                                          },
                                                        ),
                                                      )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Align(alignment: Alignment.bottomCenter, child: LoginOrSignUpWith())),
                                  Expanded(flex: 3, child: GoogleFacebookApple()),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SwitchBetweenScreensText(text1: 'Already have an Account?', text2: ' Login', onTap: showLogin),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          : Scaffold(
              backgroundColor: kPrimaryColor,
              body: BlocProvider(
                create: (context) {
                  return LoginBloc(
                    authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                    userRepository: userRepository,
                  );
                },
                child: BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                    return SafeArea(
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: GestureDetector(
                          onTap: () {
                            var currentFocus = FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            ;
                          },
                          child: Container(
                            height: size.height,
                            color: kPrimaryColor,
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 10,
                                    child: InitialText(
                                      text1: 'Login',
                                      text2: 'Welcome',
                                    )),
                                Expanded(
                                    flex: 14,
                                    child: Container(
                                      padding: EdgeInsets.all(26.0),
                                      margin: EdgeInsets.only(left: 22.0, right: 22.0),
                                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(10.0)),
                                      child: Column(
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Form(
                                                key: _loginKey,
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                        child: Center(
                                                      child: ConstTextFormField(
                                                        text: 'Username',
                                                        icon1: Icons.person,
                                                        controller: _emailController,
                                                        obscureText: false,
                                                        validator: (String value) {
                                                          if (value.isEmpty) {
                                                            return 'Please enter username';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    )),
                                                    Expanded(
                                                        child: Center(
                                                      child: PasswordFormField(
                                                        text: 'Password',
                                                        icon1: Icons.lock,
                                                        icon2: Icons.visibility,
                                                        icon3: Icons.visibility_off,
                                                        controller: _passwordController,
                                                        obscureText: true,
                                                        validator: (String value) {
                                                          if (value.isEmpty) {
                                                            return 'Please a enter password';
                                                          } else if (value.length < 6) {
                                                            return 'Password should be at least 6 characters';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              )),
                                          Expanded(
                                              child: state is LoginLoading
                                                  ? CupertinoActivityIndicator()
                                                  : Align(
                                                      alignment: Alignment.center,
                                                      child: RoundedButton(
                                                        text: 'Login',
                                                        press: () {
                                                          if (_loginKey.currentState.validate()) {
                                                            BlocProvider.of<LoginBloc>(context).add(
                                                                LoginButtonPressed(email: _emailController.text, password: _passwordController.text));
                                                          } else {
                                                            print('unsuccessfull');
                                                          }
                                                          ;
                                                          var currentFocus = FocusScope.of(context);

                                                          if (!currentFocus.hasPrimaryFocus) {
                                                            currentFocus.unfocus();
                                                          }
                                                          ;
                                                        },
                                                      ),
                                                    )),
                                        ],
                                      ),
                                    )),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: size.width * 0.4,
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * 0.035,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(child: Align(alignment: Alignment.bottomCenter, child: LoginOrSignUpWith())),
                                Expanded(flex: 5, child: GoogleFacebookApple()),
                                Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SwitchBetweenScreensText(text1: "Don't have an account?", text2: ' Sign Up', onTap: showRegister),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
    );
  }
}
