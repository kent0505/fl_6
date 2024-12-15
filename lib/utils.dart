import 'dart:developer' as developer;

import 'package:intl/intl.dart';

int coins = 100;

String formatCoins() {
  return NumberFormat("0.00").format(coins);
}

void logger(Object message) => developer.log(message.toString());
