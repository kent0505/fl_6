import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/coins/coins_bloc.dart';
import 'blocs/internet/internet_bloc.dart';
import 'splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/wheel.png'), context);
    precacheImage(AssetImage('assets/o1.png'), context);
    precacheImage(AssetImage('assets/o2.png'), context);
    precacheImage(AssetImage('assets/o3.png'), context);
    precacheImage(AssetImage('assets/bg1.jpg'), context);
    precacheImage(AssetImage('assets/bg2.jpg'), context);
    precacheImage(AssetImage('assets/bg3.jpg'), context);
    precacheImage(AssetImage('assets/bg4.jpg'), context);
    precacheImage(AssetImage('assets/bg5.jpg'), context);
    precacheImage(AssetImage('assets/bg6.jpg'), context);
    precacheImage(AssetImage('assets/bg7.jpg'), context);
    precacheImage(AssetImage('assets/bg8.jpg'), context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CoinsBloc()..add(LoadCoins())),
        BlocProvider(create: (context) => InternetBloc()..add(CheckInternet())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
