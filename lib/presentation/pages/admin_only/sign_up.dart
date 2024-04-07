import 'package:absensi_glagahwangi/data/repository/admin_repository.dart';
import 'package:absensi_glagahwangi/presentation/cubits/admin/sign_up/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/custom_button.dart';
import '../../widget/form_field.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          "Buat Pengguna Baru",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Manrope",
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: BlocProvider(
          create: (_) => SignUpCubit(context.read<AdminRepository>()),
          child: SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          Navigator.pop(context);
        }
      },
      child: Column(
        children: [
          BlocBuilder<SignUpCubit, SignupState>(
            buildWhen: (previous, current) => previous.email != current.email,
            builder: (context, state) {
              return CustomFormField(
                fieldName: "Email",
                label: "Email",
                onChanged: (email) =>
                    context.read<SignUpCubit>().emailChanged(email),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<SignUpCubit, SignupState>(
            buildWhen: (previous, current) => previous.name != current.name,
            builder: (context, state) {
              return CustomFormField(
                fieldName: "Nama Lengkap",
                label: "Nama Lengkap",
                onChanged: (name) =>
                    context.read<SignUpCubit>().nameChanged(name),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<SignUpCubit, SignupState>(
            buildWhen: (previous, current) => previous.role != current.role,
            builder: (context, state) {
              return CustomFormField(
                fieldName: "Posisi",
                label: "Posisi",
                onChanged: (role) =>
                    context.read<SignUpCubit>().roleChanged(role),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<SignUpCubit, SignupState>(
            buildWhen: (previous, current) =>
                previous.password != current.password,
            builder: (context, state) {
              return CustomFormField(
                fieldName: "Password",
                label: "Password",
                isPassword: true,
                onChanged: (password) =>
                    context.read<SignUpCubit>().passwordChanged(password),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<SignUpCubit, SignupState>(
            buildWhen: (previous, current) =>
                previous.confirmPassword != current.confirmPassword,
            builder: (context, state) {
              return CustomFormField(
                fieldName: "Konfirmasi Password",
                label: "Konfirmasi Password",
                onChanged: (confirm_password) =>
                    context.read<SignUpCubit>().emailChanged(confirm_password),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            text: "Buat",
            onPressed: () {
              context.read<SignUpCubit>().signupFormSubmitted();
            },
          ),
        ],
      ),
    );
  }
}
