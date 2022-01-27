import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/route_bloc/route.dart';
import 'package:my_way/repositories/country_repository.dart';
import 'package:my_way/repositories/route_repository.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final RouteRepository routeRepository;
  final CountryRepository countryRepository;

  RouteBloc(
      {@required this.routeRepository, @required this.countryRepository})
      : assert(routeRepository != null, countryRepository != null),
        super(null);

  RouteState get initialState => RouteInitial();

  @override
  Stream<RouteState> mapEventToState(RouteEvent event) async* {
    final country = await countryRepository.readCountry();
    if (event is GetRoutes) {
      yield RouteLoading();
      final routes = await routeRepository.getRoutes();
      yield RouteSuccess(routes);
    }
    if (event is CreateRoutes) {
      yield RouteLoading();
      final createRoutes =
          await routeRepository.createRoute(event.routeName, event.places);
      if (createRoutes) {
        yield CreateRouteSuccess();
      } else {
        yield CreateRouteFailure();
      }
    }
    if (event is GetSavedRoutes) {
      yield RouteLoading();
      final routes = await routeRepository.getSavedRoutes();
      yield SavedRoutesSuccess(routes, country);
    }
    if (event is GetLocalSavedRoutes) {
      yield RouteLoading();
      final routes = await routeRepository.getLocalSavedRoutes();
      yield SavedRoutesSuccess(routes, country);
    }
    if (event is AddSaved) {
      yield RouteLoading();
      final success = await routeRepository.addSaved(event.routeModel);
      if (success) {
        yield AddSavedSuccess();
      } else {
        yield FailureAddSavedSuccess();
      }
    }
    if (event is DeleteSaved) {
      yield RouteLoading();
      final routes = await routeRepository.deleteSavedRoute(event.routeModel);
      yield SavedRoutesSuccess(routes, country);
    }
  }
}

final routeBloc = RouteBloc(routeRepository: null, countryRepository: null);
