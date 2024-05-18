import 'package:flutter/material.dart';

import '../../values/app_colors.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.children,
    this.colors = AppColors.lightGradient,
    this.sizeFrac = 0.05,
    super.key,
  });

  final List<Color> colors;
  final List<Widget> children;
  final double sizeFrac;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
        ), gradient: LinearGradient(colors: colors)), //, begin: Alignment.topCenter, end: Alignment.bottomCenter
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: sizeFrac,
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

// extension ContextExtension on BuildContext {
//   double heightFraction({double sizeFraction = 1}) =>
//       MediaQuery.sizeOf(this).height * sizeFraction;

//   double widthFraction({double sizeFraction = 1}) =>
//       MediaQuery.sizeOf(this).width * sizeFraction;
// }