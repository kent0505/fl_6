import 'package:flutter/material.dart';

import '../widgets/my_scaffold.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Privacy Policy',
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          SizedBox(height: 8),
          Text(
            'Lorem ipsum',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'w900',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Dolor sit amet, consectetur adipiscing elit. Suspendisse tempus auctor nisi, eu mollis dui porttitor id. Suspendisse eget dapibus ligula. Integer vel eros urna. Curabitur magna dolor, viverra in bibendum sed, maximus ut neque. Quisque dapibus sagittis erat, venenatis finibus orci laoreet vitae. Curabitur et fermentum neque. Pellentesque non ligula id nunc sagittis egestas quis et purus. Dolor sit amet, consectetur adipiscing elit. Suspendisse tempus auctor nisi, eu mollis dui porttitor id. Suspendisse eget dapibus ligula. Integer vel eros urna. Curabitur magna dolor, viverra in bibendum sed, maximus ut neque. Quisque dapibus sagittis erat, venenatis finibus orci laoreet vitae. Curabitur et fermentum neque. Pellentesque non ligula id nunc sagittis egestas quis et purus.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'w400',
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
