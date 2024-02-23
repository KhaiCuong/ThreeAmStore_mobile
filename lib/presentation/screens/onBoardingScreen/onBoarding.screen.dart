import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:scarvs/app/constants/app.assets.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/presentation/screens/onBoardingScreen/widget/onBoarding.widget.dart';
import 'package:scarvs/core/models/onBoarding.model.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  final List<OnBoardingModel> cards = [
    OnBoardingModel(
      image: AppAssets.onBoardingOne,
      title: "Saving your time with a watch",
      textColor: Colors.white,
      bgColor: AppColors.mirage,
    ),
    OnBoardingModel(
      image: AppAssets.onBoardingTwo,
      title: "World Class Customer Support On Fingertips",
      bgColor: AppColors.creamColor,
      textColor: AppColors.mirage,
    ),
    OnBoardingModel(
      image: AppAssets.onBoardingThree,
      title: "Saving your Money when buy on THREE AM",
      bgColor: AppColors.rawSienna,
      textColor: Colors.white,
    ),
  ];

  List<Color> get colors => cards.map((p) => p.bgColor).toList();

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: widget.colors,
        radius: 30,
        itemCount: 3,
        curve: Curves.ease,
        duration: const Duration(seconds: 2),
        itemBuilder: (index) {
          OnBoardingModel card = widget.cards[index % widget.cards.length];
          return PageCard(card: card);
        },
        onFinish: () {
          Navigator.of(context).pushReplacementNamed(AppRouter.splashRoute);
        },
      ),
    );
  }
}
