import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/user_repository.dart';
import '../../../utils/color_palette.dart';
import '../../blocs/user/user_bloc.dart';
import '../../widget/custom_button.dart';
import '../../widget/form_field.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
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
                      color: ColorPalette.mainText,
                      fontFamily: "Manrope",
                      fontSize: 36,
                      fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Masukkan Email yang Sudah Ditautkan Dengan Akun",
                  style: TextStyle(
                      color: ColorPalette.secondaryText,
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
                      CustomFormField(
                        fieldName: "Email",
                        label: "Email",
                        isEmail: true,
                        controller: emailController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocProvider(
                        create: (context) => UserBloc(userRepository: UserRepository()),
                        child: BlocConsumer<UserBloc, UserState>(
                          listener: (context, state) {
                            if (state is UserForgetPasswordSuccess) {
                              final snackBar = SnackBar(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                behavior: SnackBarBehavior.floating,
                                elevation: 4,
                                backgroundColor: ColorPalette.mainGreen,
                                duration: const Duration(seconds: 3),
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
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            } else if (state is UserForgetPasswordFailure) {
                              final snackBar = SnackBar(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                behavior: SnackBarBehavior.floating,
                                elevation: 4,
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                                content: Text(
                                  state.error,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Manrope",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          },
                          builder: (context, state) {
                            return CustomButton(
                              text: "KIRIM",
                              onPressed: () {
                                final email = emailController.text;
                                context.read<UserBloc>().add(ForgetPasswordEvent(email));
                              },
                            );
                          },
                        ),
                      ),
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
