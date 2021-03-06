import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:our_apps_template/data/service/shared_preference_service.dart';
import 'package:our_apps_template/utils/constants.dart';
import 'package:our_apps_template/utils/enums.dart';

part 'language_event.dart';

part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  @override
  LanguageState get initialState => LanguageState(Locale('en', 'US'));

  @override
  Stream<LanguageState> mapEventToState(LanguageEvent event) async* {
    if (event is LanguageLoadStarted) {
      yield* _mapLanguageLoadStartedToState();
    } else if (event is LanguageSelected) {
      yield* _mapLanguageSelectedToState(event.languageCode);
    }
  }

  Stream<LanguageState> _mapLanguageLoadStartedToState() async* {
    final sharedPrefService = await SharedPreferencesService.instance;

    final defaultLanguageCode = sharedPrefService.languageCode;
    Locale locale;

    if (defaultLanguageCode == null) {
      locale = Locale('en', 'US');
      await sharedPrefService.setLanguage(locale.languageCode);
    } else {
      locale = Locale(defaultLanguageCode);
    }

    yield LanguageState(locale);
  }

  Stream<LanguageState> _mapLanguageSelectedToState(
      Language selectedLanguage) async* {
    final sharedPrefService = await SharedPreferencesService.instance;
    final defaultLanguageCode = sharedPrefService.languageCode;

    if (selectedLanguage == Language.AZ &&
        defaultLanguageCode != LanguageKeys.az) {
      yield* _loadLanguage(sharedPrefService, 'az', 'AZ');
    } else if (selectedLanguage == Language.EN &&
        defaultLanguageCode != LanguageKeys.en) {
      yield* _loadLanguage(sharedPrefService, 'en', 'US');
    }
  }

  /// This method is added to reduce code repetation.
  Stream<LanguageState> _loadLanguage(
      SharedPreferencesService sharedPreferencesService,
      String languageCode,
      String countryCode) async* {
    final locale = Locale(languageCode, countryCode);
    await sharedPreferencesService.setLanguage(locale.languageCode);
    yield LanguageState(locale);
  }
}
