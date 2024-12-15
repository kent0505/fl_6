part of 'coins_bloc.dart';

@immutable
sealed class CoinsState {}

final class CoinsInitial extends CoinsState {}

final class CoinsLoaded extends CoinsState {
  CoinsLoaded({
    required this.coins,
    this.isOnboard = false,
    required this.bg,
  });

  final int coins;
  final bool isOnboard;
  final int bg;
}
