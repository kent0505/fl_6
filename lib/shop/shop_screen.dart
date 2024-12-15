import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/coins/coins_bloc.dart';
import '../utils.dart';
import '../widgets/my_button.dart';
import '../widgets/my_scaffold.dart';
import '../widgets/primary_button.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool bought1 = false;
  bool bought2 = false;
  bool bought3 = false;
  bool bought4 = false;
  bool bought5 = false;
  bool bought6 = false;
  bool bought7 = false;
  bool bought8 = false;

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    bought1 = prefs.getBool('bought1') ?? false;
    bought2 = prefs.getBool('bought2') ?? false;
    bought3 = prefs.getBool('bought3') ?? false;
    bought4 = prefs.getBool('bought4') ?? false;
    bought5 = prefs.getBool('bought5') ?? false;
    bought6 = prefs.getBool('bought6') ?? false;
    bought7 = prefs.getBool('bought7') ?? false;
    bought8 = prefs.getBool('bought8') ?? false;
    setState(() {});
  }

  void onBuy(int id, int price) async {
    final prefs = await SharedPreferences.getInstance();
    int coins = prefs.getInt('coins') ?? 300;
    if (coins >= price) {
      if (mounted) {
        context.read<CoinsBloc>().add(SaveBG(id: id));
        context.read<CoinsBloc>().add(SaveCoins(
              amount: price,
              isBuy: true,
            ));
      }
      await prefs.setBool('bought$id', true);
      if (id == 1) bought1 = true;
      if (id == 2) bought2 = true;
      if (id == 3) bought3 = true;
      if (id == 4) bought4 = true;
      if (id == 5) bought5 = true;
      if (id == 6) bought6 = true;
      if (id == 7) bought7 = true;
      if (id == 8) bought8 = true;
      setState(() {});
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return _ErrorDialog();
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Shop',
      body: BlocBuilder<CoinsBloc, CoinsState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              SizedBox(height: 8),
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ShipItem(
                    id: 1,
                    price: 300,
                    title: 'Abstract Angles',
                    isBought: bought1,
                    onPressed: onBuy,
                  ),
                  _ShipItem(
                    id: 2,
                    price: 300,
                    title: 'Prismatic Grid',
                    isBought: bought2,
                    onPressed: onBuy,
                  ),
                ],
              ),
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ShipItem(
                    id: 3,
                    price: 300,
                    title: 'Crystal Polygons',
                    isBought: bought3,
                    onPressed: onBuy,
                  ),
                  _ShipItem(
                    id: 4,
                    price: 300,
                    title: 'Neon Alley',
                    isBought: bought4,
                    onPressed: onBuy,
                  ),
                ],
              ),
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ShipItem(
                    id: 5,
                    price: 300,
                    title: 'Volcanic Horizon',
                    isBought: bought5,
                    onPressed: onBuy,
                  ),
                  _ShipItem(
                    id: 6,
                    price: 300,
                    title: 'Moonlit Forest',
                    isBought: bought6,
                    onPressed: onBuy,
                  ),
                ],
              ),
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ShipItem(
                    id: 7,
                    price: 300,
                    title: 'Lunar Landscape',
                    isBought: bought7,
                    onPressed: onBuy,
                  ),
                  _ShipItem(
                    id: 8,
                    price: 300,
                    title: 'Hidden Temple',
                    isBought: bought8,
                    onPressed: onBuy,
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}

class _ShipItem extends StatelessWidget {
  const _ShipItem({
    required this.id,
    required this.price,
    required this.title,
    required this.isBought,
    required this.onPressed,
  });

  final int id;
  final int price;
  final String title;
  final bool isBought;
  final void Function(int, int) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 222,
      width: 175,
      margin: EdgeInsets.only(bottom: 8),
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
          MyButton(
            onPressed: isBought
                ? () {
                    context.read<CoinsBloc>().add(SaveBG(id: id));
                  }
                : null,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/bg$id.jpg',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  isBought
                      ? Container()
                      : Positioned(
                          top: 12,
                          right: 8,
                          child: Row(
                            children: [
                              Text(
                                formatCoins(price),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'w700',
                                ),
                              ),
                              SvgPicture.asset('assets/coin.svg'),
                            ],
                          ),
                        ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
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
                ],
              ),
            ),
          ),
          Spacer(),
          isBought
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bought',
                      style: TextStyle(
                        color: Color(0xffF6D303),
                        fontSize: 20,
                        fontFamily: 'w900',
                      ),
                    ),
                    SizedBox(width: 10),
                    SvgPicture.asset('assets/bought.svg'),
                  ],
                )
              : PrimaryButton(
                  title: 'Buy',
                  onPressed: () {
                    onPressed(id, price);
                  },
                ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ErrorDialog extends StatelessWidget {
  const _ErrorDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 172,
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
                'You don’t have enough coins on your balance to buy background.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'w400',
                ),
              ),
            ),
            Spacer(),
            PrimaryButton(
              title: 'Okay',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
