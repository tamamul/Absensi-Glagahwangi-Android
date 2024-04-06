
import 'package:absensi_glagahwangi/presentation/blocs/cubits/login/login_cubit.dart';

import 'package:absensi_glagahwangi/presentation/widget/custom_button.dart';
import 'package:absensi_glagahwangi/presentation/widget/form_field.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../forget_password.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Login Gagal')));
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
          const SizedBox(
            height: 20,
          ),
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
            height: 20,
          ),
          BlocBuilder<LoginCubit, LoginState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return state.status == LoginStatus.submitting
                  ? const CircularProgressIndicator()
                  :CustomButton(
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
