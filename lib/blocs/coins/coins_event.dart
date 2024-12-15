part of 'coins_bloc.dart';

@immutable
sealed class CoinsEvent {}

class LoadCoins extends CoinsEvent {}

class SaveCoins extends CoinsEvent {
  SaveCoins({required this.amount, this.isBuy = false});

  final int amount;
  final bool isBuy;
}

class SaveBG extends CoinsEvent {
  SaveBG({required this.id});

  final int id;
}
