import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_scanner/ui/components/rounded_button.dart';
import 'package:qr_scanner/ui/components/rounded_input_field.dart';
import 'package:qr_scanner/ui/components/rounded_password_field.dart';
import 'package:qr_scanner/ui/screen/login/login_screen.dart';
import 'package:qr_scanner/ui/screen/device_screen/device_screen.dart';
import 'package:qr_scanner/ui/screen/register/components/background.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "SIGNUP",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SvgPicture.asset(
                "assets/icons/signup.svg",
                height: size.height * 0.35,
              ),
              RoundedInputField(
                hintText: "Email",
                onChange: (value) {},
              ),
              RoundedPasswordField(
                onChanged: (value) {},
              ),
              RoundedButton(
                  text: "SIGN UP",
                  press: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ScreenListDevices();
                    }));
                  }),
              InkWell(
                child: RichText(
                  text: const TextSpan(
                    text: 'Do you already have an account?  ',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
