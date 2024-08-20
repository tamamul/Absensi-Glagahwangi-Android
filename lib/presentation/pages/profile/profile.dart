import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absensi_glagahwangi/presentation/blocs/auth/auth_bloc.dart';
import 'package:absensi_glagahwangi/presentation/pages/profile/change_password.dart';
import 'package:absensi_glagahwangi/presentation/pages/profile/edit_profile.dart';
import 'package:absensi_glagahwangi/presentation/widget/custom_button.dart';
import 'package:absensi_glagahwangi/presentation/widget/custom_profile_button.dart';
import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:absensi_glagahwangi/presentation/widget/custom_icons.dart';

import '../../../data/repository/user_repository.dart';
import '../../blocs/user/user_bloc.dart';
import 'detail_profile.dart';
import 'forgot_attendance.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = context.select((UserBloc bloc) => bloc.state.user);

    return BlocProvider(
      create: (context) => UserBloc(userRepository: UserRepository())
        ..add(getUser(authUser.id)),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: SingleChildScrollView(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInitial || state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserLoaded) {
                  final user = state.user;
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 73,
                          backgroundImage: NetworkImage(user.picture),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: ColorPalette.mainText,
                          fontFamily: "Manrope",
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        user.role,
                        style: const TextStyle(
                          color: ColorPalette.secondaryText,
                          fontFamily: "Manrope",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: "Edit Profile",
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfile(),
                            ),
                          );
                          if (result == true) {
                            // Trigger a reload of the user data
                            context
                                .read<UserBloc>()
                                .add(getUser(authUser.id));
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomProfileButton(
                        text: "Profile Lengkap",
                        prefixIcon: CustomIcons.profile,
                        suffixIcon: Icons.arrow_forward_ios_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FullProfile(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      CustomProfileButton(
                        text: "Ganti Password",
                        prefixIcon: CustomIcons.lock,
                        suffixIcon: Icons.arrow_forward_ios_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePassword(email: user.email,),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      CustomProfileButton(
                        text: "Lupa Absen",
                        prefixIcon: CustomIcons.forgot,
                        suffixIcon: Icons.arrow_forward_ios_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotAttendance(),
                            ),
                          );
                        },
                      ),
                      CustomLogoutButton(
                        text: "Log Out",
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthLogout());
                        },
                      ),
                    ],
                  );
                } else if (state is UserError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
