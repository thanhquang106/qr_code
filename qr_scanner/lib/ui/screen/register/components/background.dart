import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/signup_top.png",
                width: size.width * 0.3,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(
                "assets/images/main_bottom.png",
                width: size.width * 0.3,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
