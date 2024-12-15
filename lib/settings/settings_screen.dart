import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/coins/coins_bloc.dart';
import '../widgets/my_button.dart';
import '../widgets/my_scaffold.dart';
import '../widgets/primary_button.dart';
import 'privacy_screen.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Settings',
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          SizedBox(height: 8),
          _Button(
            id: 1,
            title: 'Notifications',
            desc: 'Turn notifications on or off to stay updated your way!',
          ),
          _Button(
            id: 2,
            title: 'Privacy Policy',
            desc:
                'We protect your data and use it only to improve our services.',
          ),
          _Button(
            id: 3,
            title: 'Terms of Use',
            desc:
                'We protect your data and use it only to improve our services.',
          ),
          _Button(
            id: 4,
            title: 'Share App',
            desc:
                'Love the app? Share it with friends and family to spread the experience!',
          ),
          _Button(
            id: 5,
            title: 'Rate Us',
            desc:
                'Enjoying the app? Share your feedback and rate us to help us improve!',
          ),
          _Button(
            id: 6,
            title: 'Clear Data',
            desc:
                'Reset the app by clearing all saved data. This action cannot be undone.',
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.id,
    required this.title,
    required this.desc,
  });

  final int id;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xff6F18FA),
        borderRadius: BorderRadius.circular(84),
      ),
      child: MyButton(
        onPressed: () {
          if (id == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PrivacyScreen();
                },
              ),
            );
          } else if (id == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TermsScreen();
                },
              ),
            );
          } else if (id == 6) {
            showDialog(
              context: context,
              builder: (context) {
                return _ClearDataDialog();
              },
            );
          }
        },
        child: Row(
          children: [
            SizedBox(width: 16),
            SvgPicture.asset('assets/s$id.svg'),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'w700',
                    ),
                  ),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'w400',
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _ClearDataDialog extends StatelessWidget {
  const _ClearDataDialog();

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
              'Clear Data',
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
                'Are you sure you want to clear data? All your settings will be reset and will not be subject to recovery.',
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
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      if (context.mounted) {
                        context.read<CoinsBloc>().add(SaveBG(id: 0));
                        Navigator.pop(context);
                      }
                    },
                    minSize: 52,
                    child: Text(
                      'Clear',
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
                    title: 'Cancel',
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
