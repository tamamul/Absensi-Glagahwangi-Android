import 'package:absensi_glagahwangi/presentation/widget/custom_button.dart';
import 'package:absensi_glagahwangi/presentation/widget/form_field.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/login/login_cubit.dart';
import '../reset_password.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          // Automatically handled by FlowBuilder
        } else if (state.status == LoginStatus.error) {
          final snackBar = SnackBar(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            behavior: SnackBarBehavior.floating,
            elevation: 4,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            content: const Text(
              'Akun Tidak Ditemukan!',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Manrope",
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state.status == LoginStatus.noInternet) {
          final snackBar = SnackBar(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            behavior: SnackBarBehavior.floating,
            elevation: 4,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            content: const Text(
              'Tidak Ada Koneksi Internet!',
              style: TextStyle(
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
      child: Column(
        children: [
          BlocBuilder<LoginCubit, LoginState>(
            buildWhen: (previous, current) => previous.email != current.email,
            builder: (context, state) {
              return CustomFormField(
                fieldName: "Email",
                label: "Email",
                onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
              );
            },
          ),
          const SizedBox(height: 20),
          BlocBuilder<LoginCubit, LoginState>(
            buildWhen: (previous, current) => previous.password != current.password,
            builder: (context, state) {
              return CustomFormField(
                isPassword: true,
                fieldName: "Password",
                label: "Password",
                onChanged: (password) => context.read<LoginCubit>().passwordChanged(password),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                "Lupa Password?",
                style: TextStyle(
                  color: ColorPalette.mainText,
                  fontFamily: "Manrope",
                  fontSize: 18,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPassword(),
                    ),
                  );
                },
                child: const Text(
                  " Reset",
                  style: TextStyle(
                    color: ColorPalette.mainGreen,
                    fontFamily: "Manrope",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<LoginCubit, LoginState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return state.status == LoginStatus.submitting
                  ? const CircularProgressIndicator()
                  : CustomButton(
                text: 'Masuk',
                onPressed: () {
                  context.read<LoginCubit>().logInWithCredentials();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
