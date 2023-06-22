import 'package:flutter/material.dart';
import 'package:qr_scanner/ui/screen/wellcome/components/body.dart';

class ScreenWellcome extends StatelessWidget {
  const ScreenWellcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
    );
  }
}
