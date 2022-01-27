import 'package:equatable/equatable.dart';
import 'package:my_way/model/city.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState { }

class AuthenticationAuthenticated extends AuthenticationState { 
  final CityModel city;
  AuthenticationAuthenticated(this.city);
}

class AuthenticationFirstOpen extends AuthenticationState { }

class AuthenticationUnauthenticated extends AuthenticationState { }

class AuthenticationLoading extends AuthenticationState { }