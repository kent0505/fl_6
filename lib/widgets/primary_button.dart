import 'package:flutter/material.dart';

import 'my_button.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    this.isActive = true,
    required this.onPressed,
  });

  final String title;
  final bool isActive;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isActive ? Color(0xffF6D303) : Color(0xff4a4001),
        borderRadius: BorderRadius.circular(52),
      ),
      child: MyButton(
        onPressed: isActive ? onPressed : null,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xff140430),
              fontSize: 20,
              fontFamily: 'w900',
            ),
          ),
        ),
      ),
    );
  }
}
