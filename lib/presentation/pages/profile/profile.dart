import 'package:absensi_glagahwangi/presentation/blocs/auth/auth_bloc.dart';
import 'package:absensi_glagahwangi/presentation/pages/admin_only/sign_up.dart';
import 'package:absensi_glagahwangi/presentation/widget/custom_button.dart';
import 'package:absensi_glagahwangi/presentation/widget/custom_profile_button.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/custom_icons.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 73,
                // backgroundImage: AssetImage('assets/images/profile.png'),
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 80, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                user.email ?? "Nama Lengkap",
                style: TextStyle(
                  color: ColorPalette.main_text,
                  fontFamily: "Manrope",
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Posisi",
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
              CustomButton(text: "Edit Profile", onPressed: () {}),
              const SizedBox(
                height: 20,
              ),
              CustomProfileButton(
                text: "Profile Lengkap",
                prefixIcon: CustomIcons.profile,
                suffixIcon: Icons.arrow_forward_ios_rounded,
                onPressed: () {},
              ),
              const SizedBox(
                height: 5,
              ),
              CustomProfileButton(
                text: "Ganti Password",
                prefixIcon: CustomIcons.lock,
                suffixIcon: Icons.arrow_forward_ios_rounded,
                onPressed: () {},
              ),
              CustomProfileButton(
                // Delete Later
                text: "Make Account (Delete Later)",
                prefixIcon: CustomIcons.lock,
                suffixIcon: Icons.arrow_forward_ios_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUp(),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 5,
              ),
              CustomProfileButton(
                text: "Lupa Absen",
                prefixIcon: CustomIcons.forgot,
                suffixIcon: Icons.arrow_forward_ios_rounded,
                onPressed: () {},
              ),
              CustomLogoutButton(
                text: "Log Out",
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
