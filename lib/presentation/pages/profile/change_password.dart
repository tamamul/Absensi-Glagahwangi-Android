import 'package:flutter/material.dart';

import '../../widget/custom_button.dart';
import '../../widget/form_field.dart';

class ChangePassword extends StatelessWidget {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  ChangePassword({super.key});

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
          "Ganti Password",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Manrope",
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomFormField(
                label: "Password Lama",
                fieldName: "Password Lama",
                isPassword: true,
              ),
              const SizedBox(height: 20),
              CustomFormField(
                label: "Password Baru",
                fieldName: "New password",
                isPassword: true,
                controller: _newPasswordController,
              ),
              const SizedBox(height: 20),
              CustomFormField(
                label: "Konfirmasi Password Baru",
                fieldName: "password confirmation",
                isPassword: true,
                isConfirmPassword: true,
                controller: _confirmPasswordController,
                confirmPasswordController: _newPasswordController,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Simpan",
                onPressed: () {
                  // Handle save action here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
