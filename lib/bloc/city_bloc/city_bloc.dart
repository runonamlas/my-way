import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/city_bloc/city.dart';
import 'package:my_way/model/country.dart';
import 'package:my_way/repositories/city_repository.dart';
import 'package:my_way/repositories/country_repository.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityRepository cityRepository;
  final CountryRepository countryRepository;

  CityBloc({@required this.cityRepository, @required this.countryRepository})
      : assert(cityRepository != null, countryRepository != null),
        super(null);

  CityState get initialState => CityInitial();

  @override
  Stream<CityState> mapEventToState(CityEvent event) async* {
    if (event is GetCities || event is CountryChanged) {
      yield CityLoading();
      var hasCountry = await countryRepository.hasCountry();
      if (!hasCountry) {
        await countryRepository
            .writeCountry(CountryModel('1', 'Turkiye', 'tr'));
      }
      final country = await countryRepository.readCountry();
      final cities = await cityRepository.getCities();
      yield CitySuccess(cities, country);
    }
    if (event is CitySelect) {
      yield CityLoading();
      await cityRepository.writeCity(event.city);
      yield CityInitial();
    }
    if (event is GetCountries) {
      yield CountryLoading();
      final countries = await countryRepository.getCountries();
      final localCountry = await countryRepository.readCountry();
      yield CountrySuccess(countries, localCountry);
    }
    if (event is GetCountry) {
      yield CountryLoading();
      final localCountry = await countryRepository.readCountry();
      yield GetCountrySucces(localCountry);
    }
    if (event is CountrySelect) {
      yield CountryLoading();
      await countryRepository.writeCountry(event.country);
      yield CityInitial();
    }
  }
}

final cityBloc = CityBloc(cityRepository: null, countryRepository: null);
