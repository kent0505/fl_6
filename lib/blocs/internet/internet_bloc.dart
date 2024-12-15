import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final _conn = Connectivity();

  InternetBloc() : super(InternetInitial()) {
    on<CheckInternet>((event, emit) {
      _conn.onConnectivityChanged.listen((result) {
        if (result.contains(ConnectivityResult.mobile)) {
          add(ChangeInternet(connected: true));
        } else if (result.contains(ConnectivityResult.wifi)) {
          add(ChangeInternet(connected: true));
        } else {
          add(ChangeInternet(connected: false));
        }
      });
    });

    on<ChangeInternet>((event, emit) {
      event.connected ? emit(InternetSuccess()) : emit(InternetFailure());
    });
  }
}
