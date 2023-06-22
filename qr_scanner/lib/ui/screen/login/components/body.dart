import 'package:flutter/material.dart';
import 'package:qr_scanner/controller/authentication_controller.dart';
import 'package:qr_scanner/ui/components/rounded_button.dart';
import 'package:qr_scanner/ui/components/rounded_input_field.dart';
import 'package:qr_scanner/ui/screen/login/components/background.dart';
import '../../../components/rounded_password_field.dart';

class Body extends StatefulWidget {
  const Body({
    super.key,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String name = "";
  String pass = "";
  final AuthenticationController _auth = AuthenticationController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // lightGradie
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(130, 0, 0, 0),
                  borderRadius: BorderRadius.circular(20)),
              height: 400,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 45,
                    ),
                  ),
                  RoundedInputField(
                    hintText: "ems_dev@iotmind.vn",
                    onChange: (value) {
                      name = value;
                    },
                  ),
                  RoundedPasswordField(
                    onChanged: (value) {
                      pass = value;
                    },
                  ),
                  RoundedButton(
                      text: "LOGIN",
                      press: () {
                        _auth.login(
                            email: name, password: pass, context: context);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
