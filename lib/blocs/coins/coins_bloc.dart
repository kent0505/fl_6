import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'coins_event.dart';
part 'coins_state.dart';

class CoinsBloc extends Bloc<CoinsEvent, CoinsState> {
  CoinsBloc() : super(CoinsInitial()) {
    on<LoadCoins>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      // await prefs.clear();
      int coins = prefs.getInt('coins') ?? 300;
      bool isOnboard = prefs.getBool('isOnboard') ?? true;
      int bg = prefs.getInt('bg') ?? 0;
      emit(CoinsLoaded(coins: coins, isOnboard: isOnboard, bg: bg));
    });

    on<SaveCoins>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      int coins = prefs.getInt('coins') ?? 300;
      int bg = prefs.getInt('bg') ?? 0;
      if (event.isBuy) {
        coins -= event.amount;
      } else {
        coins += event.amount;
      }
      await prefs.setInt('coins', coins);
      emit(CoinsLoaded(coins: coins, bg: bg));
    });

    on<SaveBG>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      int bg = prefs.getInt('bg') ?? 0;
      if (event.id == bg) {
        bg = 0;
        await prefs.setInt('bg', 0);
      } else {
        bg = event.id;
        await prefs.setInt('bg', bg);
      }
      int coins = prefs.getInt('coins') ?? 300;
      emit(CoinsLoaded(coins: coins, bg: bg));
    });
  }
}
