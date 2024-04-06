import 'package:absensi_glagahwangi/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/color_palette.dart';
import '../../../blocs/cubits/login/login_cubit.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                BlocProvider(
                  create: (_) => LoginCubit(context.read<AuthRepository>()),
                  child: const LoginForm(),
                ),
              ],
            ),
          ),
        ));
  }
}
