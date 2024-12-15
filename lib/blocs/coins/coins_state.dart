part of 'coins_bloc.dart';

@immutable
sealed class CoinsState {}

final class CoinsInitial extends CoinsState {}

final class CoinsLoaded extends CoinsState {
  CoinsLoaded({
    required this.coins,
    this.isOnboard = false,
  });

  final int coins;
  final bool isOnboard;
}
