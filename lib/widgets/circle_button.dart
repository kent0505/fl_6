import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'my_button.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.asset,
    required this.onPressed,
  });

  final String asset;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      width: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffF6D303),
      ),
      child: MyButton(
        onPressed: onPressed,
        child: Center(
          child: SvgPicture.asset(asset),
        ),
      ),
    );
  }
}
