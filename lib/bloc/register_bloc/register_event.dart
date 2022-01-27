part of 'package:my_way/bloc/register_bloc/register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterButtonPressed extends RegisterEvent {
  final String username;
  final String callNumber;
  final String email;
  final String password;

  const RegisterButtonPressed({
    @required this.username,
    @required this.callNumber,
    @required this.email,
    @required this.password
  });

  @override
  List<Object> get props => [username, callNumber, email, password];

  @override
  String toString() => 'RegisterButtonPressed {username: $username, callNumber: $callNumber email: $email, password: $password}';
}