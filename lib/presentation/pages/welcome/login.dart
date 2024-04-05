import 'package:absensi_glagahwangi/data/repository/auth_repository.dart';
import 'package:absensi_glagahwangi/presentation/blocs/cubits/login/login_cubit.dart';
import 'package:absensi_glagahwangi/presentation/pages/home/home.dart';
import 'package:absensi_glagahwangi/presentation/pages/navbar.dart';
import 'package:absensi_glagahwangi/presentation/widget/auth_button.dart';
import 'package:absensi_glagahwangi/presentation/widget/form_field.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forget_password.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: BlocProvider(
                    create: (_) => LoginCubit(context.read<AuthRepository>()),
                    child: LoginForm(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

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
                  :AuthButton(
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
