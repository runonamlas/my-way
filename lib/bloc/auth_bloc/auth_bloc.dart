import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:my_way/bloc/auth_bloc/auth.dart';
import 'package:my_way/repositories/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(null);

  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final hasToken = await userRepository.hasToken();
      final firstOpen = await userRepository.firstOpen();
      if (hasToken) {
        final hasCity = await userRepository.hasCity();
        yield AuthenticationAuthenticated(hasCity);
      } else if (firstOpen) {
        yield AuthenticationFirstOpen();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }
    if (event is LoggedIn) {
      yield AuthenticationLoading();
      final hasCity = await userRepository.hasCity();
      await userRepository.firstOpenLogWrite();
      await userRepository.writeToken(event.token);
      yield AuthenticationAuthenticated(hasCity);
    }
    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
