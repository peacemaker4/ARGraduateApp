import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../values/app_colors.dart';

class CustomLoadingWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(children: [
        Center(
          child: Container(
            height: 150,
            width: 150,
            child: SpinKitChasingDots(
              color: AppColors.primaryColor,
              size: 50.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5)
              )]
            ),
          ),
        )
      ]),
    );
  }
}

// extension ContextExtension on BuildContext {
//   double heightFraction({double sizeFraction = 1}) =>
//       MediaQuery.sizeOf(this).height * sizeFraction;

//   double widthFraction({double sizeFraction = 1}) =>
//       MediaQuery.sizeOf(this).width * sizeFraction;
// }