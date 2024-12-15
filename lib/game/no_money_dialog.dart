import 'package:flutter/material.dart';

import '../widgets/my_button.dart';
import '../widgets/primary_button.dart';

class NoMoneyDialog extends StatelessWidget {
  const NoMoneyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 192,
        width: 358,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff4400A7),
              Color(0xff090034),
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              'Not enough coins',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'w900',
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'You don’t have enough coins on your balance to place a bet. Watch adv and get 20 coins or wait for tomorrow daily prize.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'w400',
                ),
              ),
            ),
            Spacer(),
            Row(
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: MyButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    minSize: 52,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xffF6D303),
                        fontSize: 20,
                        fontFamily: 'w900',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: PrimaryButton(
                    title: 'Watch',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
