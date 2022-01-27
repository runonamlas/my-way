import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/user_bloc/user.dart';
import 'package:my_way/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(
      {@required this.userRepository})
      : assert(userRepository != null),
        super(null);

  UserState get initialState => UserInitial();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is GetUser) {
      yield UserLoading();
      // final user = await userRepository.getUser();
      yield UserSuccess();
    }
   
  }
}

final userBloc = UserBloc(userRepository: null);
