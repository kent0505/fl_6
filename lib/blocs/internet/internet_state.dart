part of 'internet_bloc.dart';

@immutable
sealed class InternetState {}

final class InternetInitial extends InternetState {}

final class InternetSuccess extends InternetState {}

final class InternetFailure extends InternetState {}
