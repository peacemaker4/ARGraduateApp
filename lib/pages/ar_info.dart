import 'package:bouncing_button/bouncing_button.dart';
import 'package:flutter/material.dart';

class ArInfoPage extends StatelessWidget {
  const ArInfoPage({super.key});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 58, 16, 16),
      child: Container(
        width: double.infinity,
        child: Column(children: [
          Text('Opening Unity', style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold
            ),
          ),
        ]
      )
      ),
    );
  }
}
