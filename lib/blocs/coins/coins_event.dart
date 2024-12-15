part of 'coins_bloc.dart';

@immutable
sealed class CoinsEvent {}

class LoadCoins extends CoinsEvent {}

class SaveCoins extends CoinsEvent {
  SaveCoins({required this.amount});

  final int amount;
}
