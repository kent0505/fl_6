import 'package:intl/intl.dart';

int getTimestamp() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

String formatCoins(int coins) {
  return NumberFormat("0.00").format(coins);
}
