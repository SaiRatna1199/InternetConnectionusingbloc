import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'internetevent.dart';
import 'internetstate.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  // bool result = false;
  // checkConnectivity() async {
  //   result = await InternetConnection().hasInternetAccess;
  //   return result;
  // }

  InternetConnection connection = InternetConnection();
  StreamSubscription? connectionSubscription;

  InternetBloc() : super(InternetInitialState()) {
    on<InternetLossEvent>((event, emit) => emit(InternetLostState()));
    on<InternetGainedEvent>((event, emit) => emit(InternetGainedState()));

    connectionSubscription = connection.onStatusChange.listen((result) {
      if (result == InternetStatus.connected) {
        add(InternetGainedEvent());
      } else {
        add(InternetLossEvent());
      }
    });
  }

  @override
  Future<void> close() {
    connectionSubscription?.cancel();
    return super.close();
  }
}
