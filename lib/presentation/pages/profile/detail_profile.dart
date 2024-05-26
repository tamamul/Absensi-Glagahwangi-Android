import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/user_repository.dart';
import '../../../utils/color_palette.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/user/user_bloc.dart';

class FullProfile extends StatelessWidget {
  const FullProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = context.select((AuthBloc bloc) => bloc.state.user);

    return BlocProvider(
      create: (context) => UserBloc(userRepository: UserRepository())
        ..add(FetchUser(authUser.id!)),
      child: Scaffold(
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
          title: const Text(
            "Profile Lengkap",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Manrope",
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserInitial || state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final user = state.user;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
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
                          backgroundImage: user.picture.isNotEmpty
                              ? NetworkImage(user.picture)
                              : null,
                          backgroundColor: Colors.grey,
                          child: user.picture.isEmpty
                              ? const Icon(Icons.person, size: 80, color: Colors.white)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildProfileItem("Nama", user.name ?? "Nama Lengkap"),
                      const SizedBox(height: 20),
                      _buildProfileItem("Posisi", user.role ?? "Posisi"),
                      const SizedBox(height: 20),
                      _buildProfileItem("E-mail", user.email ?? ""),
                      const SizedBox(height: 20),
                      _buildProfileItem("No. HP", user.phone == "" ? "-" : user.phone ?? "-"),
                    ],
                  ),
                ),
              );
            } else if (state is UserError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorPalette.profile_background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: ColorPalette.profile_text,
                  fontFamily: "Manrope",
                  fontSize: 18,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: ColorPalette.main_text,
                  fontFamily: "Manrope",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
