import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'package:my_way/bloc/auth_bloc/auth.dart';
import 'package:my_way/repositories/user_repository.dart';

part 'package:my_way/bloc/register_bloc/register_event.dart';
part 'package:my_way/bloc/register_bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  RegisterBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null), super(null);

  RegisterState get initialState => RegisterInitial();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if(event is RegisterButtonPressed) {
      yield RegisterLoading();
      try{
        final token = await userRepository.register(event.username, event.callNumber, event.email, event.password);
        authenticationBloc.add(LoggedIn(token: token));
        yield RegisterInitial();
      } catch (error) {
        yield RegisterFailure(error: error.toString());
      }
    }
  }
}
