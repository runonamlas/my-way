import 'package:flutter/material.dart';
import 'package:my_way/bloc/auth_bloc/auth.dart';
import 'package:my_way/bloc/auth_bloc/auth_bloc.dart';
import 'package:my_way/components/build_loading_widget.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/repositories/user_repository.dart';
import 'package:my_way/screens/auth/login_screen.dart';
import 'package:my_way/screens/auth/welcome_screen.dart';
import 'package:my_way/screens/bottom_menu/bottom_nav_bar.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print(error);
  }
}

void main() {
  /*runApp(DevicePreview(
    builder: (context) => MyApp(),
  ));*/
  Bloc.observer = SimpleBlocObserver();
  final userRepository = UserRepository();
  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      return AuthenticationBloc(userRepository: userRepository)
        ..add(AppStarted());
    },
    child: MyApp(
      userRepository: userRepository,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  MyApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      //builder: DevicePreview.appBuilder,
      title: 'MyWay',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              return BottomNavBar(hasCity: state.city);
            }
            if (state is AuthenticationFirstOpen) {
              return WelcomeScreen(userRepository: userRepository);
            }
            if (state is AuthenticationUnauthenticated) {
              return LoginScreen(userRepository: userRepository);
            }
            if (state is AuthenticationLoading) {
              return Scaffold(body: buildLoadingWidget());
            }
            return Scaffold(body: buildLoadingWidget());
          },
        ),
      ),
    );
  }
}
