import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'coins_event.dart';
part 'coins_state.dart';

class CoinsBloc extends Bloc<CoinsEvent, CoinsState> {
  CoinsBloc() : super(CoinsInitial()) {
    on<LoadCoins>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      int coins = prefs.getInt('coins') ?? 100;
      bool isOnboard = prefs.getBool('isOnboard') ?? true;
      emit(CoinsLoaded(
        coins: coins,
        isOnboard: isOnboard,
      ));
    });

    on<SaveCoins>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      int coins = prefs.getInt('coins') ?? 100;
      coins += event.amount;
      await prefs.setInt('coins', coins);
      emit(CoinsLoaded(coins: coins));
    });
  }
}
