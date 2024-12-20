import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../blocs/coins/coins_bloc.dart';
import '../settings/settings_screen.dart';
import '../shop/shop_screen.dart';
import '../utils.dart';
import 'circle_button.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({
    super.key,
    this.title = '',
    this.isHome = false,
    this.isGame = false,
  });

  final String title;
  final bool isHome;
  final bool isGame;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: SizedBox(
        height: 58 + 16,
        child: Row(
          children: [
            SizedBox(width: 16),
            if (isHome) ...[
              CircleButton(
                asset: 'assets/settings.svg',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SettingsScreen();
                      },
                    ),
                  );
                },
              ),
              _CoinsCard(),
              CircleButton(
                asset: 'assets/shop.svg',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ShopScreen();
                      },
                    ),
                  );
                },
              ),
            ] else if (isGame) ...[
              CircleButton(
                asset: 'assets/back.svg',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              _CoinsCard(),
            ] else ...[
              CircleButton(
                asset: 'assets/back.svg',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'w900',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 58),
            ],
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _CoinsCard extends StatelessWidget {
  const _CoinsCard();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 58,
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xff6F18FA),
          borderRadius: BorderRadius.circular(58),
        ),
        child: Row(
          children: [
            SizedBox(width: 12),
            SvgPicture.asset('assets/coin.svg'),
            Expanded(
              child: BlocBuilder<CoinsBloc, CoinsState>(
                builder: (context, state) {
                  return Text(
                    state is CoinsLoaded ? formatCoins(state.coins) : '',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'w900',
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
