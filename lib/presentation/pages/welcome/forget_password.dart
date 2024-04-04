import 'package:flutter/material.dart';

import '../../../utils/color_palette.dart';
import '../../widget/auth_button.dart';
import '../../widget/form_field.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Image(
                    image: AssetImage('assets/images/key_reset.png'),
                    height: 79),
                const Text(
                  "Reset Password",
                  style: TextStyle(
                      color: ColorPalette.main_text,
                      fontFamily: "Manrope",
                      fontSize: 36,
                      fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Masukkan Email yang Sudah Ditautkan Dengan Akun",
                  style: TextStyle(
                      color: ColorPalette.secondary_text,
                      fontFamily: "Manrope",
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  child: Column(
                    children: [
                      const CustomFormField(
                        fieldName: "Email",
                        label: "Email",
                        isEmail: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      authButton(
                          text: "KIRIM",
                          onTap: () {
                            {
                              final snackBar = SnackBar(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                behavior: SnackBarBehavior.floating,
                                elevation: 4,
                                backgroundColor: ColorPalette.main_green,
                                duration: Duration(seconds: 3),
                                content: const Text(
                                  'Permintaan Reset Password Telah Dikirim!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Manrope",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: kToolbarHeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
