import 'package:absensi_glagahwangi/presentation/widget/auth_button.dart';
import 'package:absensi_glagahwangi/presentation/widget/form_field.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'forget_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const Center(
                    child: Image(
                        image: AssetImage('assets/images/logo.png'),
                        height: 140)),
                const Text(
                  'Selamat Datang',
                  style: TextStyle(
                    color: ColorPalette.main_text,
                    fontFamily: "Manrope",
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.start,
                ),
                const Text(
                  "Silahkan Masuk dengan Username dan Password yang Telah Diberikan",
                  style: TextStyle(
                    color: ColorPalette.secondary_text,
                    fontFamily: "Manrope",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const CustomFormField(
                          fieldName: "Username", label: "Username"),
                      const SizedBox(
                        height: 20,
                      ),
                      const CustomFormField(
                        fieldName: "Password",
                        label: "Password",
                        isPassword: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Lupa Password?",
                            style: TextStyle(
                              color: ColorPalette.main_text,
                              fontFamily: "Manrope",
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgetPassword(),
                                ),
                              );
                            },
                            child: const Text(
                              " Reset",
                              style: TextStyle(
                                color: ColorPalette.main_green,
                                fontFamily: "Manrope",
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      authButton(text: "MASUK", onTap: () {})
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
